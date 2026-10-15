#!/bin/bash
# Dotfiles bootstrap script

set -e

DOTFILES_DIR="$HOME/Developer/Personal/dotfiles"
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

echo "✅ Dotfiles installed. Source ~/.zshrc or restart terminal."
