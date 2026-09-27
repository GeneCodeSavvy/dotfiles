---
name: lld-design
description: Design code-level ownership, contracts, interactions, and state for an explicitly approved HLD in an existing repository. Use for low-level design requests, not for initial architecture or implementation.
---

# Low-Level Design

Produce a reviewable design grounded in the current code. Do not implement it unless the user's task also authorizes implementation.

## Entry gate

1. At the start, search GitHub for an issue covering the problem. Reuse a matching issue; create one if none exists after the HLD gate passes.
2. Require the user's explicit approval of the particular HLD in the current chat. An HLD's existence, status, issue comment, or inferred acceptance is insufficient. If that approval is absent, explicitly refuse to start the LLD and state what is needed.
3. Treat the approved HLD as the architectural boundary. Summarize its applicable constraints. If a local design conflicts with it, show the concrete conflict and options, then ask the user before continuing.

## Research for alternatives

Use web search when it helps brainstorm interface or implementation choices. Medium, Reddit, Stack Overflow, and other practitioner discussions can reveal options and failure cases, but are leads rather than authority. Verify concrete technical claims against primary sources and project-specific claims against current code. Cite useful sources and keep outside patterns subordinate to the approved HLD and the repository's actual contracts.

## Choose the design

With codebase-memory-mcp cli inspect current code and call sites before proposing changes. Establish which module owns each responsibility. Where ownership is genuinely contested, compare data authority, workflow ownership, dependency direction, and change impact. If the existing owner conflicts with a cleaner boundary, show that choice and ask the user before settling it.

Design interfaces and contracts next. Evaluate caller needs, domain language, and existing API conventions. When those point to different contracts, inspect concrete call sites, present the conflict and a recommendation, and ask the user. Ask one question at a time, with a recommended answer. Do not ask about choices the code or approved HLD already settles.

Compare only genuine design alternatives. Prefer the option with lower perceived complexity, but show the user the tradeoff across the maintainer's mental model and special cases, module and layer count, and code volume. Recommend one and ask the user when these measures disagree or the choice changes ownership or contracts.

## Express the design

1. Draw a Mermaid sequence diagram for each materially distinct user or system flow. Use actual code module and API names; mark proposed names clearly. Show alternate paths with `alt` and flow-ending failures with `break`.
2. After the sequences, define concrete changed contract types and stored state, their owner, and their invariants. Ask the user whether a state machine diagram is needed, with a recommendation based on lifecycle states, guarded transitions, retries, or recovery. Add one only if requested.
3. Cover every expected failure in scope and one catchall unknown failure. Specify the error contract, resulting state, and the owner of retry, compensation, or reporting. Show each failure in the relevant sequence with `alt` or `break`.
4. Summarize applicable HLD constraints. Do not add pseudocode or a test plan to the LLD.

## Publish and finish

Write the LLD to a temporary Markdown file, then post its contents as a comment on the matching or newly created GitHub issue. Present the design and issue link in chat. After feedback, post each revision as a new issue comment so the discussion preserves its history.

The LLD is complete when all open design questions have answers and the posted design reflects them. A separate LLD approval is not required.
