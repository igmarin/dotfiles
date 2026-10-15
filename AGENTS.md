# dotfiles

Personal shell + AI-agent config. Read by Codex, and by Claude Code via `CLAUDE.md`.

## Layout
- `.zshrc`, `.zsh/*.zsh` — shell config, copied to `~/.zsh` by `setup.sh`
- `claude/` — `CLAUDE.md`, `settings.json`, symlinked into `~/.claude/`
- `codex/` — `AGENTS.md`, symlinked into `~/.codex/`

## Rules
- NEVER commit secrets. Real keys live only in `~/.zsh/keys.zsh` (gitignored). `.zsh/keys.zsh.template` holds `YOUR_…` placeholders only.
- Before any commit: `git diff --cached | grep -nEi 'sk-|ghp_|hf_|token=|key='` and confirm nothing real appears.
- Never read or print `.zsh/keys.zsh`; mask values if you must inspect it.
- `setup.sh` stays idempotent and backs up anything it replaces (`*.bak`).
- No force-push or history rewrite without explicit user approval.
- Keep `claude/CLAUDE.md` and `codex/AGENTS.md` short; point to skills instead of inlining detail.
