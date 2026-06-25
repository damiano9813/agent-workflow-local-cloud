---
description: Run an exploration-first GPT-5.5 feature workflow with Qwen support when repository inspection is non-trivial.
agent: build
model: openai/gpt-5.5
---

Implement this feature request using the multi-agent workflow:

$ARGUMENTS

Required process:

1. Understand the request and constraints.
2. If more than one or two files need inspection, delegate exploration to the explore agent.
3. Validate the explore report against the repository before acting.
4. Plan a simple maintainable implementation.
5. Modify code, tests, and documentation only as GPT-5.5.
6. Ask the reviewer agent for a read-only review when useful.
7. Validate the review and apply only justified changes.
8. Run appropriate verification when feasible.
9. Final response: summarize changes, verification, and any follow-up risks.
