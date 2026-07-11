# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

- **ghostty** -- terminal config (Tokyo Night, JetBrains Mono, split panes)
- **git** -- global git config (interactive setup) and ignore patterns
- **tmux** -- tmux config (Catppuccin Mocha via TPM, all default keybindings)
- **pi** -- [Pi coding agent](https://pi.dev) settings (model, provider, skills)
- **codex** -- global Codex agent instructions

## Install

```bash
git clone https://github.com/owainlewis/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
./install.sh
```

Install only the Codex instructions with `./install.sh --only codex`.

The install script will:

1. Install Homebrew (if missing)
2. Install GNU Stow and tmux
3. Install JetBrains Mono font (skips gracefully if already present)
4. Install [TPM](https://github.com/tmux-plugins/tpm) (tmux plugin manager)
5. Symlink configs via Stow, including `~/.pi/` and `~/.codex/`
6. **Interactive Git setup** — prompts for your name, email, and preferred editor (only on first run)

After install, open tmux and press `prefix + I` (Ctrl-b then Shift-i) to fetch tmux plugins.

## Structure

Most top-level directories map to `~/.config/`. Pi targets `~/.pi/`; Codex targets `~/.codex/`.
