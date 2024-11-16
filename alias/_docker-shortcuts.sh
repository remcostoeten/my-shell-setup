#!/bin/bash

alias dstop='docker-compose down'
alias dstart='docker-compose up'
alias dstartd='docker-compose up -d'
alias dshow='docker ps'
alias stopdocker='docker stop $(docker ps -aq)'
alias rmdocker='docker rm $(docker ps -aq)'
alias copydockerdb='docker exec auth_system_db /bin/bash -c 'echo "User: postgres, Database: auth_system, Password: $POSTGRES_PASSWORD"' | xclip -selection clipboard'
alias rmpostgres='read -p "Are you sure you want to remove all PostgreSQL Docker resources? (y/n) " answer && [[ $answer = y ]] && { echo "Removing PostgreSQL resources..."; docker-compose down -v; docker volume ls | grep postgres | cut -d " " -f 6 | xargs -r docker volume rm; docker image ls | grep postgres | tr -s " " | cut -d " " -f 1,2 | tr " " ":" | xargs -r docker rmi; echo "Done!"; } || echo "Operation cancelled"'
alias createdb='source /home/remcostoeten/projects/zsh-setup/utils/_create-db-docker.sh'

