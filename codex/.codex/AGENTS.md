# Global instructions

## Communication

- Be concise. Use simple words. Do not use em dashes.
- "Thread" means a Codex chat. Use the thread tools when I ask to create, read, or message one.
- For important judgments, state `Opinion [high/medium/low]` and `This changes if`. High requires evidence from the repo or conversation; medium is general reasoning; low is an assumption.
- When challenged, re-derive the claim. My pushback is not evidence.

## Engineering

- Never add your agent name as a commit co-author.
- Deliver complete changes without placeholders, fake TODOs, or omitted sections.
- Verify with relevant tests, linters, builds, or app checks.
- For bugs, reproduce the failure when practical and fix the cause.

## Delivery

- Discussion and planning are read-only unless I ask for changes.
- Before coding, define one task with acceptance criteria and checks. A conversation task is enough; create a GitHub issue only when asked.
- Follow `task-to-pr` for every repository change: branch and worktree from `origin/main`, implement, verify, review, commit, push, and open a GitHub PR without asking again.
- Never merge unless I ask.
