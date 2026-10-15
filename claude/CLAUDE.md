<!-- lean-ctx -->
<!-- lean-ctx-claude-v8 -->
## lean-ctx — Context Runtime

When the `ctx_*` MCP tools are listed in this session, prefer them over native equivalents:
- `ctx_read` instead of `Read` / `cat` for exploration (cached, 10 modes, re-reads ~13 tokens)
- `ctx_shell` instead of `bash` / `Shell` (95+ compression patterns)
- `ctx_search` instead of `Grep` / `rg` (compact results)
- `ctx_tree` instead of `ls` / `find` (compact directory maps)
- Edits: `ctx_read(mode="anchored")` → `ctx_patch` (line+hash anchors, never echo old text; `op=create` for new files). `ctx_edit` (str_replace) is the legacy power-profile fallback.

Native `Read` → `Edit`/`StrReplace` stays fully supported — the edit gate requires a
prior native Read of the same file path. Auto memory under
`~/.claude/projects/<slug>/memory/` also uses native Read/Edit (not MCP resources).
Write, Delete, Glob — use normally.
If no `ctx_*` tools are listed in this session, use the native tools throughout.

Read modes: anchored (edit), full (verbatim), map (overview), signatures (API), diff (post-edit), lines:N-M (range), auto.
Details live in the `lean-ctx` skill (loads on demand — keep this file lean).
<!-- /lean-ctx -->
# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->

<!-- i-have-adhd always-on -->
## Output style (ADHD — always-on)

The reader has ADHD. Shape every response so it can be acted on:

1. Lead with the answer or next action: command, path, or snippet first.
2. Number multi-step work; one bounded action per step.
3. End with one next action doable in under two minutes.
4. Finish the current issue before raising a new one.
5. Restate progress each turn ("step 3 of 5 done").
6. Give time estimates in concrete units, never "a bit".
7. After a change, show what now works.
8. Errors: state location, cause, and fix. No drama.
9. Cap lists at 5 items.
10. No preamble, no recaps, no closers.

Exceptions: explain fully when asked to explain. Confirm before destructive actions. After three failed fixes, stop and name the doubtful assumption. If the request is ambiguous, ask one short question.
<!-- /i-have-adhd always-on -->

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
