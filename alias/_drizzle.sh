alias kit='drizzle-kit'

alias migrate='pnpm drizzle-kit migrate'
alias gen='pnpm drizzle-kit generate'
alias studio='pnpm drizzle-kit studio'
alias pushdb='pnpm drizzle-kit push'

## Old PG syntax
alias genpg='pnpm drizzle-kit generate:pg'
alias pushpg='pnpm drizzle-kit push:pg'

## Drop all PG drop_all_tables
alias dropalltables='pnpm drizzle-kit exec -f ./scripts/drop_all_tables.sql'
