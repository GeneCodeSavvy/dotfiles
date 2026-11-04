# Implementation chunk contract template

Planner: copy the template below to `CHUNK-<id>.md` in the assigned implementer's
directory and fill it before dispatch. Keep the numbered sections and field labels;
replace placeholders with concrete details, or `N/A — <reason>`. Repeat symbol,
step and verification entries as needed. Resolve design decisions before dispatch.

Use one contract per bounded implementation chunk, including a single-chunk issue.
Chunks follow dependency order with one repository writer at a time; chunking does
not require a fresh agent. TASK links the assigned contracts in execution order.
Record contract paths/revisions in ISSUE alongside TASK revisions. The planner owns
contract revisions, preserves superseded versions in its directory and refreshes
affected TASK references before work resumes. Workers treat contracts as read-only.

Include every major introduced, changed, moved or removed symbol: public APIs,
domain types, state owners, orchestration functions and behavior-bearing helpers.
Local variables and trivial helpers remain implementer choices. Shared symbols
have one current contract owner; dependent chunks name the supplying contract and
revision. Supply required inputs as worker-local copies under shared-record rules.

Before dispatch, verify every field is filled, every major assigned symbol has a
contract, each acceptance criterion maps to verification, prerequisites are met,
and all referenced inputs are readable. An unresolved consequential choice or
placeholder keeps the chunk in planning. This is a planning check, not execution
evidence; the worker records actual results in its completion report.

---

# Chunk <id>: <name>

- Contract revision: <revision>
- Issue and planner decision IDs: <references>
- Assigned implementer: <identity or assigned role before registration>
- TASK, root STATE and ISSUE paths: <absolute paths>

## 1. Outcome

- Required behavior: <observable result>
- Acceptance criteria: <AC IDs and measurable conditions>
- Exclusions: <scope boundaries>

## 2. Starting state

- Baseline: <HEAD and owned-path dirty/untracked baselines or exact snapshot reference>
- Prerequisites: <dependency chunks/revisions, required resulting state and evidence>
- Required inputs: <worker-local paths, source origins/revisions/hashes and relevant sections>
- Source anchors: <files and symbols verified during planning>
- Existing patterns: <specific examples to follow and why they apply>
- Dependency contracts: <supplied interfaces, versions and assumptions verified>

## 3. Ownership

- Allowed edits: <exact files/hunks, including tests, fixtures and generated outputs>
- Protected work: <paths/hunks and preservation requirements>
- File responsibilities: <current → resulting responsibility for each affected file>
- Check/resource ownership: <who runs which checks; shared build/database resources>
- Execution authority: <allowed operations and applicable authorization boundaries>

## 4. Symbol contracts

### <S-ID>: <symbol name>

- Action and location: <introduce/change/move/remove; exact file/module and destination>
- Owner and responsibility: <assigned implementer; responsibility of the symbol>
- Signature or type shape: <literal declaration; before/after when changing>
- Inputs, outputs and errors: <accepted values, return/outcome types and error semantics>
- Behavior: <ordered operations, branches, validation, bounds and recovery>
- State: <owned/mutated state, lifecycle and relevant invariants>
- Integration: <callers, dependencies, imports/exports and required consumer updates>
- Preservation: <existing behavior that must remain; compatibility constraints>
- Verification outcomes: <AC/check IDs and observable results>

<Repeat for every major assigned symbol. For removal, identify replacement or
caller migration; for a move, identify source/destination and preservation checks.>

## 5. Execution sequence

### Step <number>: <action>

- Target: <file and S-IDs>
- Procedure: <concrete edits, integration order and important branches;
  pseudocode where prose leaves consequential ambiguity>
- Behavioral cycle: <verification ID; write one test, verify intended behavioral
  red, implement its behavior, verify green; or justified characterization/static check>
- Done when: <observable condition for advancing to the next step>

<Repeat in dependency order. Each behavioral cycle completes before the next test
is written. Use the invoking workflow's TDD and project testing-policy requirements.>

## 6. Verification

### <V-ID>: <criterion or distinct risk>

- Acceptance mapping: <AC IDs and S-IDs>
- Observable seam and fixture: <boundary, fixture path/provenance and validity checks>
- Input/starting state: <concrete values and setup>
- Independent expected outcome: <literal result or independently worked example and source>
- Command and working directory: <exact command, cwd and required setup>
- Pass condition: <expected behavior and exit status; intended red where applicable>

<Repeat for acceptance criteria and distinct risks.>

- Combined integration checks: <commands, cwd, check owner and pass conditions>
- Evidence limits: <what these checks establish and gates outside this assignment>

## 7. Stop and escalation conditions

- Blocking conditions: <missing prerequisites, conflicting source behavior,
  ownership conflicts or unresolved contract choices; include chunk-specific cases>
- Return to planner: <report path/communication route, evidence to include and decision needed>

Pause affected work and return consequential design or contract changes to the
planner. Make routine coding choices within the settled contracts and ownership.

## 8. Completion report

- Report path: <absolute worker-owned output path>
- Required contents: changed files/symbols; AC-to-check results; exact red/green
  and combined commands, exit statuses and evidence paths; deviations and planner
  decisions; remaining limits and blockers; resulting state for dependent chunks.
- Completion condition: <all assigned acceptance/check gates satisfied with evidence,
  or a blocker report identifying incomplete gates; identify which outcome occurred>
