alias p='pnpm'
alias python='python3'
alias py='python3'

alias dev='pnpm run dev'
alias build='pnpm run build'

alias i='pnpm install'

alias b='build'

alias rmall='rm -rf node_modules && rm -rf package-lock.json && rm -rf pnpm-lock.yaml && rm -rf .next'
alias rebuild='rmall && p && p install && p run build'

alias restart='rmall && p && p install && p run dev'
alias type='pnpm tsc --noEmit'
alias check='pnpm tsc --noEmit'

alias nextapp='pnpm dlx create-next-app@latest'

alias bnextapp='bunx create-next-app@latest -Y'
