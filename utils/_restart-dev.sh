# Development reset function
restart_dev() {
    print -P "%F{yellow}🚀 Starting development environment reset...%f"
    
    if [[ ! -f "package.json" ]]; then
        print -P "%F{red}❌ Error: No package.json found. Are you in the right directory?%f"
        return 1
    fi
    
    print -P "%F{blue}🧹 Cleaning project directories...%f"
    
    if [[ -d "node_modules" ]]; then
        print -P "%F{cyan}  📦 Removing node_modules...%f"
        rm -rf node_modules
        print -P "%F{green}  ✅ node_modules removed%f"
    fi
    
    if [[ -d ".next" ]]; then
        print -P "%F{cyan}  🗑️  Removing .next build directory...%f"
        rm -rf .next
        print -P "%F{green}  ✅ .next removed%f"
    fi
    
    print -P "%F{yellow}📥 Installing dependencies with pnpm...%f"
    if pnpm install; then
        print -P "%F{green}✅ Dependencies installed successfully%f"
    else
        print -P "%F{red}❌ Failed to install dependencies%f"
        return 1
    fi
    
    print -P "%F{magenta}🚀 Starting Next.js development server with Turbo...%f"
    print -P "%F{blue}⌛ Please wait...%f"
    pnpm next dev --turbo
}

# Add these to your .zshrc:
autoload -U colors && colors
precmd() { print_current_path }
alias pid='restart_dev'