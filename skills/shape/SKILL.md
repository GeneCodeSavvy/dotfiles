---
name: shape
description: Use when a loose idea, ambiguous request, unclear requirements, or pre-implementation planning task needs routing into the right shaping workflow before design or build; covers grilling, workflow specs, decision maps, PRDs, issue breakdowns, glossary updates, ADR candidates, and specialist research/prototype branches.
---

# Shape

Turn loose intent into a precise, approved artifact before implementation.

## Boundary

Shape ends at an approved spec, PRD, issue breakdown, decision map, glossary
update, or ADR candidate. It does not implement.

  ## Process

  1. Classify the shaping job before loading another skill. Identify:
     - the artifact needed: sharper understanding, workflow spec, decision map, PRD, or issues
     - the uncertainty source: missing user intent, missing domain language, missing external evidence, unclear feasibility, or already-settled context
     - the next phase likely needed: `design`, `build`, or `coordinate`

  2. Load the smallest fitting source workflow:
     - `grilling` when the plan needs interview-driven sharpening but no repo/domain docs need updating.
     - `grill-with-docs` when the plan lives in a codebase and glossary terms, ADR candidates, or domain decisions may need to be captured.
     - `loop-me` when the artifact is a repeatable workflow spec for `docs/workflows/*.md`.
     - `decision-mapping` when the idea has enough fog of war to require ordered research, prototype, or grilling tickets across multiple sessions.
     - `to-prd` when the conversation is already settled enough to synthesize a PRD. Do not interview first unless a blocking gap remains.
     - `to-issues` when an approved plan, spec, or PRD needs independently grabbable implementation issues.

  3. Add specialist branches only when their trigger is present:
     - `firecrawl` when current external docs, websites, or web evidence are needed and Firecrawl is the chosen collection path.
     - `prompt-architect` when the shaped artifact is a prompt, system message, or prompt requirements.
     - `hallmark` when UI/product experience direction is a first-class part of the shape.
     - `landing-page-conversion` when the artifact is a conversion-focused landing page, funnel, offer, or page critique.
     - `prototype` when a throwaway proof is needed to answer a feasibility, state-model, behavior, or visual-direction question.

  4. When multiple skills apply, sequence them by dependency:
     - clarify first with `grilling`, `grill-with-docs`, `loop-me`, or `decision-mapping`
     - gather evidence or prototype only for questions that block the artifact
     - synthesize afterward with `to-prd` or `to-issues`
     - do not create downstream artifacts until the upstream shape is approved or clearly sufficient

  5. Before proceeding, state the selected route in one sentence:
     `Route: <skills> -> <artifact>, because <reason>.`

## Completion

Done when the user has approved the shaped artifact or the next phase is clearly
identified as `design`, `build`, or `coordinate`.
