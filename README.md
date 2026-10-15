# Dotfiles

Personal dotfiles shared across multiple Mac computers.

## Setup

1. Clone this repo:
   ```bash
   git clone <your-repo-url> ~/Developer/Personal/dotfiles
   ```

2. Run bootstrap:
   ```bash
   cd ~/Developer/Personal/dotfiles
   ./setup.sh
   ```

3. Configure API keys:
   - Edit `~/.zsh/keys.zsh` with your actual keys
   - Template is at `~/.zsh/keys.zsh.template`

## Structure

- `.zshrc` - Main entry point (sources all modules)
- `.zsh/` - Modular configuration:
  - `env.zsh` - Environment variables
  - `path.zsh` - PATH configuration
  - `oh-my-zsh.zsh` - Oh-my-zsh setup
  - `keys.zsh` - API keys (not in git, use template)
  - `keys.zsh.template` - Keys template (in git)
  - `aliases.zsh` - System and SSH aliases
  - `mlx.zsh` - MLX functions with auto-detection

## AI agents (Claude Code + Codex)

- `claude/CLAUDE.md`, `claude/settings.json` → symlinked to `~/.claude/` by `setup.sh`
- `codex/AGENTS.md` → symlinked to `~/.codex/`
- `AGENTS.md` (repo root) holds the rules for agents working in this repo; `CLAUDE.md` imports it
- `settings.json` denies reads of `.env*`, `~/.ssh`, `~/.aws`, `~/.zsh/keys.zsh` and force-pushes
- Machine-specific settings (hooks, statusline paths) stay out of git; put them in `~/.claude/settings.local.json`

## MLX Auto-Detection

The `graphify-mlx` function automatically selects the appropriate model based on architecture:
- Apple Silicon (arm64): Llama-3.2-3B-Instruct-4bit
- Intel (x86_64): Llama-3.2-3B-Instruct-4bit
- Fallback: Phi-4-mini-instruct-4bit

Override by setting `OPENAI_MODEL` environment variable before running.
