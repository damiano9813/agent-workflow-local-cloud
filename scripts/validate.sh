#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

ok() {
  printf 'OK: %s\n' "$1"
}

require_file() {
  local path="$1"

  [ -f "$ROOT_DIR/$path" ] || fail "missing file $path"
  ok "found $path"
}

require_dir() {
  local path="$1"

  [ -d "$ROOT_DIR/$path" ] || fail "missing directory $path"
  ok "found $path"
}

check_contains() {
  local path="$1"
  local pattern="$2"

  grep -q "$pattern" "$ROOT_DIR/$path" || fail "$path does not contain expected pattern: $pattern"
  ok "$path contains $pattern"
}

require_file "README.md"
require_file "AGENTS.md"
require_file ".opencode/opencode.jsonc"
require_file "scripts/install.sh"
require_file "scripts/validate.sh"

require_dir ".opencode/agent"
require_dir ".opencode/command"
require_dir ".opencode/skills"

for agent in explore reviewer scout stacktrace; do
  require_file ".opencode/agent/$agent.md"
  check_contains ".opencode/agent/$agent.md" "mode: subagent"
  check_contains ".opencode/agent/$agent.md" "edit: deny"
done

for command in debug explore feature refactor review scout; do
  require_file ".opencode/command/$command.md"
done

for skill in bug-fixing code-review feature-implementation java react refactoring spring-boot; do
  require_file ".opencode/skills/$skill/SKILL.md"
  check_contains ".opencode/skills/$skill/SKILL.md" "^name: $skill$"
  check_contains ".opencode/skills/$skill/SKILL.md" "^description:"
done

bash -n "$ROOT_DIR/scripts/install.sh"
bash -n "$ROOT_DIR/scripts/validate.sh"
ok "shell scripts parse"

node -e "JSON.parse(require('fs').readFileSync('$ROOT_DIR/.opencode/opencode.jsonc','utf8'))" || fail "invalid .opencode/opencode.jsonc"
ok "opencode.jsonc parses as JSON"

if command -v opencode >/dev/null 2>&1; then
  agent_list="$(cd "$ROOT_DIR" && opencode agent list)"
  for agent in build plan explore reviewer scout stacktrace; do
    [[ $'\n'"$agent_list"$'\n' == *$'\n'"$agent "* ]] || fail "opencode agent list missing $agent"
  done
  ok "opencode loads expected agents"
else
  printf 'WARN: opencode not found; skipped opencode agent list check\n'
fi

printf '\nValidation complete.\n'
