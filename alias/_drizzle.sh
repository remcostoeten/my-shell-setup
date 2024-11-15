#!/bin/bash

# Base commands
DRIZZLE_CMD="pnpm drizzle-kit"
SCRIPTS_PATH="./scripts"

# Core Drizzle aliases
alias d="${DRIZZLE_CMD}"
alias migrate="${DRIZZLE_CMD} migrate"
alias gen="${DRIZZLE_CMD} generate"
alias studio="${DRIZZLE_CMD} studio"
alias pushdb="${DRIZZLE_CMD} push"

# PostgreSQL specific aliases
alias genpg="${DRIZZLE_CMD} generate:pg"
alias pushpg="${DRIZZLE_CMD} push:pg"

# Database management
alias dropalltables="${DRIZZLE_CMD} exec -f ${SCRIPTS_PATH}/drop_all_tables.sql"