---
name: finish
description: Use when verified work needs a PR, merge, keep/discard decision, handoff, cleanup, or merge-conflict completion.
---

# Finish

Close out verified work without skipping final checks or destroying state.

## Boundary

Finish starts after implementation and review are complete enough to decide what
happens to the branch or session.

## Process

1. Confirm the requested work is complete and verification has run.
2. Pick the source workflow:
   - `finishing-a-development-branch` for PR, merge, keep, discard, and worktree cleanup.
   - `handoff` when another agent or future session needs compact context.
   - `resolving-merge-conflicts` when an active merge or rebase conflict must be completed.
3. Present destructive or irreversible options explicitly.
4. Do not delete, discard, force-push, or clean up work without explicit approval
   when the source workflow requires it.
5. Report the final branch/session state and any remaining risk.

## Completion

Done when the work has been merged, PR'd, preserved, discarded with approval,
handed off, or conflict-resolved, and the user can see the resulting state.
