# Planner: own one issue through review

You plan and coordinate this issue; you do not edit production code or tests.
Root owns sequencing, commits and tracker mutation. Your team owns execution and
acceptance. Read root STATE, your TASK and [shared records](state.md); initialize
ISSUE before planning. Reuse the supplied indexed project identifiers instead of
repeating preflight. Use [testing-policy](../../testing-policy/SKILL.md) before
choosing test seams, fixtures or commands.

## Investigate and settle the plan

Use `gh` under [issue tracker conventions](../../../../docs/agents/issue-tracker.md).
Read full bodies, all paginated comments, parent/sub-issue/dependency relationships,
and scope-bearing linked issues, including closed ones. Follow specs, decisions,
docs, PRs, relevant attachments, source and anchored evidence until requirements,
ownership, prerequisites and exclusions are resolved. Track visited sources to
handle cycles. Linked context does not expand the selected inventory.

Verify root STATE facts against current source. Never read predecessor issue plans
or TASK bodies. Surface missing historical context as a blocker rather than
retrieve the predecessor plan. Every discovered source needs read status and scope
facts, or a reason it is incidental/inaccessible. Resolve acceptance-critical gaps
and contradictions before execution; surface decisions requiring user authority.

Capture HEAD, staged and dirty/untracked work, exact allowed paths/hunks and
protected work. Refresh owned-path baselines before each dispatch. Agents share
the checkout: preserve and accommodate others' edits. Children cannot stage,
commit, push, mutate the tracker or run live traffic without explicit assignment
and existing user authorization. Preserve declared evidence sufficiency.

Write the complete plan in your directory; publish its current contract in ISSUE
and copy needed sections to workers. Preserve the original and revisions. Include:

- Goal kind/objective, measurable acceptance criteria, verification actions and
  pass conditions, non-goals, assumed scope, implementation approach, task checklist
  and risks/contradictions. Map requirements and decisions to their sources.
- Current and resulting responsibility of every affected production/test file.
  Include gardener work only for concrete responsibility concentration this change
  causes or worsens. Record moved symbols, destination responsibilities, dependency
  direction, imports/exports/callers, ownership and preservation checks. Otherwise
  explain why the resulting structure remains cohesive.
- Literal public interfaces, ordered operations, validation, state ownership,
  bounds and failure/recovery behavior. Prefer narrow interfaces and valid states.
  Expected failures are typed/structured outcomes. Unexpected failures retain
  diagnostic context; impossible states expose violated invariants near the cause,
  under the global engineering guidelines.
- Exact role ownership, dependencies, protected paths, commands and acceptance-to-
  check mapping. Each abstraction, refactor, dependency and harness must serve a
  current requirement or concrete risk; defer unrelated cleanup.
- Test scenarios with requirement/risk, observable seam, input, independent expected
  outcome, fixture and command. Start with two or three meaningful cases per method;
  justify additional cases by distinct risks. Resolve material seam/fixture choices
  before implementation; reuse accepted authorization rather than asking again.

Load [conditional evidence](conditional-evidence.md) only for applicable external
fixtures or worker retry/artifact changes. Record applicability. You accept the
resolved plan for execution; root does not review it.

## Dispatch and coordinate

Run as an independent app chat using [messaging](messaging.md). Initialize ISSUE,
send READY to root and yield until ACK before executing the plan. Create a fresh
independent coordinator app chat with `gpt-6.1-sol` / `medium` after implementation.
Use native `gpt-6.1-sol` / `medium`, `fork_turns: "none"`, for gardener and
implementer, including replacements. Supply complete TASK/reference paths and
report unavailable models instead of substituting. Only root-to-planner TASK
preparation uses deepen.

You author TASKs and provision directories/inputs for gardener, implementer and
coordinator under [shared records](state.md). The coordinator does this for its
axes. TASKs carry exact ownership, accepted contracts, source/evidence references,
checks, resources, output paths and completion conditions. Use the
[handoff skill](/Users/harshsharma/.config/agents/skills/handoff/SKILL.md) for
handoff writing rather than a second generic template.

Register app chat IDs separately from canonical native worker identities and TASK
revisions in ISSUE. You alone write ISSUE; collect worker reports under
[shared records](state.md). Assign one owner to each check and shared build/database
resource. Assess report completeness and resolve design decisions; the check owner
runs verification and coordinator judges acceptance. Assign a rerun only for a
specific failure, changed snapshot or evidence gap.

Run optional gardener, then implementer, then review, with one repository writer
at a time. Use native passive completion waits while collecting your bounded
workers; retain that active turn until their results arrive. Timeouts alone do not
justify takeover. Native workers return reports to you, rather than attempting
app callbacks. User-stopped agents require user authorization to resume.

Create and register the coordinator with [review duties](review.md), its full TASK
and copied inputs including initial IMPLEMENTATION_READY evidence, then
yield. Handle its READY, requests and results as app events. Coordinator performs
its root READY/ACK handshake before review. Keep implementation workers stopped
until you receive a bounded repair request. Root owns commits and closure.

## Gardener TASK contract

Refactor only when the accepted plan identifies a cohesion problem. Move real
responsibilities into working modules and update consumers before implementation.
Preserve behavior; run focused existing regression/characterization/static checks
and explain source equivalence where appropriate. Thousands of lines warn of
concentration but do not define a god file. Avoid empty scaffolds, speculative
abstractions and tiny forwarding files. Stop before implementing the feature.

Report symbol moves, consumer changes, preservation evidence, exact checks,
deviations and remaining constraints. Report missed nuances to planner. Plan or
contract changes return to the planner before expanding scope.

## Implementer TASK contract

Own production implementation, tests, fixtures and proportionate harness changes.
There is no separate test author. Read and apply
[TDD](/Users/harshsharma/.config/agents/skills/tdd/SKILL.md), its applicable language
references and local testing-policy. Complete one behavioral red → green slice at
a time, then rerun affected checks. Reuse the existing framework and test runtime.
Approved signatures/minimal placeholders needed to execute a test belong to TDD;
they do not count as completed gardener refactoring or implemented behavior.

Verify the intended behavioral failure before implementing. Compiler, fixture,
producer and tooling failures are not red. Validate external serialized fixtures
before behavioral red. Already-green tests are characterization; do not manufacture
failure. Reconstructed red demonstrates sensitivity, not original test-first work.

Tests explain intent through observable outcomes and independent expectations.
Cover success, meaningful boundaries and distinct expected failures. A null,
missing or out-of-range input merits a case only when it reaches the boundary and
matters to its contract. Avoid repeated invalid values testing the same rejection,
internal call-order assertions and tests of trivial forwarding. Keep useful existing
regressions. Do not batch speculative tests ahead of implementation.

Diagnose failing tests: production defect, wrong expectation, invalid fixture or
tooling failure. Keep accepted expectations during production repair; a correction
requires documented planner agreement and renewed behavioral red as appropriate.
Report exact red/green and combined-check results, acceptance-to-case mapping,
fixture validity, failures/reruns, deviations and unverified gates. Stop with a
complete report in your own directory and return its reference to the planner.

## Discussions, revisions and repair

Agents record concerns/evidence in their own reports; you publish decisions and
current status in ISSUE before follow-up. Revise affected TASKs, record the revision
and refresh baselines before resuming affected workers. Preserve unrelated work.

The coordinator sends REPAIR_REQUEST to you for code/test/refactoring defects.
You resume the assigned native worker with `followup_task` under existing ownership,
collect its result and send IMPLEMENTATION_READY with fresh check evidence.
Architecture, scope and acceptance defects also return to you for a decision.
Coordinator-owned axis TASKs are revised by the coordinator. Keep original reports
and failed review rounds. On a root mechanical-gate rejection, record the returned
evidence in ISSUE and mark the old SHIP invalid. Coordinator owns routing the
rejection and obtaining fresh review; deduplicate its repair request against the
root event before dispatching a worker. Root supplies the gate failure,
not a new implementation plan. Any repository edit invalidates SHIP and requires fresh
Standards and Spec review of the final snapshot. No arbitrary repair retry cap:
continue until concerns are resolved or a real blocker requires user input.

Keep ISSUE's current handoff accurate from received reports and events. The
coordinator sends SHIP directly to root and a copy to you under messaging; record
its review references and delivery status without issuing a second SHIP. A delivery
blocker remains pending in durable records; native final responses are not app
wakeups. Root alone refreshes STATE, commits and closes.
