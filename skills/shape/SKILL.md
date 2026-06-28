---
name: shape
description: Use when requirements are unclear, a plan needs grilling, or the task needs a PRD, issue breakdown, vocabulary, or decisions before implementation.
---

# Shape

Turn loose intent into a precise, approved artifact before implementation.

## Boundary

Shape ends at an approved spec, PRD, issue breakdown, decision map, glossary
update, or ADR candidate. It does not implement.

## Process

1. Start with `grill-with-docs`
2. Create the requested shaping artifact with the smallest fitting source
   workflow:
   - `brainstorming` for broad design exploration.
   - `grilling`, `grill-with-docs`, or `loop-me` for interview-driven sharpening.
   - `decision-mapping` for ordered investigation tickets.
   - `to-prd` for a PRD from the current conversation.
   - `to-issues` for independently grabbable implementation issues.

## Specialist Branches

- `firecrawl` when the shape depends on current external docs, websites, or web research.
- `prompt-architect` for prompt requirements or prompt design.
- `hallmark` for UI/product experience direction.
- `landing-page-conversion` for conversion-page strategy, copy, or funnel shape.
- `prototype` when a throwaway proof is needed to clarify feasibility.

## Completion

Done when the user has approved the shaped artifact or the next phase is clearly
identified as `design`, `build`, or `coordinate`.
