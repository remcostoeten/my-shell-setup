#!/bin/bash

# Function to clean directories
rmallnext() {
    echo "🧹 Starting cleanup..."
    
    # Remove node_modules with feedback
    if [ -d "node_modules" ]; then
        echo "📦 Removing node_modules..."
        rm -rf node_modules
        echo "✅ node_modules removed"
    else
        echo "ℹ️  No node_modules found"
    fi
    
    # Remove .next with feedback
    if [ -d ".next" ]; then
        echo "🗑️  Removing .next build directory..."
        rm -rf .next
        echo "✅ .next removed"
    else
        echo "ℹ️  No .next directory found"
    fi

    # Remove cache directories
    echo "🧼 Cleaning cache..."
    rm -rf .cache .turbo
    echo "✅ Cache cleaned"
}

# Enhanced installation and dev command
pi() {
    # First run cleanup
    rmallallnext
    
    # Install dependencies
    echo "📥 Installing dependencies with pnpm..."
    if pnpm install; then
        echo "✅ Dependencies installed successfully"
        
        # Start development server
        echo "🚀 Starting Next.js development server with Turbo..."
        pnpm next dev --turbo
    else
        echo "❌ Failed to install dependencies"
        return 1
    fi
}

# Add these to your .bashrc or .zshrc:
# alias rmall='rmall'
# alias pi='pi'
