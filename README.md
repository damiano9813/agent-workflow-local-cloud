# OpenCode Multi-Agent Workflow

Reusable OpenCode 1.17.11 configuration for a GPT-5.5 lead engineer with Local Qwen read-only support agents.

This template is optimized for React, Spring Boot, and Java projects.

## Architecture

GPT-5.5 is the lead engineer. It understands requests, plans solutions, validates agent reports, makes decisions, modifies files, updates tests and documentation, and produces final responses.

Local Qwen is a read-only support model. It explores repositories, traces dependencies, analyzes stacktraces, reviews code, discovers tests, and summarizes documentation. Qwen must not modify files.

## Model Mapping

- Build: `openai/gpt-5.5`
- Plan: `openai/gpt-5.5`
- Explore: `llamacpp/unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_XL`
- Scout: `llamacpp/unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_XL`
- Review: `llamacpp/unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_XL`
- Stacktrace: `llamacpp/unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_XL`

The Qwen provider is intentionally not duplicated here. It is expected to exist in your global OpenCode config, for example `~/.config/opencode/opencode.jsonc`.

## Usage

Copy `AGENTS.md` and `.opencode/` into the root of any project where you want this workflow.

Or run the interactive installer:

```bash
./scripts/install.sh /path/to/project
```

Preview an installation without changing files:

```bash
./scripts/install.sh --dry-run /path/to/project
```

If no path is provided, the installer asks for one and defaults to the current directory.

The installer prompts for:

- Target project path.
- Build model.
- Plan model.
- Explore model.
- Scout model.
- Review model.
- Stacktrace model.

If the target project already has `.opencode`, the installer asks for one confirmation, backs up the existing directory, and installs the workflow. Backups use the suffix `.bak.YYYYMMDD-HHMMSS`.

If the target project already has `AGENTS.md`, the installer does not overwrite it. It installs this workflow as `OPEN_CODE_WORKFLOW.md` and configures OpenCode to load both files.

Validate this template after editing it:

```bash
./scripts/validate.sh
```

From that project root, restart OpenCode after copying or editing configuration files. OpenCode loads config at startup and does not hot-reload it.

Ensure llama.cpp is running an OpenAI-compatible endpoint at:

```text
http://127.0.0.1:8080/v1
```

If your GPT-5.5 provider ID differs, update these values in `.opencode/opencode.jsonc` and command frontmatter:

```text
openai/gpt-5.5
```

## Agents

- `explore`: read-only repository exploration, execution flow, dependencies, tests, React/Spring Boot/Java structure.
- `reviewer`: read-only code review for bugs, regressions, missing tests, edge cases, and maintainability risks.
- `stacktrace`: read-only stacktrace, log, failing test, and runtime error analysis.
- `scout`: read-only documentation and repository convention summarization.

All Qwen agents deny file edits and ask before bash commands.

## Commands

- `/explore`: repository exploration with Qwen.
- `/review`: code or diff review with Qwen.
- `/debug`: error, stacktrace, log, or failing test analysis with Qwen.
- `/scout`: documentation, architecture, convention, setup, and testing summary with Qwen.
- `/feature`: GPT-5.5 feature workflow with exploration-first behavior.
- `/refactor`: GPT-5.5 behavior-preserving refactor workflow.

## Skills

- `bug-fixing`
- `feature-implementation`
- `refactoring`
- `code-review`
- `react`
- `spring-boot`
- `java`

These skills encode lightweight workflows and project-specific exploration checklists.

## Safety Rules

- GPT-5.5 is the only implementation model.
- Qwen agents are read-only assistants.
- Qwen reports must be validated before acting.
- Prefer exploration before implementation.
- Avoid overengineering.
- Make the smallest correct change.

## Future Improvements

Possible future improvements, not implemented here:

- Add project-specific command variants for Maven, Gradle, npm, pnpm, or Docker.
- Add stricter bash allowlists for Qwen agents once project command conventions are known.
- Add team-specific coding standards as extra instruction files.
