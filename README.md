# Dotfiles

macOS shell + AI-agent (Claude Code, Codex) config, shared across machines.
No secrets and no machine-specific values are tracked; both live in gitignored files.

## Quick start

```bash
git clone https://github.com/igmarin/dotfiles.git ~/Developer/Personal/dotfiles
cd ~/Developer/Personal/dotfiles
./setup.sh                  # works from any clone location
$EDITOR ~/.zsh/keys.zsh     # paste real keys (never committed)
$EDITOR ~/.zsh/local.zsh    # machine-specific aliases (never committed)
exec zsh
```

## Prerequisites

Install first: [Homebrew](https://brew.sh), [oh-my-zsh](https://ohmyz.sh), `mise`, `zoxide`.
Optional (guarded, skipped if missing): `podman`, `bun`, `mlx-lm`, `graphify`.

## What `setup.sh` does

1. Copies `.zsh/*` to `~/.zsh/` and `.zshrc` to `~/.zshrc`
2. Creates `~/.zsh/keys.zsh` and `~/.zsh/local.zsh` from their templates if missing (never overwrites)
3. Symlinks `claude/CLAUDE.md`, `claude/settings.json` into `~/.claude/` and `codex/AGENTS.md` into `~/.codex/`
4. Moves any existing real file it would replace to `<name>.bak`

Re-running is safe. Since `.zsh/` and `.zshrc` are copies, re-run `setup.sh` after editing them here.

## Structure

```
.zshrc                  entry point: sources ~/.zsh/*.zsh, bun, mise, zoxide
.zsh/
  env.zsh               environment variables
  path.zsh              PATH, pkg-config, podman socket, bun (brew prefix auto-detected)
  oh-my-zsh.zsh         oh-my-zsh setup
  aliases.zsh           shared aliases
  mlx.zsh               local MLX LLM server helpers
  keys.zsh.template     API key placeholders        -> copy to keys.zsh   (gitignored)
  local.zsh.template    host/user-specific aliases  -> copy to local.zsh  (gitignored)
claude/                 CLAUDE.md, settings.json    -> ~/.claude/
codex/                  AGENTS.md                   -> ~/.codex/
AGENTS.md / CLAUDE.md   rules for agents working in this repo
setup.sh                bootstrap
```

## Rules for this repo

- **Secrets:** real keys only in `~/.zsh/keys.zsh`. Templates hold `YOUR_…` placeholders.
- **No hardcoded paths:** use `$HOME`, `$(brew --prefix)`, or derive from the script location. Put hostnames and usernames in `local.zsh`.
- **Before committing:** `git diff --cached | grep -nEi 'sk-|ghp_|hf_|token=|key='` should show only placeholders.
- GitHub push protection is on; if it blocks a push, remove the secret from history rather than allowing it.

## AI agents (Claude Code + Codex)

- `claude/CLAUDE.md` and `codex/AGENTS.md` are global instructions (always-on complexity check, ponytail, secrets rules).
- `claude/settings.json` is the portable subset: allowed MCP tools, plugins, and deny rules for `.env*`, `~/.ssh`, `~/.aws`, `keys.zsh` and force-pushes.
- Machine-specific hooks and statusline paths go in `~/.claude/settings.local.json`, not here.
- Because they are symlinks, tools that edit `~/.claude/CLAUDE.md` (lean-ctx, CodeGraph) change the repo file; review with `git diff` before committing.

## MLX helpers

`graphify-mlx {init|extract|update}` starts a local MLX server, runs graphify, then stops the server.
Model is `$OPENAI_MODEL` if set, otherwise auto-detected by CPU architecture (`detect_mlx_model` in `.zsh/mlx.zsh`).
`mlx-on-demand [model] [port] [tokens]` runs the server alone.

## Troubleshooting

- **Push blocked by secret scanning:** `git rm --cached <file>`, add it to `.gitignore`, amend or rewrite the commit that added it, then rotate the key if it was ever pushed.
- **Slow shell start:** `brew --prefix` and `podman machine inspect` run at startup; both are guarded and cached in `HOMEBREW_PREFIX` where possible.
