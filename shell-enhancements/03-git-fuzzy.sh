# Git Fuzzy Functions Configuration
# FZF-enhanced git commands
# Created: $(date '+%Y-%m-%d')

# Fuzzy git checkout branch
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Fuzzy git add
fga() {
  local files
  files=$(git status -s | awk '{print $2}' | fzf -m --preview 'git diff --color=always {}')
  if [ -n "$files" ]; then
    git add $files
  fi
}

# Usage examples (as comments for reference):
# fbr       - Fuzzy search and checkout git branches
# fga       - Fuzzy search and stage git files 