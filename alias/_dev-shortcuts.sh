alias p='pnpm'
alias python='python3'
alias py='python3'

alias dev='pnpm run dev'
alias build='pnpm run build'

alias rmall='rm -rf node_modules && rm -rf package-lock.json && rm -rf pnpm-lock.yaml && rm -rf .next'

alias rebuild='rmall && p && p install && p run build'

alias restart='rmall && p && p install && p run dev'
