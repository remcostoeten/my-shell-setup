#!/bin/bash

# Default values
DEFAULT_DB_NAME="postgres"
DEFAULT_DB_USER="postgres"
DEFAULT_DB_PASSWORD="postgres"
DEFAULT_PORT="5432"
DEFAULT_CONTAINER_NAME="postgres_db"

# Prompt for configuration with default values
echo -n "Enter database name (default: $DEFAULT_DB_NAME): "
read DB_NAME
DB_NAME=${DB_NAME:-$DEFAULT_DB_NAME}

echo -n "Enter database user (default: $DEFAULT_DB_USER): "
read DB_USER
DB_USER=${DB_USER:-$DEFAULT_DB_USER}

echo -n "Enter database password (default: $DEFAULT_DB_PASSWORD): "
read DB_PASSWORD
DB_PASSWORD=${DB_PASSWORD:-$DEFAULT_DB_PASSWORD}

echo -n "Enter port (default: $DEFAULT_PORT): "
read DB_PORT
DB_PORT=${DB_PORT:-$DEFAULT_PORT}

echo -n "Enter container name (default: $DEFAULT_CONTAINER_NAME): "
read CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-$DEFAULT_CONTAINER_NAME}

# Create and run the container
DOCKER_CMD="docker run -d \
  --name $CONTAINER_NAME \
  -e POSTGRES_USER=$DB_USER \
  -e POSTGRES_PASSWORD=$DB_PASSWORD \
  -e POSTGRES_DB=$DB_NAME \
  -p $DB_PORT:5432 \
  postgres"

echo "Running the following command to create the PostgreSQL container:"
echo "$DOCKER_CMD"

# Execute the command
eval "$DOCKER_CMD"

# Check if the container was created successfully
if [ $? -eq 0 ]; then
    echo "Container $CONTAINER_NAME created successfully!"
    echo "Connection details:"
    echo "  Host: localhost"
    echo "  Port: $DB_PORT"
    echo "  Database: $DB_NAME"
    echo "  User: $DB_USER"
    echo "  Password: $DB_PASSWORD"
    
    # Copy command to clipboard if xclip is available
    if command -v xclip > /dev/null; then
        echo "$DOCKER_CMD" | xclip -selection clipboard
        echo "Docker command has been copied to your clipboard."
    elif command -v pbcopy > /dev/null; then
        echo "$DOCKER_CMD" | pbcopy
        echo "Docker command has been copied to your clipboard."
    fi
else
    echo "Failed to create container. Please check the error message above."
fi