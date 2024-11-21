#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

confirm_action() {
    local message=$1
    echo -e "${YELLOW}WARNING: $message${NC}"
    echo -n "Are you sure you want to continue? (y/N): "
    read confirm
    confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
    [ "$confirm" == "y" ]
}

show_header() {
    local title=$1
    echo -e "${BLUE}==============================${NC}"
    echo -e "${GREEN} $title${NC}"
    echo -e "${BLUE}==============================${NC}"
}

show_footer() {
    echo -e "${BLUE}==============================${NC}"
    read -p "Press Enter to return to the main menu..."
}

# Main menu function
main_menu() {
    while true; do
        clear
        show_header "Docker Management Menu"

        option=$(echo -e "Start Docker Compose\nStop Docker Compose\nView all Docker containers\nRemove individual Docker container\nRemove all Docker containers\nRestart Docker\nRemove Docker entirely\nRemove PostgreSQL\nReinstall Docker\nReinstall PostgreSQL\nRemove all and reinstall\nSpin up a new PostgreSQL database\nExit" | fzf \
            --height=100% \
            --layout=reverse \
            --border \
            --prompt="Select an option > " \
            --header="Docker Management Options" \
            --color="header:blue" \
            --preview 'echo "Selected: {}"' \
            --preview-window=up:1)

        case "$option" in
            "Start Docker Compose") start_docker_compose ;;
            "Stop Docker Compose") stop_docker_compose ;;
            "View all Docker containers") view_containers ;;
            "Remove individual Docker container") remove_individual_container ;;
            "Remove all Docker containers") remove_all_containers ;;
            "Restart Docker") restart_docker ;;
            "Remove Docker entirely") remove_docker ;;
            "Remove PostgreSQL") remove_postgresql ;;
            "Reinstall Docker") reinstall_docker ;;
            "Reinstall PostgreSQL") reinstall_postgresql ;;
            "Remove all and reinstall") remove_all_and_reinstall ;;
            "Spin up a new PostgreSQL database") spin_up_postgresql ;;
            "Exit") exit 0 ;;
        esac
    done
}

# Container operations
view_containers() {
    show_header "Current Docker Containers"
    docker ps -a
    show_footer
}

remove_individual_container() {
    show_header "Remove Individual Docker Container"
    container_id=$(docker ps -a --format "{{.ID}}: {{.Names}}" | fzf --header "Select a container to remove")
    
    if [ -n "$container_id" ]; then
        container_id=$(echo "$container_id" | cut -d':' -f1)
        if confirm_action "This will remove container $container_id!"; then
            docker rm -f "$container_id" && echo -e "${GREEN}Container $container_id removed.${NC}" || echo -e "${RED}Failed to remove container $container_id.${NC}"
        else
            echo -e "${YELLOW}Operation cancelled.${NC}"
        fi
    else
        echo -e "${YELLOW}No container selected.${NC}"
    fi
    show_footer
}

remove_all_containers() {
    show_header "Removing All Docker Containers"
    if confirm_action "This will stop and remove ALL Docker containers!"; then
        docker stop $(docker ps -aq) 2>/dev/null
        docker rm $(docker ps -aq) 2>/dev/null
        echo -e "${GREEN}All Docker containers removed.${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
    show_footer
}

# Docker operations
restart_docker() {
    show_header "Restarting Docker"
    sudo systemctl restart docker
    echo -e "${GREEN}Docker restarted.${NC}"
    show_footer
}

remove_docker() {
    show_header "Removing Docker"
    if confirm_action "This will remove Docker and all its data permanently!"; then
        sudo apt-get purge -y docker-ce docker-ce-cli containerd.io
        sudo rm -rf /var/lib/docker
        echo -e "${GREEN}Docker removed.${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
    show_footer
}

reinstall_docker() {
    show_header "Reinstalling Docker"
    if confirm_action "This will reinstall Docker. Continue?"; then
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
        echo -e "${GREEN}Docker reinstalled.${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
    show_footer
}

# PostgreSQL operations
remove_postgresql() {
    show_header "Removing PostgreSQL"
    if confirm_action "This will remove PostgreSQL and all its data permanently!"; then
        sudo apt-get purge -y postgresql postgresql-contrib
        sudo rm -rf /var/lib/postgresql
        echo -e "${GREEN}PostgreSQL removed.${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
    show_footer
}

reinstall_postgresql() {
    show_header "Reinstalling PostgreSQL"
    if confirm_action "This will reinstall PostgreSQL. Continue?"; then
        sudo apt-get update
        sudo apt-get install -y postgresql postgresql-contrib
        echo -e "${GREEN}PostgreSQL reinstalled.${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
    show_footer
}

# Docker Compose operations
start_docker_compose() {
    show_header "Starting Docker Compose"
    compose_file=$(find . -name "docker-compose.yml" | fzf --header "Select docker-compose.yml file")
    
    if [ -z "$compose_file" ]; then
        compose_file="./docker-compose.yml"
    fi

    if [ -f "$compose_file" ]; then
        echo -e "${YELLOW}Starting services defined in $compose_file${NC}"
        docker-compose -f "$compose_file" up -d && echo -e "${GREEN}Docker Compose services started successfully${NC}" || echo -e "${RED}Failed to start Docker Compose services${NC}"
    else
        echo -e "${RED}No docker-compose.yml file found${NC}"
    fi
    show_footer
}

stop_docker_compose() {
    show_header "Stopping Docker Compose"
    compose_file=$(find . -name "docker-compose.yml" | fzf --header "Select docker-compose.yml file")
    
    if [ -z "$compose_file" ]; then
        compose_file="./docker-compose.yml"
    fi

    if [ -f "$compose_file" ]; then
        echo -e "${YELLOW}Stopping services defined in $compose_file${NC}"
        docker-compose -f "$compose_file" down && echo -e "${GREEN}Docker Compose services stopped successfully${NC}" || echo -e "${RED}Failed to stop Docker Compose services${NC}"
    else
        echo -e "${RED}No docker-compose.yml file found${NC}"
    fi
    show_footer
}

# Database setup
spin_up_postgresql() {
    show_header "Spinning Up a New PostgreSQL Database"
    
    compose_path=$(find . -name "*.yml" | fzf --header "Select your docker-compose.yml file (default: ./docker-compose.yml)")
    compose_path=${compose_path:-"./docker-compose.yml"}

    if [ -f "$compose_path" ]; then
        cp "$compose_path" "${compose_path%.yml}_backup.yml"
        echo -e "${YELLOW}Backup created: ${compose_path%.yml}_backup.yml${NC}"
        echo "${compose_path%.yml}_backup.yml" >> .gitignore
    fi

    if confirm_action "Do you want to set custom credentials for PostgreSQL?"; then
        read -p "Enter PostgreSQL username (default: POSTGRES): " pg_user
        read -p "Enter PostgreSQL password (default: POSTGRES): " pg_password
        read -p "Enter PostgreSQL database name (default: APP): " pg_db
        
        pg_user=${pg_user:-POSTGRES}
        pg_password=${pg_password:-POSTGRES}
        pg_db=${pg_db:-APP}
    else
        pg_user="username"
        pg_password="password"
        pg_db="database"
    fi

    # Create docker-compose.yml
    cat <<EOF >"$compose_path"
version: "3.8"
services:
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: $pg_user
      POSTGRES_PASSWORD: $pg_password
      POSTGRES_DB: $pg_db
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF

    if [ -f "${compose_path%.yml}_backup.yml" ]; then
        echo -e "${BLUE}Changes made:${NC}"
        diff "${compose_path%.yml}_backup.yml" "$compose_path"
    fi

    docker-compose -f "$compose_path" up -d

    DATABASE_URL="postgres://$pg_user:$pg_password@localhost:5432/$pg_db"
    echo "$DATABASE_URL" | xclip -selection clipboard

    echo -e "${GREEN}Database created and URL copied to clipboard:${NC}"
    echo -e "${CYAN}$DATABASE_URL${NC}"
    show_footer
}

# System operations
remove_all_and_reinstall() {
    show_header "Removing All Docker Resources and Reinstalling"
    if confirm_action "This will remove ALL Docker resources, PostgreSQL, and reinstall everything!"; then
        remove_all_containers
        remove_docker
        remove_postgresql
        reinstall_docker
        reinstall_postgresql
        echo -e "${GREEN}All resources removed and reinstalled.${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
    show_footer
}

# Initialize
alias db=main_menu