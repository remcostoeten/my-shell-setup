#!/bin/bash

# Configuration variables (can be overridden in .dev-config if it exists)
PACKAGE_MANAGER="pnpm"
DEFAULT_CACHE_DIRS=".cache .turbo"
DEFAULT_BUILD_DIRS=".next build dist"
DEFAULT_MODULES_DIR="node_modules"
USE_TURBO=true
PORT=3000
CLEAN_ON_START=true

# Detected project type (will be set automatically)
PROJECT_TYPE=""
BUILD_DIR=""
DEV_COMMAND=""
START_COMMAND=""
BUILD_COMMAND=""

# Load custom configuration if available
if [ -f ".dev-config" ]; then
    echo "🔧 Loading custom configuration from .dev-config"
    source .dev-config
fi

# Function to detect project type
detect_project_type() {
    echo "🔍 Detecting project type..."
    
    if [ -f "package.json" ]; then
        if grep -q "\"next\"" package.json; then
            PROJECT_TYPE="next"
            BUILD_DIR=".next"
            DEV_COMMAND="next dev"
            START_COMMAND="next start"
            BUILD_COMMAND="next build"
            echo "✅ Detected Next.js project"
            
            # Check for Turbo support
            if [ "$USE_TURBO" = true ] && grep -q "\"next\":" package.json; then
                next_version=$(grep -o '"next": "[^"]*' package.json | cut -d'"' -f4)
                if [[ $(echo "$next_version" | cut -d'.' -f1) -ge 13 ]]; then
                    DEV_COMMAND="next dev --turbo"
                    echo "ℹ️  Turbo mode available for Next.js"
                else
                    echo "ℹ️  Turbo mode not available for Next.js < 13.0.0"
                    USE_TURBO=false
                fi
            fi
            
        elif grep -q "\"react-scripts\"" package.json; then
            PROJECT_TYPE="cra"
            BUILD_DIR="build"
            DEV_COMMAND="react-scripts start"
            START_COMMAND="serve -s build"
            BUILD_COMMAND="react-scripts build"
            echo "✅ Detected Create React App project"
            
        elif grep -q "\"vite\"" package.json; then
            PROJECT_TYPE="vite"
            BUILD_DIR="dist"
            DEV_COMMAND="vite"
            START_COMMAND="vite preview"
            BUILD_COMMAND="vite build"
            echo "✅ Detected Vite project"
            
        else
            echo "⚠️  Unknown React project type, checking for common build scripts..."
            # Try to detect based on scripts
            if grep -q "\"scripts\":" package.json; then
                if grep -q "\"build\":" package.json; then
                    BUILD_COMMAND="run build"
                    
                    # Look for likely build directory
                    if [ -d "dist" ]; then
                        BUILD_DIR="dist"
                    elif [ -d "build" ]; then
                        BUILD_DIR="build"
                    else
                        BUILD_DIR="dist"  # Default guess
                    fi
                    
                    if grep -q "\"start\":" package.json; then
                        START_COMMAND="run start"
                    elif grep -q "\"serve\":" package.json; then
                        START_COMMAND="run serve"
                    elif grep -q "\"preview\":" package.json; then
                        START_COMMAND="run preview"
                    else
                        START_COMMAND="run start"  # Default guess
                    fi
                    
                    if grep -q "\"dev\":" package.json; then
                        DEV_COMMAND="run dev"
                    elif grep -q "\"serve\":" package.json; then
                        DEV_COMMAND="run serve"
                    elif grep -q "\"start\":" package.json; then
                        DEV_COMMAND="run start"
                    else
                        DEV_COMMAND="run dev"  # Default guess
                    fi
                    
                    PROJECT_TYPE="generic"
                    echo "✅ Configured for generic project using package.json scripts"
                else
                    echo "⚠️  Could not detect build command in package.json"
                    PROJECT_TYPE="unknown"
                fi
            else
                echo "⚠️  Could not detect project type"
                PROJECT_TYPE="unknown"
            fi
        fi
    else
        echo "❌ No package.json found"
        PROJECT_TYPE="unknown"
        return 1
    fi
    
    return 0
}

# Function to show help
show_help() {
    echo "React Development Helper Functions"
    echo ""
    echo "Commands:"
    echo "  rmall            - Remove node_modules, build directories, and caches"
    echo "  pi               - Clean, install dependencies and start dev server"
    echo "  pb               - Clean, install dependencies and build for production"
    echo "  re               - Clean, install dependencies, and run dev (fallback to start)"
    echo "  clearports       - Kill any processes running on common dev ports"
    echo "  lint             - Run linting tools with automatic fixing"
    echo "  create-config    - Create a template .dev-config file"
    echo "  detect           - Detect the project type"
    echo ""
}

# Function to create a config template
create_config() {
    if [ -f ".dev-config" ]; then
        echo "⚠️  .dev-config already exists. Overwrite? (y/n)"
        read confirm
        if [ "$confirm" != "y" ]; then
            echo "❌ Operation cancelled"
            return 1
        fi
    fi

    cat > .dev-config << EOF
# Development Environment Configuration

# Package manager (npm, yarn, pnpm)
PACKAGE_MANAGER="pnpm"

# Directories to clean
DEFAULT_CACHE_DIRS=".cache .turbo"
DEFAULT_BUILD_DIRS=".next build dist"
DEFAULT_MODULES_DIR="node_modules"

# Development server settings
USE_TURBO=true
PORT=3000

# Clean before starting dev server
CLEAN_ON_START=true
EOF
    echo "✅ Created .dev-config template"
}

# Function to check if package manager is installed
check_pm() {
    if ! command -v $PACKAGE_MANAGER &> /dev/null; then
        echo "❌ $PACKAGE_MANAGER is not installed"
        
        # Offer to install pnpm if it's the chosen package manager but not available
        if [ "$PACKAGE_MANAGER" = "pnpm" ]; then
            echo "💡 Would you like to install pnpm using npm? (y/n)"
            read confirm
            if [ "$confirm" = "y" ]; then
                echo "📥 Installing pnpm..."
                npm install -g pnpm
                if [ $? -ne 0 ]; then
                    echo "❌ Failed to install pnpm"
                    return 1
                fi
            else
                return 1
            fi
        else
            return 1
        fi
    fi
    return 0
}

# Function to check for serve package
check_serve() {
    if [ "$PROJECT_TYPE" = "cra" ] && ! command -v serve &> /dev/null; then
        echo "⚠️  'serve' package needed for serving CRA production builds"
        echo "💡 Would you like to install 'serve' globally? (y/n)"
        read confirm
        if [ "$confirm" = "y" ]; then
            echo "📥 Installing serve..."
            $PACKAGE_MANAGER add -g serve
            if [ $? -ne 0 ]; then
                echo "❌ Failed to install serve"
                return 1
            fi
        fi
    fi
    return 0
}

# Function to clean directories
rmall() {
    echo "🧹 Starting cleanup..."
    
    # Make sure we have detected the project type
    if [ -z "$PROJECT_TYPE" ]; then
        detect_project_type
    fi
    
    # Remove node_modules with feedback
    if [ -d "$DEFAULT_MODULES_DIR" ]; then
        echo "📦 Removing $DEFAULT_MODULES_DIR..."
        rm -rf $DEFAULT_MODULES_DIR
        echo "✅ $DEFAULT_MODULES_DIR removed"
    else
        echo "ℹ️  No $DEFAULT_MODULES_DIR found"
    fi
    
    # Remove all possible build directories
    for dir in $DEFAULT_BUILD_DIRS; do
        if [ -d "$dir" ]; then
            echo "🗑️  Removing $dir build directory..."
            rm -rf $dir
            echo "✅ $dir removed"
        fi
    done
    
    # Remove cache directories
    echo "🧼 Cleaning cache..."
    for dir in $DEFAULT_CACHE_DIRS; do
        if [ -d "$dir" ]; then
            rm -rf $dir
            echo "✅ $dir removed"
        fi
    done
    
    # For Vite projects, also clean node_modules/.vite
    if [ "$PROJECT_TYPE" = "vite" ] && [ -d "node_modules/.vite" ]; then
        rm -rf node_modules/.vite
        echo "✅ node_modules/.vite cache removed"
    fi
    
    echo "✅ Cleanup complete"
}

# Function to check for package updates
check_updates() {
    echo "🔍 Checking for package updates..."
    if [ "$PACKAGE_MANAGER" = "npm" ]; then
        npm outdated
    elif [ "$PACKAGE_MANAGER" = "yarn" ]; then
        yarn outdated
    elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
        pnpm outdated
    fi
}

# Function to kill processes on common dev ports
clearports() {
    echo "🔄 Clearing processes on common dev ports..."
    for port in 3000 3001 3002 4000 4001 5000 5173 8000 8080; do
        pid=$(lsof -ti:$port)
        if [ -n "$pid" ]; then
            echo "🛑 Killing process on port $port (PID: $pid)"
            kill -9 $pid
        fi
    done
    echo "✅ Ports cleared"
}

# Function to run linting tools
lint() {
    echo "🔍 Running linting tools..."
    
    # Make sure we have detected the project type
    if [ -z "$PROJECT_TYPE" ]; then
        detect_project_type
    fi
    
    if [ -f "package.json" ]; then
        # Check for lint script first
        if grep -q "\"lint\":" package.json; then
            echo "🧹 Running lint script..."
            $PACKAGE_MANAGER lint
            
        # Otherwise try individual tools
        else
            if grep -q "\"eslint\"" package.json; then
                echo "🧹 Running ESLint..."
                $PACKAGE_MANAGER eslint --fix .
            fi
            
            if grep -q "\"prettier\"" package.json; then
                echo "✨ Running Prettier..."
                $PACKAGE_MANAGER prettier --write .
            fi
        fi
        
        echo "✅ Linting complete"
    else
        echo "❌ No package.json found"
        return 1
    fi
}

# Enhanced installation and dev command
pi() {
    # Check package manager first
    check_pm || return 1
    
    # Detect project type if not already detected
    if [ -z "$PROJECT_TYPE" ]; then
        detect_project_type || return 1
    fi
    
    # First run cleanup if enabled
    if [ "$CLEAN_ON_START" = true ]; then
        rmall
    fi
    
    # Install dependencies
    echo "📥 Installing dependencies with $PACKAGE_MANAGER..."
    if $PACKAGE_MANAGER install; then
        echo "✅ Dependencies installed successfully"
        
        # Start development server
        echo "🚀 Starting development server..."
        if [ -n "$DEV_COMMAND" ]; then
            # Handle port for different project types
            if [[ "$DEV_COMMAND" == *"next"* ]]; then
                $PACKAGE_MANAGER exec $DEV_COMMAND --port $PORT
            elif [ "$PROJECT_TYPE" = "vite" ]; then
                $PACKAGE_MANAGER exec $DEV_COMMAND --port $PORT
            elif [ "$PROJECT_TYPE" = "cra" ]; then
                PORT=$PORT $PACKAGE_MANAGER exec $DEV_COMMAND
            else
                $PACKAGE_MANAGER $DEV_COMMAND
            fi
        else
            echo "❌ No development command detected for this project type"
            return 1
        fi
    else
        echo "❌ Failed to install dependencies"
        return 1
    fi
}

# Production build command
pb() {
    # Check package manager first
    check_pm || return 1
    
    # Detect project type if not already detected
    if [ -z "$PROJECT_TYPE" ]; then
        detect_project_type || return 1
    fi
    
    # First run cleanup
    rmall
    
    # Install dependencies
    echo "📥 Installing dependencies with $PACKAGE_MANAGER..."
    if $PACKAGE_MANAGER install; then
        echo "✅ Dependencies installed successfully"
        
        # Build for production
        echo "🏗️  Building for production..."
        if [ -n "$BUILD_COMMAND" ]; then
            if $PACKAGE_MANAGER $BUILD_COMMAND; then
                echo "✅ Build completed successfully"
                
                # Check for serve package if needed
                check_serve
                
                echo "Would you like to start the production server? (y/n)"
                read confirm
                if [ "$confirm" = "y" ]; then
                    echo "🚀 Starting production server..."
                    if [ -n "$START_COMMAND" ]; then
                        $PACKAGE_MANAGER $START_COMMAND
                    else
                        echo "❌ No start command detected for this project type"
                        return 1
                    fi
                fi
            else
                echo "❌ Build failed"
                return 1
            fi
        else
            echo "❌ No build command detected for this project type"
            return 1
        fi
    else
        echo "❌ Failed to install dependencies"
        return 1
    fi
}

# Clean, install, and run dev with fallback to start
re() {
    # Clear ports first to avoid conflicts
    clearports
    
    # Check package manager
    check_pm || return 1
    
    # Detect project type if not already detected
    if [ -z "$PROJECT_TYPE" ]; then
        detect_project_type || return 1
    fi
    
    # Run cleanup
    echo "🔄 Refreshing project environment..."
    rmall
    
    # Install dependencies
    echo "📥 Installing dependencies with $PACKAGE_MANAGER..."
    if $PACKAGE_MANAGER install; then
        echo "✅ Dependencies installed successfully"
        
        # Try to run dev command
        if [ -n "$DEV_COMMAND" ]; then
            echo "🚀 Attempting to start development server..."
            
            # Handle port for different project types
            if [[ "$DEV_COMMAND" == *"next"* ]]; then
                if $PACKAGE_MANAGER exec $DEV_COMMAND --port $PORT; then
                    echo "✅ Development server started successfully"
                    return 0
                else
                    echo "⚠️ Development server failed to start"
                fi
            elif [ "$PROJECT_TYPE" = "vite" ]; then
                if $PACKAGE_MANAGER exec $DEV_COMMAND --port $PORT; then
                    echo "✅ Development server started successfully"
                    return 0
                else
                    echo "⚠️ Development server failed to start"
                fi
            elif [ "$PROJECT_TYPE" = "cra" ]; then
                if PORT=$PORT $PACKAGE_MANAGER exec $DEV_COMMAND; then
                    echo "✅ Development server started successfully"
                    return 0
                else
                    echo "⚠️ Development server failed to start"
                fi
            else
                if $PACKAGE_MANAGER $DEV_COMMAND; then
                    echo "✅ Development server started successfully"
                    return 0
                else
                    echo "⚠️ Development server failed to start"
                fi
            fi
            
            # If dev fails, try to start production server
            echo "🔄 Attempting to start production server instead..."
            
            # Check if we need to build first
            if [ ! -d "$BUILD_DIR" ] || [ -z "$(ls -A $BUILD_DIR 2>/dev/null)" ]; then
                echo "🏗️ Build directory empty or missing, running build first..."
                if [ -n "$BUILD_COMMAND" ]; then
                    if ! $PACKAGE_MANAGER $BUILD_COMMAND; then
                        echo "❌ Build failed, cannot start server"
                        return 1
                    fi
                else
                    echo "❌ No build command detected for this project type"
                    return 1
                fi
            fi
            
            # Check for serve package if needed
            check_serve
            
            echo "🚀 Starting production server..."
            if [ -n "$START_COMMAND" ]; then
                if $PACKAGE_MANAGER $START_COMMAND; then
                    echo "✅ Production server started successfully"
                    return 0
                else
                    echo "❌ Failed to start production server"
                    return 1
                fi
            else
                echo "❌ No start command detected for this project type"
                return 1
            fi
        else
            echo "❌ No development command detected for this project type"
            return 1
        fi
    else
        echo "❌ Failed to install dependencies"
        return 1
    fi
}

# Process arguments
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
elif [ "$1" = "create-config" ]; then
    create_config
    exit 0
elif [ "$1" = "detect" ]; then
    detect_project_type
    exit 0
elif [ "$1" = "rmall" ]; then
    detect_project_type
    rmall
    exit 0
elif [ "$1" = "pi" ]; then
    pi
    exit 0
elif [ "$1" = "pb" ]; then
    pb
    exit 0
elif [ "$1" = "re" ]; then
    re
    exit 0
elif [ "$1" = "clearports" ]; then
    clearports
    exit 0
elif [ "$1" = "lint" ]; then
    lint
    exit 0
elif [ "$1" = "check-updates" ]; then
    check_updates
    exit 0
fi

# Add to your .bashrc or .zshrc:
# 
# # React development helpers
# source /path/to/this/script.sh
#
# Or add these aliases individually:
alias rmall='rmall'
alias pi='pi'
alias pb='pb'
alias re=re
alias clearports='clearports'
alias reactlint='lint'
alias detect='detect_project_type