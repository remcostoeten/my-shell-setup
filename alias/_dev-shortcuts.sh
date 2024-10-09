alias p='pnpm'
alias py='python3'

alias run='pnpm run'
alias dev='pnpm run dev'
alias build='pnpm run build'
alias start='pnpm run start'

alias rmall='rm -rf node_modules && rm -rf package-lock.json && rm -rf pnpm-lock.yaml'

alias rebuild='rmall && p && p install && p run build'
alias restart='rmall && p && p install && p run dev'
