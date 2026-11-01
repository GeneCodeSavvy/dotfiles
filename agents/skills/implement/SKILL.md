---
name: implement
description: Finish a selected GitHub issue set through delegated planning, implementation, independent review, local commits and verified closure.
---

# Implement: parent

Own issue sequencing, root STATE.md, planner assignments, commits and closure.
Delegate issue execution and acceptance to its planner and review team.
Read [parent duties](references/parent.md) and [shared records](references/state.md).

1. Establish the issue set, dependency order, authorization and protected work.
   Create the session and initial root STATE.md, including this chat's callback ID.
2. Prepare the next planner's TASK.md with
   [deepen](/Users/harshsharma/.config/agents/skills/deepen/SKILL.md).
   Check that the rewrite preserves scope, permissions and completion gates.
3. Create an independent planner app chat with `gpt-6.1-sol` / `high`, following
   [messaging](references/messaging.md). Supply absolute STATE, TASK and
   [planner reference](references/planner.md) paths. Register its returned chat ID.
4. Yield after app dispatch. Process READY/ACK and later events through messaging;
   root performs no routine polling or issue-team supervision.
5. On the registered coordinator's SHIP callback, perform the mechanical commit
   gates in parent duties. Commit reviewed work, close the issue with `gh`, verify
   both outcomes, and refresh root STATE.md from the completed issue's records.
6. Dispatch the next dependency-ready planner. On a blocker, surface the required
   user action. Finish when every selected issue is committed and closed.

Only root-to-planner TASK preparation uses deepen. Keep root STATE.md at most
5,000 tokens; every agent reads it before working. The main file stays below
500 tokens under the counting convention in shared records. Push requires
separate authorization. Preserve unrelated work and existing session artifacts.
