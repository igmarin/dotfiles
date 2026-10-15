# Source modular configuration files
for file in ~/.zsh/*.zsh; do
  [ -r "$file" ] && source "$file"
done

# Bun completions
[ -s "/Users/igmarin/.bun/_bun" ] && source "/Users/igmarin/.bun/_bun"

# Version managers
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
