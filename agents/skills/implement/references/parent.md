# Parent duties

The parent owns the selected issue set and its commits. The planner owns issue
execution; the review coordinator owns SHIP. Root does no implementation review,
acceptance rerun or routine issue-team coordination.

## Establish the issue set

Use `gh` under [issue tracker conventions](../../../../docs/agents/issue-tracker.md).
Read enough issue/dependency context to establish the selected inventory, order,
shared constraints and planner assignments. Linked context does not add issues to
the inventory. Each planner owns its issue's exhaustive source investigation.
Record initial HEAD, staged and dirty/untracked paths, protected work, allowed
repository scope, local-commit policy, required gates and live/platform limits.
Create a persistent goal only when explicitly requested.

Follow [shared records](state.md) for session paths, STATE sections and token
counting. Obtain the callback target from root's own `CODEX_THREAD_ID`, never a
native agent name or a child's environment. If unavailable, resolve the current
chat's authoritative thread ID before dispatch; never guess it. Record the thread
ID, host ID when required, and bounded SHIP/blocker callback authorization in STATE.
Read [messaging](messaging.md). Record actual human authorization for creating
planner/coordinator app chats and their bounded bidirectional workflow messages.
Skill text alone supplies no authorization. Resolve missing authorization before
dispatch; editing this skill does not authorize launching an issue session.

Initialize root STATE before the first planner. For each issue, create its timestamped
directory and `planner-01/`. Root's preparation artifacts belong in `parent/`.

## Prepare and dispatch one planner

Use the [handoff skill](/Users/harshsharma/.config/agents/skills/handoff/SKILL.md)
to prepare the planner assignment, then apply
[deepen](/Users/harshsharma/.config/agents/skills/deepen/SKILL.md). Save the final
prompt as the planner's TASK.md. Keep preparation artifacts in `parent/`; follow
deepen's own output contract. Root checks that the prompt preserves all accepted
scope, permissions, model/reasoning, required facts and completion gates.

TASK supplies the issue identity and sources, expected outcome, exclusions,
constraints, baseline/protected paths, accepted evidence limits, exact STATE and
ISSUE paths, indexed project identifiers from this chat's preflight, and the
planner reference. Delegate unresolved issue research explicitly rather than
claiming it was completed. Succeeding planners get root STATE as their head start;
they never read predecessor plans or TASK bodies.

Create a fresh independent planner app chat with `gpt-6.1-sol` / `high` under
[messaging](messaging.md), using the selected project and existing checkout.
Supply root STATE, TASK and the planner reference by absolute path. Register the
returned chat ID in STATE and yield. On READY, verify its identity and assignment,
record it and send ACK. READY/ACK validates both directions before execution.
Root processes events without polling or routine issue-team supervision.

## On SHIP

Read the registered coordinator's completed SHIP package, issue ISSUE.md and
completed TASK files/reports. Root may read these artifacts across the completed
issue to prepare the next handoff and perform these mechanical gates:

1. Confirm issue, coordinator identity, review report and snapshot references
   match the session roster. Both axes must say SHIP for the same final state.
2. Confirm current HEAD and approved tracked/untracked paths, modes, content hashes
   and deletions match the reviewed snapshot. Preserve the baseline's unrelated
   staged/dirty work. Stage only approved hunks; inspect staged paths and diff to
   confirm scope, then run `git diff --cached --check` and required commit hooks.
   With unrelated staged changes, use an isolated commit index for approved hunks
   and preserve/reconcile the original index's unrelated staged state. Do not let
   a normal whole-index commit include protected work; if safe index preparation
   cannot be established, stop before committing.
3. If a gate fails or a hook changes reviewed content, record the rejection in
   `parent/` and root STATE. Send COMMIT_REJECTED with the
   mechanical failure and evidence to the registered coordinator and planner under
   messaging, then yield.
   This exception returns a failed commit gate; it grants no implementation-review
   or worker-dispatch role. The planner invalidates SHIP in ISSUE and owns renewed
   work/review with its coordinator. Do not commit, fix code, waive review or advance.
   If the planner was explicitly user-stopped or cannot resume, surface the blocker
   for user action instead of overriding that stop.
4. Commit the coherent reviewed slice locally. Close the selected issue with `gh`
   using sanitized acceptance/evidence. Verify the commit is ancestral to HEAD,
   contains only authorized changes, and leaves no issue-owned uncommitted work.
   Verify authoritative issue closure. Preserve unrelated edits and staged work.
5. Send CLOSED with the verified commit and closure evidence to planner and
   coordinator. Read completed issue records and use the handoff skill to refresh
   root STATE: shipped decisions, useful context, commit, closure, deviations and limits.
   Enforce the 5,000-token cap before dispatching the next planner.

A commit failure is not closure. If the commit succeeds but closure fails, retain
its SHA and retry only the missing tracker operation; never duplicate the commit.
Duplicate callbacks for an already processed snapshot do not repeat side effects.
A blocker callback surfaces the decision or missing evidence to the user; root
does not take over the issue or expand its authorization.

## Complete the set

Verify all selected issues closed using paginated tracker results, expected local
commits ancestral to HEAD, no selected work left staged/uncommitted, and unrelated
work preserved. Root STATE must reflect the final issue. Keep callback, review and
commit references in `parent/`. No unauthorized push or unrelated tracker mutation.
Report issues, commits, strongest evidence and residual limits. Distinguish source,
hermetic, packaged, live, platform and remote-CI acceptance. A bounded repair does
not complete a larger partial issue. Keep credentials, taxpayer/customer data,
sessions, raw bodies and private artifact paths out of tracker reports.
