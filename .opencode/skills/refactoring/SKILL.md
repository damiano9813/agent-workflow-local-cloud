---
name: refactoring
description: Use when restructuring code, simplifying design, renaming, extracting logic, reducing duplication, or improving maintainability.
---

# Refactoring

Preserve behavior unless the user explicitly asks for behavior changes.

1. Understand existing behavior and tests.
2. Ask the explore agent for dependencies and callers when scope is non-trivial.
3. Validate the dependency map before editing.
4. Make the smallest coherent refactor.
5. Keep public interfaces stable unless explicitly changing them.
6. Run relevant tests.
7. Ask the reviewer agent to check for regressions when useful.

Do not mix refactoring with unrelated cleanup.
