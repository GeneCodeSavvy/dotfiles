---
name: build
description: Use when implementing a clear feature, fix, refactor, migration, scaffold, or behavior change.
---

# Build

Implement clear behavior with test-first discipline and surgical changes.

## Boundary

Build starts after requirements are clear enough to change files. If the task is
ambiguous, go to `shape`; if the failure is not understood, go to `diagnose`.

## Process

1. State assumptions, success criteria, and the smallest useful change.
2. Use the `implement` skill
3. Write or identify the failing test before production behavior changes unless
   the task is docs-only, config-only, or explicitly exempted.
4. Make the smallest production change that satisfies the test.
5. Refactor only after green, and only within the task boundary.
6. Run the focused verification, then broader checks proportional to risk.

## Specialist Branches

- `prompt-architect` for prompt implementation.
- `hallmark` for UI implementation quality.
- `landing-page-conversion` for conversion landing pages.
- `web-animation-design` for animation implementation.
- `vercel-react-best-practices` for React or Next.js implementation/performance.
- `vercel-composition-patterns` for React component APIs.
- `vercel-react-view-transitions` for React View Transition API work.
- `prototype` for throwaway proof-of-concept implementation.

## Completion

Done when the requested behavior is implemented, verification has run, and the
diff is limited to lines that trace back to the task.
