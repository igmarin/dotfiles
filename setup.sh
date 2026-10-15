#!/bin/bash
# Dotfiles bootstrap script

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSH_DIR="$HOME/.zsh"

echo "Setting up dotfiles..."

# Create .zsh directory if it doesn't exist
mkdir -p "$ZSH_DIR"

# Copy files from repo
cp -r "$DOTFILES_DIR/.zsh"/* "$ZSH_DIR/"

# Copy main .zshrc
cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Check if keys.zsh exists, if not copy template
if [ ! -f "$ZSH_DIR/keys.zsh" ]; then
  cp "$ZSH_DIR/keys.zsh.template" "$ZSH_DIR/keys.zsh"
  echo "⚠️  Keys template copied. Edit $ZSH_DIR/keys.zsh with your actual API keys."
fi

# Same for machine-specific config (SSH aliases, etc.)
if [ ! -f "$ZSH_DIR/local.zsh" ]; then
  cp "$ZSH_DIR/local.zsh.template" "$ZSH_DIR/local.zsh"
  echo "ℹ️  Edit $ZSH_DIR/local.zsh for machine-specific aliases."
fi

# Symlink agent configs (backs up any existing real file to *.bak)
link() {
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.bak"; fi
  ln -sfn "$1" "$2"
}
link "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES_DIR/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"

echo "✅ Dotfiles installed. Source ~/.zshrc or restart terminal."
