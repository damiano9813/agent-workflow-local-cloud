---
name: bug-fixing
description: Use when fixing bugs, failing tests, runtime errors, regressions, exceptions, stacktraces, or incorrect behavior.
---

# Bug Fixing

Use a diagnosis-first workflow.

1. Reproduce or understand the failure.
2. If the affected area spans more than one or two files, ask the stacktrace or explore agent for read-only analysis.
3. Validate the agent report against the repository.
4. Identify the smallest correct fix.
5. Update or add tests when feasible.
6. Run targeted verification.

Do not patch symptoms without understanding the execution path.
