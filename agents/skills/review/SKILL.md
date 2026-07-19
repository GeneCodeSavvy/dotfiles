---
name: review
description: Use when reviewing code, reviewing UI, requesting review, handling review feedback, running QA, or triaging issues and PRs.
---

# Review

Evaluate work and handle feedback without mixing review with implementation or
branch completion.

## Boundary

Review owns evaluation, QA, triage, and feedback handling. Use `finish` after
work is verified and the branch needs PR, merge, cleanup, or handoff.

## Process

1. Identify what kind of review is being requested.
2. Pick the smallest fitting reference:
   - `two-axis-review` for reviewing changes since a fixed point against standards and spec.
   - `requesting-code-review` when completed work needs an independent review.
   - `receiving-code-review` when evaluating review feedback before applying it.
   - `qa` for conversational QA that files issues.
   - `triage` for categorizing and preparing issues or external PRs.
3. Lead with findings, ordered by severity, with file and line references when
   reviewing code.
4. Separate confirmed issues from questions, assumptions, and residual risks.
5. Do not implement fixes unless the user explicitly asks for the review
   feedback to be applied.

## Specialist Branches

- `web-design-guidelines` for UI, UX, accessibility, or web interface review.
- `hallmark` for visual design quality review or anti-generic UI checks.
- `landing-page-conversion` for landing-page conversion review.
- `web-animation-design` for motion quality review.
- `vercel-react-best-practices` for React or Next.js performance review.
- `vercel-composition-patterns` for React component API review.
- `prompt-architect` for prompt review.

## Completion

Done when findings, open questions, and residual risks are clearly separated,
or when review feedback has been technically evaluated and the next phase is
`build` or `finish`.
