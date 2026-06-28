---
name: orient
description: Use when starting engineering work, choosing a workflow, resolving skill ambiguity, or loading narrow project context.
---

# Orient

Choose the single canonical phase for the task, then attach specialists only
when their trigger is explicit.

## Boundary

Orient decides where the work belongs. It does not perform the downstream
workflow.

## Process

1. Read the user intent and any named skills.
2. Load the narrowest relevant project docs, starting from `docs/README.md`
   when this repo's context matters.
3. Pick exactly one canonical phase:
   - `shape` for unclear requirements, grilling, PRDs, issues, vocabulary, or decisions.
   - `design` for architecture, interfaces, module boundaries, HLD, LLD, or refactor plans.
   - `diagnose` for bugs, failures, regressions, or unexpected behavior.
   - `build` for clear implementation work.
   - `coordinate` for worktrees, written plans, subagents, or parallel execution.
   - `review` for code review, QA, triage, or review feedback.
   - `finish` for verified work that needs PR, merge, cleanup, handoff, or conflict completion.
4. Attach root specialists only when their domain trigger appears.
5. State the chosen phase and specialists before continuing.

## Specialist Branches

- `firecrawl` for live web search, scraping, external docs, or site research.
- `prompt-architect` for prompt engineering or prompt review.
- `hallmark` for greenfield UI, redesign, visual quality, or design extraction.
- `landing-page-conversion` for conversion-focused landing pages.
- `web-animation-design` for motion, easing, transitions, or microinteractions.
- `web-design-guidelines` for UI, UX, accessibility, or web interface review.
- `vercel-react-best-practices` for React or Next.js performance and implementation patterns.
- `vercel-composition-patterns` for React component APIs and prop sprawl.
- `vercel-react-view-transitions` for React View Transition API work.
- `prototype` for throwaway feasibility demos or interaction spikes.

## Completion

Done when the task has one canonical phase, any specialists are justified by
explicit triggers, and the next workflow is clear.
