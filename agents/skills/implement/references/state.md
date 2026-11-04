# Session paths and shared records

Apply this layout to new sessions. Leave existing session directories and audit
paths intact. Capture timestamps in IST (`Asia/Kolkata`) as `YYYYMMDD-HHmmss`.
Use a filesystem-safe project name, parent issue number or `issue-set`, and an
exclusive directory creation; append a suffix on collision. Record and reuse exact
absolute paths through resumptions. Each issue gets its timestamp when admitted.

```text
/tmp/<project>-<parent-issue-or-issue-set>-<IST-time>/
  STATE.md
  parent/
  issue-<number>-<IST-time>/
    ISSUE.md
    planner-01/TASK.md
    gardener-01/TASK.md
    implementer-01/TASK.md
    review-coordinator-01/TASK.md
    review-standards-01/TASK.md
    review-spec-01/TASK.md
```

Create only used agent directories. Fresh agents get unique role-and-sequence
names; resuming the same agent reuses its directory. A fresh repair agent may use
`repair-01/`; resuming the existing implementer needs no extra directory. TASK.md
is the prompt for that specific agent, not a copy of the shared discussion.
Only STATE.md is a file at session root; only ISSUE.md is shared at issue root.
Plans, reports, scripts, screenshots, logs, snapshots and temporary scratch output
belong in the owning agent's directory. Parent artifacts belong in `parent/`.
Assign necessary repository build/test outputs and contention-sensitive resources
explicitly without broadening source-edit ownership.

## Access and task authorship

Every agent must read root STATE and its issue ISSUE before working or resuming,
then read its own TASK. The planner initializes ISSUE before its first planning
work. Children read root STATE; root alone writes it. Planner alone writes ISSUE.
Workers and coordinator publish reports in their own directories and send references;
planner incorporates their status and decisions into ISSUE.
Repository source/docs remain readable as required by the task; repository edits
remain confined to exact assigned paths/hunks. These are instruction-based rules,
not an operating-system sandbox.

Other session artifacts are private to their assigned agent, with these explicit
exceptions: planner may read coordinator reports referenced by workflow events;
coordinator may read worker reports explicitly supplied for review; root reads
registration artifacts for READY and all completed issue artifacts after SHIP; each dispatcher
creates child directories, writes/revises child TASK files, copies inputs there,
and reads completed child outputs to collect results. Root authors planner TASK;
planner authors gardener, implementer and coordinator TASK; coordinator authors
Standards and Spec TASK. Assigned agents do not rewrite their own assignments.
Preserve TASK revision history in the author's directory and record the current
revision in ISSUE. Copy required artifacts with origin/revision/hash information;
keep supplied inputs read-only. Use real copies, not cross-directory symlinks.
Peers request transfers from their dispatcher rather than browse sibling reports.

## Root STATE.md: issue-set handoff

Root alone writes this file. Use these sections:

1. **Objective and scope:** intended result, selected inventory, exclusions and
   completion criteria.
2. **Issue order:** dependencies, completed issues and next issue.
3. **Decisions and preferences:** accepted choices, authorization, user preferences
   specific to this set, protected work and required gates.
4. **Context map:** important files/interfaces, docs, links and verified research;
   indexed project identifiers and checkout; callback fields `root_thread_id`,
   optional `root_host_id`, actual creation/message authorization provenance and scope,
   registered planner/coordinator app chat IDs and their host IDs.
5. **Progress and remaining limits:** commits, closure, shipped outcomes, blockers
   and unverified gates.

Initialize before the first planner; refresh after each committed and closed
issue, including the last. Supply a useful research head start without copying
predecessor plans or exposing them through links to succeeding planners. Preserve
consequential rationale, unresolved dependencies and critical constraints. Use the
[handoff skill](/Users/harshsharma/.config/agents/skills/handoff/SKILL.md) and
reference durable source artifacts instead of duplicating their bodies.

Root STATE is at most 5,000 tokens; this replaces the old line/character limits.
Measure the full UTF-8 file with tiktoken `o200k_base`, the workflow's explicit
counting convention. Use the shared
[check_tokens.py](/Users/harshsharma/.config/agents/skills/writing-great-skills/scripts/check_tokens.py):

```sh
uv run --with tiktoken python /Users/harshsharma/.config/agents/skills/writing-great-skills/scripts/check_tokens.py <session>/STATE.md --max 5000
```

The entrypoint uses the same convention with `--max 499`, including frontmatter.
If the counter is unavailable, report the gate unavailable rather than claim a
count. Compact redundant material without dropping essential context; surface a
conflict if it cannot fit. Record the count after each root STATE update.

## ISSUE.md: issue-team workspace

The planner alone maintains this structure from reports and events:

1. **Scope and acceptance:** issue/spec provenance, requirements, exclusions,
   source inventory and unresolved scope gaps.
2. **Current plan and phase:** accepted approach, interfaces, file responsibilities,
   gardener decision, dependency order and current TASK revisions.
3. **Agent roster and TASK paths:** app chat IDs and native collaboration identities, roles,
   dispatchers, ownership, input versions, output paths and phase status.
4. **Open discussions:** numbered concern, author, evidence, proposed resolution,
   requested respondent, evidence/report references and status.
5. **Decisions:** conclusion, rationale, decision owner, affected TASK revisions
   and superseded decisions.
6. **Checks and review:** baseline, protected work, check/resource owner, commands,
   actual results, failures/reruns, evidence paths, frozen snapshot and axis verdicts.
7. **Handoff:** current position, next action, responsible agent and remaining limits.

The planner resolves scope/design disputes; the coordinator owns review verdicts.
An implementer or gardener reports missed nuances to the planner before expanding scope.
Decision records must capture consequences for contracts, tests and TASK revisions.
No hard token cap applies. Keep current context concise; the planner may archive
resolved discussion history in its directory, retaining decisions and references
in ISSUE. Supply copies of archives when another agent needs them.

Each role owns its records: root STATE, planner ISSUE, coordinator review package,
and worker reports. Events reference durable records under [messaging](messaging.md).
The coordinator's package is authoritative for its verdict and snapshot even while
planner's summary awaits an update. On resumption, read current records and reconcile
pending events before advancing. A failed planner is a coordination blocker; peers
retain reports and request recovery through authorized app messaging. User-stopped
roles require human authorization to resume.

## TASK.md: assignment

Use the handoff skill to tailor a concise assignment; do not duplicate the plan or
issue discussion. Include the role/objective, root STATE and ISSUE paths, required
references, local input copies, exact repository read/write ownership, exclusions,
accepted contract, checks/resource owner, report path, stop condition and relevant
communication authority. Reference current decisions by ID. A fresh agent must be
able to act without inherited conversation. Models and role-specific obligations
come from [planner contracts](planner.md); root's planner TASK follows parent duties.
Implementer TASKs link their filled [chunk contracts](chunk-contract.md) in
execution order. These planner-authored files live in the implementer's directory
as read-only inputs and follow the same revision/copy rules as TASK assignments.
Only root-to-planner TASK preparation uses deepen. All other TASK authors write
contracts directly. Scope/contract revisions go through the TASK author, with
version changes recorded in ISSUE; bounded repairs can reuse an unchanged TASK.
