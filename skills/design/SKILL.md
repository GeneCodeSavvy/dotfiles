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

1. Classify the design job before loading another skill. Identify:
   - the decision needed: architecture, module boundary, interface, HLD, LLD,
     component API, refactor plan, or architecture opportunity scan
   - the design driver: scale, coupling, testability, migration risk,
     performance, user experience, framework constraint, or unclear tradeoff
   - the next phase likely needed: `build`, `coordinate`, or `finish`

2. Load only the narrowest relevant docs and code needed to answer that design
   question.

3. Load the smallest fitting source workflow:
   - `hld-design` for production architecture and system design.
   - `lld-writer` after PRD, HLD, or API contract exists.
   - `codebase-design` for deep modules, boundaries, and testability.
   - `design-an-interface` for multiple API or module interface options.
   - `improve-codebase-architecture` for architecture opportunity scans.
   - `grill-with-docs` when tradeoffs or decisions are not covered by existing
     docs or PRDs and need interview-driven clarification with documentation
     updates.

4. Add specialist branches only when their trigger is present:
   - `firecrawl` when current external technical docs or framework references
     are needed and Firecrawl is the chosen collection path.
   - `prompt-architect` for prompt/system-message design.
   - `hallmark` for UI design quality.
   - `landing-page-conversion` for landing-page structure and conversion design.
   - `web-animation-design` for motion design.
   - `vercel-react-best-practices` for React or Next.js architecture/performance.
   - `vercel-composition-patterns` for React component APIs.
   - `vercel-react-view-transitions` for React View Transition API design.
   - `prototype` when a spike is needed to resolve feasibility.
   - `lavish` when the design has more than three moving parts, or the design
     output is complex or visual enough to benefit from an HTML review artifact.

5. When multiple skills apply, sequence them by dependency:
   - inspect repo context before choosing architecture or interface shape
   - clarify missing tradeoffs or decisions with `grill-with-docs` before
     choosing a design path
   - gather external evidence with firecrawl or use prototype only for questions that block the
     design
   - compare alternatives before recommending one path
   - do not create implementation plans or code until the design is approved or
     clearly sufficient

6. Before proceeding, state the selected route in one sentence:
   `Route: <skills> -> <design artifact>, because <reason>.`

7. Before ending the design phase, check whether the final design has more than
   three moving parts or is complex/visual enough to benefit from HTML review.
   If yes, present the final design as a Lavish HTML artifact. If no, a prose
   design artifact is sufficient.

## Completion

Done when the design names the chosen structure, the rejected alternatives, the
main tradeoffs, the next phase, and any required Lavish HTML artifact has been
presented.
