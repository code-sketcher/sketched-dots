# Search the *Wiki.md files in WIKI_DIR and the note folders in WIKI_NOTES_DIRS from the shell.
# Loaded from ~/.bashrc. Set the folders in ~/.config/wiki/config (not tracked in git):
#   WIKI_DIR=$HOME/path/to/wiki
#   WIKI_NOTES_DIRS=$HOME/path/to/notes:$HOME/other/notes

WIKI_CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}/wiki/config
[[ -f $WIKI_CONFIG ]] && source "$WIKI_CONFIG"

wiki_usage() {
  cat <<'USAGE'
usage:
  wiki <term>...          print the ### sections and note sections matching all terms
  wiki tag <tag> [<term>...]
                          print the sections of notes tagged <tag> (or <tag>/...) matching all terms
  wiki open <term>...     pick one of the matching sections with fzf and open it in nvim
  wiki command <term>...  print the php commands under ## Crons matching all terms
  wiki copy <term>...     pick one of those commands with fzf and copy it to the clipboard
  wiki help               show this help

Searches every *Wiki.md file in WIKI_DIR, case-insensitive.
`wiki <term>` also searches every .md note under WIKI_NOTES_DIRS (colon-separated),
split on #, ## and ### headings; note names and frontmatter tags count as matches.
Set both in ~/.config/wiki/config.
USAGE
}

wiki_render() {
  local lang=$1
  if [[ ! -t 1 ]]; then
    cat
  elif [[ $lang == markdown ]] && command -v glow >/dev/null; then
    glow -
  elif command -v bat >/dev/null; then
    bat --language "$lang" --style plain --paging never
  else
    cat
  fi
}

wiki_search() {
  local mode=$1
  shift
  awk -v mode="$mode" -v terms="$*" '
    BEGIN { n = split(tolower(terms), want, " ") }

    function matches(text,   i) {
      text = tolower(text)
      for (i = 1; i <= n; i++) if (index(text, want[i]) == 0) return 0
      return 1
    }

    function print_block(   i, name) {
      if (mode == "commands") {
        for (i = 1; i <= ncmd; i++) if (matches(title "\n" cmd[i])) print cmd[i]
        return
      }
      if (mode == "locations") {
        name = title
        sub(/^### +/, "", name)
        printf "%s\t%d\t%s\n", file, start, name
        return
      }
      sub(/\n+$/, "\n", block)
      if (printed++) print ""
      printf "`%s`\n%s", file, block
    }

    function flush() {
      if (block == "") return
      if (mode == "commands" || matches(section "\n" block)) print_block()
      block = ""
      ncmd = 0
    }

    FNR == 1 { flush(); section = ""; collecting = 0 }
    /^## /   { flush(); section = $0; collecting = 0; next }
    /^### /  {
      flush()
      title = $0
      file = FILENAME
      start = FNR
      collecting = (mode != "commands" || section ~ /^## Crons/)
    }
    collecting {
      block = block $0 "\n"
      if ($0 ~ /^php /) cmd[++ncmd] = $0
    }
    END { flush() }
  ' "$WIKI_DIR"/*Wiki.md
}

wiki_note_files() {
  local dirs dir
  [[ -n $WIKI_NOTES_DIRS ]] || return 0
  IFS=: read -ra dirs <<<"$WIKI_NOTES_DIRS"
  for dir in "${dirs[@]}"; do
    [[ -d $dir ]] && find "$dir" -name '*.md' -not -path '*/.*/*' -print0
  done
}

wiki_search_notes() {
  local mode=$1 tag=$2
  shift 2
  wiki_note_files | xargs -0 awk -v mode="$mode" -v tag="$tag" -v terms="$*" '
    BEGIN {
      n = split(tolower(terms), want, " ")
      tag = tolower(tag)
      sub(/^#/, "", tag)
    }

    function matches(text,   i) {
      text = tolower(text)
      for (i = 1; i <= n; i++) if (index(text, want[i]) == 0) return 0
      return 1
    }

    function add_tags(line,   parts, k, i) {
      sub(/^tags:/, "", line)
      sub(/^[ \t]*- /, "", line)
      gsub(/[][,"]/, " ", line)
      k = split(tolower(line), parts, /[ \t]+/)
      for (i = 1; i <= k; i++) {
        sub(/^#/, "", parts[i])
        if (parts[i] != "") tags = tags " " parts[i] " "
      }
    }

    function has_tag() {
      return tag == "" || index(tags, " " tag " ") || index(tags, " " tag "/")
    }

    function flush(   name) {
      if (body ~ /[^ \t\n-]/ && has_tag() && matches(note "\n" meta "\n" heading "\n" body)) {
        name = note (heading == "" ? "" : " › " heading)
        if (mode == "locations") {
          printf "%s\t%d\t%s\n", path, start, name
        } else {
          sub(/\n+$/, "\n", body)
          printf "\n`%s`\n### %s\n%s", path, name, body
        }
      }
      body = ""
    }

    FNR == 1 {
      flush()
      path = FILENAME
      note = FILENAME
      sub(/.*\//, "", note)
      sub(/\.md$/, "", note)
      heading = ""
      start = 1
      meta = ""
      tags = ""
      in_tags = 0
      front = ($0 == "---")
      if (front) next
    }
    front && $0 == "---" { front = 0; next }
    front {
      meta = meta $0 "\n"
      if ($0 !~ /^[ \t-]/) in_tags = ($0 ~ /^tags:/)
      if (in_tags) add_tags($0)
      next
    }
    /^##?#? /  { flush(); heading = $0; sub(/^#+ +/, "", heading); start = FNR; next }
               { body = body $0 "\n" }
    END        { flush() }
  '
}

wiki_clipboard() {
  if command -v pbcopy &>/dev/null; then pbcopy
  elif [[ -n $WAYLAND_DISPLAY ]] && command -v wl-copy &>/dev/null; then wl-copy
  elif command -v xclip &>/dev/null; then xclip -selection clipboard
  elif command -v xsel &>/dev/null; then xsel --clipboard --input
  else
    echo "wiki: no clipboard tool found (install wl-clipboard, xclip or xsel)" >&2
    return 1
  fi
}

wiki_copy() {
  local picked
  picked=$(wiki_search commands "$@" | fzf) || return
  printf '%s' "$picked" | wiki_clipboard || return
  echo "copied: $picked"
}

wiki_open() {
  local picked file line
  picked=$(
    { wiki_search locations "$@"; wiki_search_notes locations "" "$@"; } |
      fzf --select-1 --exit-0 --delimiter '\t' --with-nth 3,1
  ) || return
  IFS=$'\t' read -r file line _ <<<"$picked"
  nvim "+$line" "$file"
}

wiki() {
  if [[ ! -d $WIKI_DIR ]]; then
    echo "wiki: set WIKI_DIR to your wiki folder in $WIKI_CONFIG" >&2
    return 1
  fi
  case $1 in
    command) shift; wiki_search commands "$@" | wiki_render bash ;;
    copy)    shift; wiki_copy "$@" ;;
    open)    shift; wiki_open "$@" ;;
    tag)     shift; [[ -n $1 ]] || { wiki_usage >&2; return 1; }; wiki_search_notes sections "$@" | wiki_render markdown ;;
    help)    wiki_usage ;;
    "")      wiki_usage >&2; return 1 ;;
    *)       { wiki_search sections "$@"; wiki_search_notes sections "" "$@"; } | wiki_render markdown ;;
  esac
}
