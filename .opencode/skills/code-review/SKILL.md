---
name: code-review
description: Use when reviewing code, diffs, pull requests, proposed changes, regressions, risks, or missing tests.
---

# Code Review

Use a findings-first review style.

Prioritize:

- Correctness bugs.
- Behavioral regressions.
- Security issues.
- Missing tests.
- Edge cases.
- Maintainability risks.

When using the reviewer agent, validate its findings before accepting them. If no findings are found, state that explicitly and mention testing gaps.

Avoid broad style opinions unless they affect correctness or maintainability.
