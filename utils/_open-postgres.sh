#!/bin/bash

dbadmin() {
  local DB_CONTAINER_NAME="auth_system_db"
  local ADMINER_CONTAINER_NAME="adminer"
  local NETWORK_NAME="v0-auth_default"
  local ADMINER_PORT="8080"

  case "$1" in
  start)
    echo "Starting Adminer..."
    docker rm -f $ADMINER_CONTAINER_NAME 2>/dev/null
    docker run --name $ADMINER_CONTAINER_NAME \
      --network $NETWORK_NAME \
      -p $ADMINER_PORT:8080 \
      -d \
      adminer
    sleep 2
    xdg-open "http://localhost:$ADMINER_PORT" 2>/dev/null ||
      firefox "http://localhost:$ADMINER_PORT" 2>/dev/null
    ;;

  stop)
    echo "Stopping Adminer..."
    docker rm -f $ADMINER_CONTAINER_NAME
    ;;

  *)
    echo "Usage: dbadmin [start|stop]"
    echo "start - Start Adminer and open browser"
    echo "stop  - Stop Adminer"
    ;;
  esac
}
