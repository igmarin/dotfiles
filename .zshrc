# Source modular configuration files
for file in ~/.zsh/*.zsh; do
  [ -r "$file" ] && source "$file"
done

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Version managers
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
