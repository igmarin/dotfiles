<!-- always-on:begin -->
## Always-on: complexity check + ponytail (global, all agents)

1. **Complexity check (every coding task, before starting):**
   `python3 ~/.agents/skills/task-complexity-classifier/classifier.py "<one-line task summary>"`
   (needs `TYPESAFE_API_KEY`, set in `~/.zshrc`; it falls back to "complex" on failure. Never block on it.)
   - `routine` → use the fastest/cheapest model available, do the minimum.
   - `standard` → default model.
   - `complex` → strongest model / reasoning mode; plan before editing.
   Switch models only if your agent allows it; otherwise just state the class and adjust effort.
   Skip for non-coding chat.
2. **Ponytail (every coding task, default intensity "full"):** apply the `ponytail` skill (`~/.agents/skills/ponytail/SKILL.md`):
   question whether the task needs to exist, prefer stdlib/native over dependencies, shortest working solution,
   no speculative abstractions. Use `ponytail-review` / `ponytail-audit` for reviews. Skip for non-coding requests.
<!-- always-on:end -->

## Secrets (global)
- Never read, print, or commit `~/.zsh/keys.zsh`, `.env*`, `~/.ssh/*`, or any token/API key. Mask values when inspecting.
- Before committing, scan the staged diff for key patterns (`sk-`, `ghp_`, `hf_`, `token=`).
- Confirm before force-push, history rewrite, or deleting files.
