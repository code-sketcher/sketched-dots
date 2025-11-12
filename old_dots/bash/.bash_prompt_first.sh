black="\[\e[0;30m\]"
red="\[\e[0;31m\]"
green="\[\e[0;32m\]"
yellow="\[\e[0;33m\]"
blue="\[\e[0;34m\]"
purple="\[\e[0;35m\]"
cyan="\[\e[0;36m\]"
white="\[\e[0;37m\]"
orange="\[\e[0;91m\]"

bold_black="\[\e[30;1m\]"
bold_red="\[\e[31;1m\]"
bold_green="\[\e[32;1m\]"
bold_yellow="\[\e[33;1m\]"
bold_blue="\[\e[34;1m\]"
bold_purple="\[\e[35;1m\]"
bold_cyan="\[\e[36;1m\]"
bold_white="\[\e[37;1m\]"
bold_orange="\[\e[91;1m\]"

underline_black="\[\e[30;4m\]"
underline_red="\[\e[31;4m\]"
underline_green="\[\e[32;4m\]"
underline_yellow="\[\e[33;4m\]"
underline_blue="\[\e[34;4m\]"
underline_purple="\[\e[35;4m\]"
underline_cyan="\[\e[36;4m\]"
underline_white="\[\e[37;4m\]"
underline_orange="\[\e[91;4m\]"

background_black="\[\e[40m\]"
background_red="\[\e[41m\]"
background_green="\[\e[42m\]"
background_yellow="\[\e[43m\]"
background_blue="\[\e[44m\]"
background_purple="\[\e[45m\]"
background_cyan="\[\e[46m\]"
background_white="\[\e[47;1m\]"
background_orange="\[\e[101m\]"

normal="\[\e[0m\]"
reset_color="\[\e[39m\]"

GIT_UNTRACKED_CHAR="${bold_red}⌀${normal}"
GIT_UNSTAGED_CHAR="${bold_yellow}•${normal}"
GIT_STAGED_CHAR="${bold_green}+${normal}"
GIT_BEHIND_CHAR="${bold_red}↓${normal}"
GIT_AHEAD_CHAR="${bold_green}↑${normal}"
GIT_DIVERGED_CHAR="${bold_red}⇄ ${normal}"

X_CHAR=" ${bold_red}✗ "
CHECKED_CHAR=" ${bold_green}✓"
DOTTED_ARROW_CHAR="${purple}⤏ ${normal}"

GIT_CHAR_BITBUCKET="${purple} ${normal} "
GIT_CHAR_GITHUB="${purple}  ${normal}"
GIT_CHAR_DEFAULT="${purple} ${normal}"
SVN_CHAR="⑆"
EXIT_CODE_ICON=" "
COMMAND_DURATION_ICON="$bold_blue  "
HIGHER_THAN_CHAR="❯"
CONNECT_TOP_CHAR="╭─"
CONNECT_BOTTOM_CHAR="╰▶"

function setCurrentBranch() {
    CURRENT_BRANCH="$(git symbolic-ref --short HEAD)"

    UPSTREAM="$(@{u} 2>/dev/null)"
    if [[ '' != "$UPSTREAM" ]]; then
        REMOTE_BRANCH="$(git rev-parse --abbrev-ref --symbolic-full-name "$UPSTREAM")"
    else
        REMOTE_BRANCH="origin/$CURRENT_BRANCH"
    fi
}

function countUnstagedFiles() {
    TOTAL_UNSTAGED_FILES="$(git diff --name-only | wc -l)"
}

function countStagedFiles() {
    TOTAL_STAGED_FILES="$(git diff --name-only --cached | wc -l)"
}

function countUntrackedFiles() {
    TOTAL_UNTRACKED_FILES="$(git ls-files --others --exclude-standard --directory --no-empty-directory | wc -l)"
}

function countCommitsAhead() {
    COMMITS_AHEAD="$(git rev-list --left-right $REMOTE_BRANCH..$CURRENT_BRANCH 2>/dev/null | wc -l)"
}

function countCommitsBehind() {
    COMMITS_BEHIND="$(git rev-list --left-right $CURRENT_BRANCH..$REMOTE_BRANCH 2>/dev/null | wc -l)"
}

function isMergeProcessOn() {
    local commits
    commits="$(git rev-parse -q --verify MERGE_HEAD | wc -l)"

    [ "$commits" != 0 ]
}

function areConflicts() {
    local conflicts
    conflicts="$(git ls-files --unmerged | wc -l)"

    [ "$conflicts" != 0 ]
}

function isNotGitRepository() {
    local repo_info
    repo_info="$(git rev-parse --git-dir 2>/dev/null)"

    [ -z "$repo_info" ]
}

setIcon() {
	REMOTE_URL="$(git config --get remote.origin.url 2>&1)"
	ICON=''
	if [[ "$REMOTE_URL" == *"stash.emag"* ]]; then
		ICON="$GIT_CHAR_BITBUCKET"
	fi
	if [[ "$REMOTE_URL" == *"github"* ]]; then
		ICON="$GIT_CHAR_GITHUB"
	fi
}

formatBranch() {
    if isNotGitRepository; then
        FORMATTED_BRANCH=""
        return
    fi
    FORMATTED_BRANCH=" on "
    setCurrentBranch

    if areConflicts; then
        FORMATTED_BRANCH+="$red$CURRENT_BRANCH|CONFLICT$normal"
    elif isMergeProcessOn; then
        FORMATTED_BRANCH+="$yellow$CURRENT_BRANCH|MERGING$normal"
    else
        FORMATTED_BRANCH+="$green$CURRENT_BRANCH$normal"
    fi

    countStagedFiles
    if [[ "$TOTAL_STAGED_FILES" != 0 ]]; then
        FORMATTED_BRANCH+=" $GIT_STAGED_CHAR$green$TOTAL_STAGED_FILES$normal"
    fi

    countUnstagedFiles
    if [[ "$TOTAL_UNSTAGED_FILES" != 0 ]]; then
        FORMATTED_BRANCH+=" $GIT_UNSTAGED_CHAR$yellow$TOTAL_UNSTAGED_FILES$normal"
    fi

    countUntrackedFiles
    if [[ "$TOTAL_UNTRACKED_FILES" != 0 ]]; then
        FORMATTED_BRANCH+=" $GIT_UNTRACKED_CHAR$red$TOTAL_UNTRACKED_FILES$normal"
    fi

    countCommitsAhead
    countCommitsBehind

    if [[ "$COMMITS_AHEAD" != 0 ]]; then
        FORMATTED_BRANCH+=" $GIT_AHEAD_CHAR$bold_green$COMMITS_AHEAD$normal"
    fi

    if [[ "$COMMITS_BEHIND" != 0 ]]; then
        FORMATTED_BRANCH+=" $GIT_BEHIND_CHAR$bold_red$COMMITS_BEHIND$normal"
    fi
}

function setPS1() {
    local exit_status="$?"
    USER_HOST="$cyan\u@\h:$normal"
    CURRENT_DIR="$blue\w$normal"

    PS1=""
    if [[ "$exit_status" != 0 ]]; then
        PS1+="$X_CHAR"
    fi
    setIcon
    formatBranch
    PS1+="$ICON${purple}[\D{%H:%M:%S}] $USER_HOST$CURRENT_DIR$FORMATTED_BRANCH\n $DOTTED_ARROW_CHAR"

    return $exit_status
}
PROMPT_COMMAND=setPS1
