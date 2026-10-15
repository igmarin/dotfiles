# System management
alias systemup="brew update && brew upgrade && brew autoremove && brew cleanup && brew doctor && mise upgrade && uv tool upgrade --all"

# macOS caffeine
alias wakeup="caffeinate -u -t 5"

# Podman alias
alias docker=podman

# Machine-specific aliases (SSH hosts, usernames) live in ~/.zsh/local.zsh (not in git)
