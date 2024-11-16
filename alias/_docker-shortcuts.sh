#!/bin/bash

alias dstop='docker-compose down'
alias dstart='docker-compose up'
alias dstartd='docker-compose up -d'
alias dshow='docker ps'
alias stopdocker='docker stop $(docker ps -aq)'
alias rmdocker='docker rm $(docker ps -aq)'
alias copydockerdb='docker exec auth_system_db /bin/bash -c 'echo "User: postgres, Database: auth_system, Password: $POSTGRES_PASSWORD"' | xclip -selection clipboard'

alias createdb='source /home/remcostoeten/projects/zsh-setup/utils/_create-db-docker.sh'