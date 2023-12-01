function isKittyTerminal() {
    local kitty_word_found_times
    kitty_word_found_times="$(printenv | grep -c kitty)"

    [ "$kitty_word_found_times" != 0 ]
}

function shouldCopyFile() {
    [[ "$HOST" == dev* ]] || [[ "$HOST" == test* ]]
}

function isProd() {
    [[ "$HOST" == *prod* ]] || [[ "$HOST" == *edeploy* ]] || [[ "$HOST" == *www* ]] || [[ "$HOST" == *worker* ]]
}

function isStage(){
    [[ "$HOST" == *stage* ]]
}

function runKittyConfig() {
    if isKittyTerminal; then
        kitty @ set-window-title "$HOST" 
        if isProd && [[ "$HOST" != *stage* ]]; then
            kitty @ set-colors ~/.config/kitty/themes/ubuntu.conf
            ICON="$HOME/.config/kitty/icons/prod-icon-red.png"
        fi

        if isStage; then
            kitty @ set-colors ~/.config/kitty/themes/batman.conf
            ICON="$HOME/.config/kitty/icons/prod-icon-yellow.png"
        fi

        kitty @ set-window-logo --no-response "$ICON"
    fi
}

ssh() {
    SSHAPP="$(which ssh)";
    ARGS=$@;
    echo "switching to $ARGS";
    printf "\033]7;file://%s/\007" "$ARGS";

    ICON="none"

    for HOST in $ARGS; do :; done

    if shouldCopyFile && isKittyTerminal; then
#        rsync -hvrPt ~/.config/bash-unite/* "$ARGS:~/bash-unite"
#        rsync -hvrPt ~/.config/bash-unite/remote-bashrc "$ARGS:~/.bashrc"
#	     rsync -hvrPt ~/.config/bash-unite/.vim "$ARGS:~/"

        ICON="$HOME/.config/kitty/icons/code.png"
        SSHAPP="kitten ssh"
    fi

    runKittyConfig
    $SSHAPP $ARGS;
}
