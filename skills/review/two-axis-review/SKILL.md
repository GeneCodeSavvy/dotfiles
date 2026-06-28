---
name: two-axis-review
description: Use from the canonical review skill when reviewing changes since a fixed point against standards and spec.
---

# Two-Axis Review

Review the diff between `HEAD` and a fixed point along two separate axes:

- **Standards**: does the code follow documented repo standards?
- **Spec**: does the code implement the originating issue, PRD, or spec?

Keep the axes separate so one does not mask the other.

## Process

1. Pin the fixed point supplied by the user. If they did not supply one, ask.
2. Capture `git diff <fixed-point>...HEAD` and
   `git log <fixed-point>..HEAD --oneline`.
3. Confirm the fixed point resolves and the diff is non-empty.
4. Identify the spec source from commit messages, a user-provided path, a
   matching spec file, or the issue tracker.
5. Identify standards sources such as `CODING_STANDARDS.md`, `CONTRIBUTING.md`,
   `AGENTS.md`, or relevant docs under `docs/`.
6. Run Standards and Spec reviews independently, preferably in parallel when
   subagents are available.
7. Present findings under `## Standards` and `## Spec`. Do not merge or rerank
   the axes.

## Standards Brief

Report every place the diff violates a documented standard. Cite the standard
file and rule. Distinguish hard violations from judgment calls. Skip anything
tooling enforces.

## Spec Brief

Report missing or partial requirements, unrequested behavior, and requirements
that look implemented incorrectly. Quote or cite the spec line for each finding.

## Completion

Done when both axes have reported findings or explicitly reported no findings,
and the final summary names the worst issue within each axis.
