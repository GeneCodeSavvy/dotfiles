---
name: design
description: Use when architecture, module boundaries, interfaces, HLD, LLD, component APIs, or refactor plans need deliberate design.
---

# Design

Create the technical shape before code when the task needs design depth.

## Boundary

Design is for consequential structure. Do not use it for every routine feature
or bugfix.

## Process

1. Confirm the design question and the decision that needs to be made.
2. Load the narrowest relevant docs and code.
3. Choose the smallest fitting design reference:
   - `hld-design` for production architecture and system design.
   - `lld-writer` after PRD, HLD, or API contract exists.
   - `codebase-design` for deep modules, boundaries, and testability.
   - `design-an-interface` for multiple API or module interface options.
   - `improve-codebase-architecture` for architecture opportunity scans.
   - `request-refactor-plan` for incremental refactor plans.
4. State tradeoffs explicitly and recommend one path.
5. Record durable architectural decisions as ADRs only when they are hard to
   reverse, surprising without context, and tradeoff-driven.

## Specialist Branches

- `firecrawl` for current external technical docs or framework references.
- `prompt-architect` for prompt/system-message design.
- `hallmark` for UI design quality.
- `landing-page-conversion` for landing-page structure and conversion design.
- `web-animation-design` for motion design.
- `vercel-react-best-practices` for React or Next.js architecture/performance.
- `vercel-composition-patterns` for React component APIs.
- `vercel-react-view-transitions` for React View Transition API design.
- `prototype` when a spike is needed to resolve feasibility.

## Completion

Done when the design names the chosen structure, the rejected alternatives, the
main tradeoffs, and the next phase.
