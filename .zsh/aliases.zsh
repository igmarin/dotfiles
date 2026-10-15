# System management
alias systemup="brew update && brew upgrade && brew autoremove && brew cleanup && brew doctor && mise upgrade && uv tool upgrade --all"

# macOS caffeine
alias wakeup="caffeinate -u -t 5"

# Computer SSH aliases
alias cerebro="ssh igmarin@cerebro.local"
alias bravo="ssh ismaelguillermomarincabrera@bravo.local"

# Podman alias
alias docker=podman
