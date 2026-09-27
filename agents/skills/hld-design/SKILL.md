---
name: hld-design
description: Shape a high-level system design through a phased, one-question-at-a-time interview. Use when the user wants an HLD or production architecture developed from rough ideas and constraints, not for a narrow architecture answer or code-level LLD.
---

# High-Level Design

Help the user turn raw thoughts into explicit architecture decisions. Begin by inviting an unstructured dump of goals, constraints, worries, examples, and ideas. If the user has already provided one, use it; do not make them fill out a form or repeat themselves.

Reflect the dump back as confirmed requirements, tentative assumptions, and open decisions. Preserve the user's wording where it carries domain meaning. Do not silently convert an idea into a requirement. Ask about the highest-impact uncertainty first.

## Interview method

Work through the seven phases below in order, revisiting an earlier decision when a later answer changes it. For each phase:

1. State what is already known and the decision the phase needs to settle.
2. Ask **one question at a time** and wait for the answer. Give a recommended answer with a reason tied to the user's constraints, current system, or evidence. Offer concrete alternatives when a real tradeoff exists.
3. Follow the user's answer down its dependencies before moving on. Ask only questions that affect the design; investigate facts that code, documentation, or research can answer instead of asking the user.
4. Record the decision, its rationale, and any remaining uncertainty in a running design summary. Distinguish the user's choices from the agent's recommendations.

Do not present a finished architecture while key decisions remain open. Push back when a choice conflicts with a stated constraint, and explain the tradeoff plainly. Depth follows the problem; the phase prompts are topics to resolve, not a checklist to recite.

## Research for brainstorming

Use web search when it helps discover architecture options, operational experiences, or failure modes. Medium, Reddit, Stack Overflow, and other practitioner forums can suggest alternatives and questions to test. Treat those discussions as leads, not proof or design authority. Check concrete technical claims against primary sources such as official documentation, standards, and research papers; check project-specific claims against the current code and docs. Share useful links and say which conclusions are evidence-backed versus your inference. Do not import a fashionable pattern without showing why the user's constraints need it.

## Phases

### 1. Requirements and constraints

Start from the raw dump. Resolve the system's purpose, actors, essential behaviors, success criteria, boundaries, and non-functional constraints. Separate hard constraints from preferences and unknowns. State what is out of scope. Move on when the design problem is clear enough to compare architectures.

### 2. Scale and capacity

Estimate only quantities that can change a decision: request and write rates, peak behavior, data size and growth, latency, availability, consistency, or durability as relevant. Ask for missing numbers one at a time and recommend a defensible assumption when exact figures are unavailable. Show the calculation and sensitivity; do not invent precise targets or apply stock multipliers as facts.

### 3. Components and boundaries

Compare credible component shapes and ownership boundaries against the requirements and scale. Resolve the main request, event, and data paths, plus dependency direction. Recommend the least complex architecture that satisfies the known constraints. Draw a high-level diagram after the boundaries are settled; do not start from a default stack of infrastructure boxes.

### 4. Data model and ownership

Identify core domain concepts, authoritative stores, important relationships, access patterns, and consistency boundaries. Settle storage and indexing choices only where the HLD needs them. Leave field-level schemas and implementation types for LLD unless they decide an architectural tradeoff.

### 5. External contracts

Resolve the boundaries between clients, services, and external systems: operations or events, sync versus async behavior, authorization, idempotency, and versioning where relevant. Specify observable behavior and ownership at HLD depth. Do not default to REST or a particular protocol without considering existing contracts and the use case.

### 6. Hard tradeoffs

Pick the bottlenecks or contested decisions that matter in this design. Compare realistic alternatives with their costs, failure behavior, and effect on future change. Research unfamiliar options before recommending one. Skip generic deep dives that do not change a decision.

### 7. Failure modes and synthesis

Walk the critical paths through dependency failure, partial completion, overload, stale data, and recovery as applicable. Identify detection, containment, and recovery at the component level. Reconcile the design with all hard constraints and summarize the chosen tradeoffs. Surface unresolved decisions instead of hiding them.

## Result

Present an HLD that reflects the resolved conversation: requirements and constraints, assumptions and scale estimates, architecture diagram and component ownership, data and external boundaries, key tradeoffs, failure and recovery behavior, and any open questions. Keep rationale close to the decision it supports. Ask the user to review the final HLD; only their explicit approval in the current chat qualifies it as approved for a subsequent LLD workflow.
