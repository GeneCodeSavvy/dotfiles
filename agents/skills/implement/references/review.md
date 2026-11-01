# Review coordinator and axes

You did not plan or implement this issue. Read root STATE, ISSUE, your TASK,
[shared-record rules](state.md) and
[code-review](/Users/harshsharma/.config/agents/skills/code-review/SKILL.md).
Review repository content read-only. Write review artifacts in your own directory
and send status/report references to the planner, who alone writes ISSUE.
You own review acceptance, not commits.

Run as a fresh independent app chat under [messaging](messaging.md). Send READY to
root and planner; obtain root ACK before dispatching review axes. This exercises
the eventual SHIP callback route. Native review axes return to you.

## Freeze one state

After workers stop and combined checks pass, freeze the exact issue-owned tracked
and untracked paths, modes, content SHA256 hashes and deletions. Record HEAD and
the pre-implementation baseline, protected staged/dirty work, approved patch/hunks,
check results and TASK revisions. Keep the manifest and full review inputs locally.
Both axes must review that identical snapshot. Reject stale evidence after edits.

For uncommitted work, adapt code-review to `git diff <baseline> -- <owned paths>`
and read every owned untracked file in full. Use the supplied baseline/spec; do not
rediscover them or create temporary commits. Committed comparisons retain that
skill's merge-base semantics. Compare with the protected baseline so preexisting
unrelated work is not included in the approved change. Missing specification is a
blocker here; do not skip the Spec axis.

## Independent axes

Author separate TASKs and copy inputs into fresh Standards and Spec directories.
Use native `gpt-6.1-sol` / `medium`, `fork_turns: "none"`, for both; no deepen.
Record identities and revisions in your review package and send them to planner.
Run in parallel only when capacity permits; otherwise run sequentially with independent context. Share expensive
check results through copied evidence; assign one owner to avoid contention.

Standards checks applicable repository/global rules, testing-policy, resulting
file responsibilities and code-review's full smell baseline. Copy that baseline
into its TASK as code-review requires; smells remain judgment calls and repository
rules take precedence. Read the owning domain-review skill when applicable.

Spec checks every accepted behavior and exclusion, public interface/consumer
updates, gardener preservation, test usefulness, actual TDD phase evidence,
repairs, check outcomes and applicable conditional/domain invariants. For capability
boundaries, enumerate exposed mutation routes and parameter restrictions; check
rejection/rollback through public durable-state reads. Use testing-policy to assess
whether evidence is sufficient rather than adding hypothetical coverage.

Each axis returns a separate report for the frozen state. Preserve first failures,
isolated reruns and final outcomes. Review is not permission to edit repository
files or mutate the tracker. Give blockers a file/symbol, observed defect, required
correction and acceptance consequence. Keep optional preferences, unrelated
failures and concrete correctness/security/data-loss blockers distinct.

## Repair and final verdict

Keep both axis reports separate. Use passive native completion waits to collect
your axes; keep the collecting turn active. SHIP requires both axes and mandatory
evidence clear of blockers. Save FIX-FIRST evidence, send REPAIR_REQUEST to planner
and yield. Planner owns native implementation workers and routes repairs or design
changes. Resume on IMPLEMENTATION_READY, with stopped writers and fresh evidence.

After repair, rerun affected and combined checks, freeze the new state, and obtain
two fresh independent axis reviews. This also applies after gardener, planner-
requested or hook-induced source edits. Never issue SHIP for an earlier snapshot.
Continue repairs without an arbitrary retry cap; a missing decision, unavailable
required capability or evidence gap becomes a blocker for user action.

Before final SHIP, verify phase reports, TDD evidence, acceptance/check mapping,
protected-work preservation and all final hashes. Deliver a report beginning SHIP
or FIX-FIRST, containing the two verdicts, review/check evidence, corrections,
remaining limits and exact reviewed snapshot. Send planner the review/handoff
references. Confirm repository writers have stopped before notification; later edits
void SHIP.

## SHIP callback

Send SHIP directly to root and copy planner under [messaging](messaging.md), using
registered app chat identities and actual user authorization. Include:

- Session/issue, coordinator chat ID, TASK revision and event identity.
- Absolute ISSUE, final package, both axis reports and frozen manifest paths.
- Reviewed HEAD/baseline, approved paths/hunks, modes, hashes and deletions,
  including owned untracked files; protected-work baseline.
- Required-check evidence, both verdicts, residual limits and readiness for root's
  mechanical gates for this exact snapshot.

Persist delivery and acknowledgment separately. Root ACK means receipt, not commit
or closure. On COMMIT_REJECTED, invalidate SHIP, retain the rejection and request
repair through planner. On CLOSED, record verified commit and closure references.
A BLOCKED event identifies the unresolved concern, evidence and required user action.
