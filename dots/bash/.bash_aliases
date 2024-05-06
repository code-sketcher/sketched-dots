#Git
alias gst='git status'
alias gcb='git checkout -b'
alias gc='git checkout'
alias gcl='git checkout ~'
alias gp='git pull'
alias grh='git reset --hard HEAD'
alias ggp='git push origin "$(git symbolic-ref --short HEAD)"'
alias ggsup='git branch --set-upstream-to=origin/"$(git symbolic-ref --short HEAD)"'
alias gmm='git merge origin/master'
alias gaa='git add --all'
alias gcm='git commit -m'

#--------------------------------------------------------------------------------------------------------------------------------------------#
#Docker
alias dlogs='docker logs'

#--------------------------------------------------------------------------------------------------------------------------------------------#
#PHP
alias phpcv='sudo update-alternatives --set php /usr/bin/php'

#--------------------------------------------------------------------------------------------------------------------------------------------#
#Xdebug
alias xdebug='php -d xdebug.start_with_request=yes -d xdebug.idekey=XDEBUG_KEY'
alias xdebugold='SSH_IP=${SSH_CONNECTION%% *} && export XDEBUG_CONFIG="idekey=xdebug.key remote_host=$SSH_IP remote_enable=1"'

#--------------------------------------------------------------------------------------------------------------------------------------------#
#Memcache
alias memclear='echo "flush_all" | nc 127.0.0.1 11211 && echo "flush_all" | nc 127.0.0.1 11212'

#--------------------------------------------------------------------------------------------------------------------------------------------#
#FUCK
alias fuck='echo "sudo $(history | tail -n 2 | head -n 1 | cut -c8-)" && sudo $(history | tail -n 2 | head -n 1 | cut -c8-)'

#--------------------------------------------------------------------------------------------------------------------------------------------#
#Space
alias space-taking='du -sh *'
alias space='df -h'
#--------------------------------------------------------------------------------------------------------------------------------------------#
#Kitty
alias broadcast_to_tab='kitty +kitten broadcast --match-tab state:focused'
#--------------------------------------------------------------------------------------------------------------------------------------------#
