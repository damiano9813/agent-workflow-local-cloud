#!/usr/bin/env bash
set -euo pipefail

DEFAULT_BUILD_MODEL="openai/gpt-5.5"
DEFAULT_PLAN_MODEL="openai/gpt-5.5"
DEFAULT_EXPLORE_MODEL="llamacpp/unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_XL"
DEFAULT_SCOUT_MODEL="llamacpp/unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_XL"
DEFAULT_REVIEW_MODEL="llamacpp/unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_XL"
DEFAULT_STACKTRACE_MODEL="llamacpp/unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_XL"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

prompt() {
  local label="$1"
  local default="$2"
  local value

  read -r -p "$label [$default]: " value
  printf '%s' "${value:-$default}"
}

confirm() {
  local label="$1"
  local value

  read -r -p "$label [y/N]: " value
  case "$value" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

backup_path() {
  local path="$1"
  local timestamp="$2"

  if [ -e "$path" ]; then
    mv "$path" "$path.bak.$timestamp"
    printf 'Backed up %s -> %s\n' "$path" "$path.bak.$timestamp"
  fi
}

write_opencode_config() {
  local path="$1"
  local instructions_json="$2"
  local build_model="$3"
  local plan_model="$4"

  cat > "$path" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "model": "$build_model",
  "small_model": "$plan_model",
  "default_agent": "build",
  "instructions": $instructions_json,
  "skills": {
    "paths": [".opencode/skills"]
  },
  "agent": {
    "build": {
      "model": "$build_model",
      "mode": "primary",
      "description": "Lead engineer for implementation, refactoring, tests, documentation, validation, and final responses."
    },
    "plan": {
      "model": "$plan_model",
      "mode": "primary",
      "description": "Lead architect for planning, design decisions, and implementation strategy."
    }
  }
}
EOF
}

set_agent_model() {
  local file="$1"
  local model="$2"

  MODEL="$model" perl -0pi -e 's/model: .*?\n/model: $ENV{MODEL}\n/s' "$file"
}

set_command_model() {
  local file="$1"
  local model="$2"

  MODEL="$model" perl -0pi -e 's/model: .*?\n/model: $ENV{MODEL}\n/s' "$file"
}

main() {
  local default_target="${1:-$(pwd)}"
  local target_path
  local build_model
  local plan_model
  local explore_model
  local scout_model
  local review_model
  local stacktrace_model
  local instruction_file
  local instructions_json
  local timestamp

  printf 'OpenCode multi-agent workflow installer\n\n'

  target_path="$(prompt "Target project path" "$default_target")"
  target_path="$(realpath -m "$target_path")"

  if [ ! -d "$target_path" ]; then
    printf 'Target path does not exist or is not a directory: %s\n' "$target_path" >&2
    exit 1
  fi

  if [ "$target_path" = "$TEMPLATE_DIR" ]; then
    printf 'Refusing to install the template into itself: %s\n' "$target_path" >&2
    exit 1
  fi

  build_model="$(prompt "Build model" "$DEFAULT_BUILD_MODEL")"
  plan_model="$(prompt "Plan model" "$DEFAULT_PLAN_MODEL")"
  explore_model="$(prompt "Explore model" "$DEFAULT_EXPLORE_MODEL")"
  scout_model="$(prompt "Scout model" "$DEFAULT_SCOUT_MODEL")"
  review_model="$(prompt "Review model" "$DEFAULT_REVIEW_MODEL")"
  stacktrace_model="$(prompt "Stacktrace model" "$DEFAULT_STACKTRACE_MODEL")"

  if [ -e "$target_path/AGENTS.md" ]; then
    instruction_file="OPEN_CODE_WORKFLOW.md"
    instructions_json='["AGENTS.md", "OPEN_CODE_WORKFLOW.md"]'
  else
    instruction_file="AGENTS.md"
    instructions_json='["AGENTS.md"]'
  fi

  printf '\nInstallation summary:\n'
  printf 'Target: %s\n' "$target_path"
  printf 'Instruction file: %s\n' "$instruction_file"
  printf 'Build: %s\n' "$build_model"
  printf 'Plan: %s\n' "$plan_model"
  printf 'Explore: %s\n' "$explore_model"
  printf 'Scout: %s\n' "$scout_model"
  printf 'Review: %s\n' "$review_model"
  printf 'Stacktrace: %s\n' "$stacktrace_model"

  if [ -e "$target_path/.opencode" ] || [ -e "$target_path/$instruction_file" ]; then
    printf '\nExisting OpenCode workflow files were found. They will be backed up before overwrite.\n'
  fi

  if ! confirm "Continue with installation"; then
    printf 'Installation cancelled.\n'
    exit 0
  fi

  timestamp="$(date +%Y%m%d-%H%M%S)"

  backup_path "$target_path/.opencode" "$timestamp"
  backup_path "$target_path/$instruction_file" "$timestamp"

  cp -R "$TEMPLATE_DIR/.opencode" "$target_path/.opencode"
  cp "$TEMPLATE_DIR/AGENTS.md" "$target_path/$instruction_file"

  write_opencode_config "$target_path/.opencode/opencode.jsonc" "$instructions_json" "$build_model" "$plan_model"

  set_agent_model "$target_path/.opencode/agent/explore.md" "$explore_model"
  set_agent_model "$target_path/.opencode/agent/scout.md" "$scout_model"
  set_agent_model "$target_path/.opencode/agent/reviewer.md" "$review_model"
  set_agent_model "$target_path/.opencode/agent/stacktrace.md" "$stacktrace_model"

  set_command_model "$target_path/.opencode/command/feature.md" "$build_model"
  set_command_model "$target_path/.opencode/command/refactor.md" "$build_model"

  printf '\nInstalled OpenCode multi-agent workflow in %s\n' "$target_path"
  printf 'Restart OpenCode from the target project for changes to take effect.\n'
}

main "$@"
