#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Function to display the main menu with improved layout
main_menu() {
  while true; do
    clear
    echo -e "${BLUE}==============================${NC}"
    echo -e "${GREEN} Docker Management Menu${NC}"
    echo -e "${BLUE}==============================${NC}"

    # Use fzf with adjusted height and layout
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

# Function to view all Docker containers
view_containers() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Current Docker Containers${NC}"
  echo -e "${BLUE}==============================${NC}"
  docker ps -a
  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# Function to remove an individual Docker container
remove_individual_container() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Remove Individual Docker Container${NC}"
  echo -e "${BLUE}==============================${NC}"

  # List all containers and allow selection with fzf
  container_id=$(docker ps -a --format "{{.ID}}: {{.Names}}" | fzf --header "Select a container to remove")

  # Check if a container was selected
  if [ -n "$container_id" ]; then
    # Extract the container ID from the selection
    container_id=$(echo "$container_id" | cut -d':' -f1)
    docker rm -f "$container_id" && echo -e "${GREEN}Container $container_id removed.${NC}" || echo -e "${RED}Failed to remove container $container_id.${NC}"
  else
    echo -e "${YELLOW}No container selected.${NC}"
  fi

  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# Function to remove all Docker containers
remove_all_containers() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Removing All Docker Containers${NC}"
  echo -e "${BLUE}==============================${NC}"
  docker stop $(docker ps -aq) 2>/dev/null
  docker rm $(docker ps -aq) 2>/dev/null
  echo -e "${GREEN}All Docker containers removed.${NC}"
  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# Function to restart Docker
restart_docker() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Restarting Docker${NC}"
  echo -e "${BLUE}==============================${NC}"
  sudo systemctl restart docker
  echo -e "${GREEN}Docker restarted.${NC}"
  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# Function to remove Docker entirely
remove_docker() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Removing Docker${NC}"
  echo -e "${BLUE}==============================${NC}"
  sudo apt-get purge -y docker-ce docker-ce-cli containerd.io
  sudo rm -rf /var/lib/docker
  echo -e "${GREEN}Docker removed.${NC}"
  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# Function to remove PostgreSQL
remove_postgresql() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Removing PostgreSQL${NC}"
  echo -e "${BLUE}==============================${NC}"
  sudo apt-get purge -y postgresql postgresql-contrib
  sudo rm -rf /var/lib/postgresql
  echo -e "${GREEN}PostgreSQL removed.${NC}"
  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# Function to reinstall Docker
reinstall_docker() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Reinstalling Docker${NC}"
  echo -e "${BLUE}==============================${NC}"
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  echo -e "${GREEN}Docker reinstalled.${NC}"
  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# Function to reinstall PostgreSQL
reinstall_postgresql() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Reinstalling PostgreSQL${NC}"
  echo -e "${BLUE}==============================${NC}"
  sudo apt-get update
  sudo apt-get install -y postgresql postgresql-contrib
  echo -e "${GREEN}PostgreSQL reinstalled.${NC}"
  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# Function to remove all and reinstall
remove_all_and_reinstall() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Removing All Docker Resources and Reinstalling${NC}"
  echo -e "${BLUE}==============================${NC}"
  remove_all_containers
  remove_docker
  remove_postgresql
  reinstall_docker
  reinstall_postgresql
  echo -e "${GREEN}All resources removed and reinstalled.${NC}"
  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# Function to spin up a new PostgreSQL database
spin_up_postgresql() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Spinning Up a New PostgreSQL Database${NC}"
  echo -e "${BLUE}==============================${NC}"

  # Use fzf to fuzzy find the docker-compose.yml file
  compose_path=$(find . -name "*.yml" | fzf --header "Select your docker-compose.yml file (default: ./docker-compose.yml)")

  # If no file is selected, use the default path
  if [ -z "$compose_path" ]; then
    compose_path="./docker-compose.yml"
  fi

  # Backup the existing docker-compose.yml if it exists
  if [ -f "$compose_path" ]; then
    cp "$compose_path" "${compose_path%.yml}_backup.yml"
    echo -e "${YELLOW}Backup of existing docker-compose.yml created: ${compose_path%.yml}_backup.yml${NC}"
    echo "${compose_path%.yml}_backup.yml" >>.gitignore
  fi

  # Prompt for custom credentials
  read -p "Do you want to set custom credentials for PostgreSQL? (Y/N): " custom_creds
  custom_creds=${custom_creds^^} # Convert to uppercase

  if [[ "$custom_creds" == "Y" ]]; then
    read -p "Enter PostgreSQL username (default: POSTGRES): " pg_user
    pg_user=${pg_user:-POSTGRES} # Default to 'POSTGRES' if empty
    read -p "Enter PostgreSQL password (default: POSTGRES): " pg_password
    pg_password=${pg_password:-POSTGRES} # Default to 'POSTGRES' if empty
    read -p "Enter PostgreSQL database name (default: APP): " pg_db
    pg_db=${pg_db:-APP} # Default to 'APP' if empty
  else
    pg_user="username"
    pg_password="password"
    pg_db="database"
  fi

  # Create the Docker Compose file
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

  # Show the difference if the file was overwritten
  if [ -f "${compose_path%.yml}_backup.yml" ]; then
    echo -e "${BLUE}Differences between the old and new docker-compose.yml:${NC}"
    diff "${compose_path%.yml}_backup.yml" "$compose_path"
  fi

  # Warning about the obsolete version attribute
  echo -e "${RED}WARNING: The attribute 'version' is obsolete and will be ignored. Please remove it to avoid potential confusion.${NC}"

  # Start the PostgreSQL service
  docker-compose -f "$compose_path" up -d

  # Copy DATABASE_URL to clipboard
  DATABASE_URL="postgres://$pg_user:$pg_password@localhost:5432/$pg_db"
  echo "$DATABASE_URL" | xclip -selection clipboard

  echo -e "${GREEN}PostgreSQL database created and DATABASE_URL copied to clipboard.${NC}"
  echo -e "${YELLOW}Update your docker-compose.yml with the following DATABASE_URL:${NC}"
  echo -e "${GREEN}$DATABASE_URL${NC}"
  echo -e "${YELLOW}Make sure to change the credentials in your docker-compose.yml if script failed to automatically update it.Also don't forget the .env file.${NC}"
  echo -e "${BLUE}==============================${NC}"
  read -p "Press Enter to return to the main menu..."
}

# New function to start Docker Compose
start_docker_compose() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Starting Docker Compose${NC}"
  echo -e "${BLUE}==============================${NC}"

  # Find docker-compose files
  compose_file=$(find . -name "docker-compose.yml" | fzf --header "Select docker-compose.yml file")

  if [ -z "$compose_file" ]; then
    compose_file="./docker-compose.yml"
  fi

  if [ -f "$compose_file" ]; then
    echo -e "${YELLOW}Starting services defined in $compose_file${NC}"
    docker-compose -f "$compose_file" up -d

    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker Compose services started successfully${NC}"
    else
      echo -e "${RED}Failed to start Docker Compose services${NC}"
    fi
  else
    echo -e "${RED}No docker-compose.yml file found${NC}"
  fi

  read -p "Press Enter to return to the main menu..."
}

# New function to stop Docker Compose
stop_docker_compose() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN} Stopping Docker Compose${NC}"
  echo -e "${BLUE}==============================${NC}"

  # Find docker-compose files
  compose_file=$(find . -name "docker-compose.yml" | fzf --header "Select docker-compose.yml file")

  if [ -z "$compose_file" ]; then
    compose_file="./docker-compose.yml"
  fi

  if [ -f "$compose_file" ]; then
    echo -e "${YELLOW}Stopping services defined in $compose_file${NC}"
    docker-compose -f "$compose_file" down

    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Docker Compose services stopped successfully${NC}"
    else
      echo -e "${RED}Failed to stop Docker Compose services${NC}"
    fi
  else
    echo -e "${RED}No docker-compose.yml file found${NC}"
  fi

  read -p "Press Enter to return to the main menu..."
}

# Start the script
alias db=main_menu
