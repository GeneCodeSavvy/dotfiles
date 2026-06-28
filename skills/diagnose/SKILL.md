---
name: diagnose
description: Use when something is broken, failing, slow, throwing, flaky, or behaving unexpectedly.
---

# Diagnose

Build a tight failing loop and find root cause before proposing fixes.

## Boundary

Diagnose owns investigation until there is a root cause and a red-capable loop.
Do not jump to `build` while the failure is still a theory.

## Process

1. Reproduce the exact user-visible symptom.
2. Build the tightest possible loop that can go red for this bug.
3. Minimize the scenario until remaining inputs, state, and steps are load-bearing.
4. Form ranked, falsifiable hypotheses before changing production code.
5. Instrument one boundary or variable at a time.
6. When root cause is identified, create or preserve the regression signal.
7. Move to `build` for the fix.

## Reference Branches

- Use `diagnosing-bugs` for hard bugs, performance regressions, flakiness, and
  feedback-loop construction.
- Use `systematic-debugging` for strict root-cause discipline and multi-layer
  evidence gathering.

## Specialist Branches

- `firecrawl` when current external docs, issue trackers, or release notes may
  explain the failure.
- `vercel-react-best-practices` when the failure is React/Next performance or
  data-flow related.

## Completion

Done when there is one command or reliable loop that demonstrates the bug, a
clear root-cause hypothesis supported by evidence, and a path to a regression
test or documented reason no correct seam exists.
