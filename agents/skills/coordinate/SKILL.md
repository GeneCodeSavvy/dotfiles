---
name: coordinate
description: Use when work needs a worktree, written plan execution, parallel tasks, subagents, or multi-step implementation coordination.
---

# Coordinate

Manage execution mechanics without taking over design or behavior decisions.

## Boundary

Coordinate owns how work is split, isolated, sequenced, delegated, and verified.
It does not decide what should be built.

## Process

1. Confirm the work has an approved plan or clear task list.
2. Choose the coordination workflow:
   - `using-git-worktrees` for isolated feature work.
   - `executing-plans` for executing a written plan in a separate session.
   - `dispatching-parallel-agents` for two or more independent tasks.
   - `subagent-driven-development` for plan execution with fresh subagents and review loops.
3. Define ownership boundaries for files or modules before parallel work starts.
4. Keep at most one blocking task local; delegate only independent sidecar work.
5. Integrate results and run the plan's verification checks.

## Specialist Branches

- `firecrawl` when a delegated task needs current external research.
- `prototype` when a delegated spike can resolve uncertainty.

## Completion

Done when each task has a clear owner/status, verification evidence exists, and
the next phase is `review` or `finish`.
