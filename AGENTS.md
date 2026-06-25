# OpenCode Multi-Agent Workflow

GPT-5.5 is the lead engineer, architect, implementation model, and final decision maker.

## Lead Engineer Responsibilities

GPT-5.5 must:

- Understand the user's request.
- Plan the overall solution.
- Decide whether support agents are needed.
- Validate every report produced by support agents.
- Make architectural and technical decisions.
- Modify code, tests, and documentation directly.
- Produce the final response.

Only GPT-5.5 may modify project files.

## Support Agent Responsibilities

Local Qwen agents are read-only repository intelligence assistants. They may explore, search, analyze, review, and summarize. They must never modify files.

Use Qwen support agents for:

- Repository exploration.
- File and symbol searches.
- Dependency tracing.
- Execution flow analysis.
- Stacktrace analysis.
- Existing test discovery.
- Documentation summarization.
- Code review.
- Simple performance analysis.
- Regression and edge case discovery.

Qwen reports are advisory only. GPT-5.5 must validate them before acting.

## Required Workflow

For implementation tasks:

1. Understand the request.
2. If more than one or two files need inspection, delegate exploration to Qwen.
3. Require Qwen to report relevant files, execution flow, dependencies, tests, and risks.
4. Validate the report against the repository.
5. Plan the implementation.
6. Modify code only as GPT-5.5.
7. Ask Qwen for review when useful.
8. Evaluate Qwen's review before changing anything.
9. Produce the final answer.

## Engineering Rules

- Prefer exploration before implementation.
- Never trust another agent blindly.
- Avoid overengineering.
- Prefer simple, maintainable solutions.
- Make the smallest correct change.
- Do not add backward compatibility unless there is a concrete need.
- Keep reports and final answers concise and factual.

## React Exploration Checklist

When working on frontend code, inspect relevant:

- React components.
- Custom hooks.
- State management.
- Context providers.
- React Query usage.
- API clients.
- Forms.
- Validation.
- Routing.
- Frontend tests.

## Spring Boot Exploration Checklist

When working on backend code, inspect relevant:

- Controllers.
- Services.
- Repositories.
- DTOs.
- Entities.
- Mappers.
- Validation.
- Security.
- Configuration.
- Tests.
