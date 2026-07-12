#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

mkdir -p "$TEST_ROOT/bin" "$TEST_ROOT/home"
cat > "$TEST_ROOT/bin/brew" <<'EOF'
#!/usr/bin/env bash
if [[ "$*" == "list --cask font-monaspace" ]]; then
  exit 1
fi
exit 0
EOF
printf '#!/usr/bin/env bash\nexit 0\n' > "$TEST_ROOT/bin/tmux"
chmod +x "$TEST_ROOT/bin/brew" "$TEST_ROOT/bin/tmux"

command -v stow >/dev/null || {
  echo "stow is required to run installer tests" >&2
  exit 1
}

export HOME="$TEST_ROOT/home"
export PATH="$TEST_ROOT/bin:$PATH"

run_only() {
  "$ROOT/install.sh" --dry-run --only "$1" --platform-test darwin
}

assert_has() {
  [[ "$1" == *"$2"* ]] || {
    echo "Expected output to contain: $2" >&2
    exit 1
  }
}

assert_lacks() {
  [[ "$1" != *"$2"* ]] || {
    echo "Expected output not to contain: $2" >&2
    exit 1
  }
}

output="$(run_only codex)"
assert_has "$output" "brew install --cask font-monaspace"
assert_has "$output" "stow -t ~ codex"
assert_lacks "$output" "stow --adopt -t ~/.pi pi"
assert_lacks "$output" "Open a new Ghostty window"

output="$(run_only claude)"
assert_has "$output" "brew install --cask font-monaspace"
assert_has "$output" "stow -t ~ claude"
assert_lacks "$output" "stow --adopt -t ~/.pi pi"
assert_lacks "$output" "stow -t ~ codex"
assert_lacks "$output" "Open a new Ghostty window"

output="$(run_only pi)"
assert_has "$output" "stow --adopt -t ~/.pi pi"
assert_lacks "$output" "stow -t ~ codex"

for target in git ghostty tmux; do
  output="$(run_only "$target")"
  assert_has "$output" "stow --adopt $target"
  assert_lacks "$output" "stow --adopt -t ~/.pi pi"
  assert_lacks "$output" "stow -t ~ codex"
done

output="$($ROOT/install.sh --dry-run --platform-test darwin)"
assert_has "$output" "stow --adopt ghostty git tmux"
assert_has "$output" "stow --adopt -t ~/.pi pi"
assert_has "$output" "stow -t ~ codex"
assert_has "$output" "stow -t ~ claude"

rm -rf "$HOME/.codex"
"$ROOT/install.sh" --only codex --platform-test darwin >/dev/null
test -L "$HOME/.codex/AGENTS.md"
cmp -s "$HOME/.codex/AGENTS.md" "$ROOT/codex/.codex/AGENTS.md"

rm -rf "$HOME/.claude"
"$ROOT/install.sh" --only claude --platform-test darwin >/dev/null
test -L "$HOME/.claude/CLAUDE.md"
cmp -s "$HOME/.claude/CLAUDE.md" "$ROOT/claude/.claude/CLAUDE.md"

rm "$HOME/.claude/CLAUDE.md"
echo "different" > "$HOME/.claude/CLAUDE.md"
if "$ROOT/install.sh" --only claude --platform-test darwin > "$TEST_ROOT/claude-conflict.log" 2>&1; then
  echo "Expected a conflicting CLAUDE.md to stop installation" >&2
  exit 1
fi
assert_has "$(cat "$TEST_ROOT/claude-conflict.log")" "differs from the dotfiles copy"
test ! -L "$HOME/.claude/CLAUDE.md"
test "$(cat "$HOME/.claude/CLAUDE.md")" = "different"

cp "$ROOT/claude/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
"$ROOT/install.sh" --only claude --platform-test darwin >/dev/null
test -L "$HOME/.claude/CLAUDE.md"
cmp -s "$HOME/.claude/CLAUDE.md" "$ROOT/claude/.claude/CLAUDE.md"

rm "$HOME/.codex/AGENTS.md"
echo "different" > "$HOME/.codex/AGENTS.md"
if "$ROOT/install.sh" --only codex --platform-test darwin > "$TEST_ROOT/conflict.log" 2>&1; then
  echo "Expected a conflicting AGENTS.md to stop installation" >&2
  exit 1
fi
assert_has "$(cat "$TEST_ROOT/conflict.log")" "differs from the dotfiles copy"
test ! -L "$HOME/.codex/AGENTS.md"
test "$(cat "$HOME/.codex/AGENTS.md")" = "different"

cp "$ROOT/codex/.codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
"$ROOT/install.sh" --only codex --platform-test darwin >/dev/null
test -L "$HOME/.codex/AGENTS.md"
cmp -s "$HOME/.codex/AGENTS.md" "$ROOT/codex/.codex/AGENTS.md"

echo "install tests passed"
