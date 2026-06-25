---
description: Run an exploration-first GPT-5.5 refactoring workflow with Qwen support and behavior preservation.
agent: build
model: openai/gpt-5.5
---

Refactor the requested code using the multi-agent workflow:

$ARGUMENTS

Required process:

1. Understand the current behavior and refactor goal.
2. If more than one or two files need inspection, delegate exploration to the explore agent.
3. Validate the explore report against the repository before acting.
4. Plan the smallest behavior-preserving change.
5. Modify code and tests only as GPT-5.5.
6. Ask the reviewer agent for a read-only review when useful.
7. Validate the review and apply only justified changes.
8. Run appropriate verification when feasible.
9. Final response: summarize changes, behavior preserved, verification, and risks.
