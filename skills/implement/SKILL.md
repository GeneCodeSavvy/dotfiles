---
name: implement
description: "Implement a piece of work based on a PRD or set of issues."
disable-model-invocation: true
---

Read `~/.codex/CODE_GUIDELINES.md`, and local CODE_GUIDELINE.md if they exists.

Implement the work described by the user in the PRD or issues respecting the guidelines.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /review to review the work.

Finally, create a `qa` plan for a human to QA the completed work.

Commit your work to the current branch.
