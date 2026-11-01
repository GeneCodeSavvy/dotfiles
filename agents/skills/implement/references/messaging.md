# App events and native completion

Read before dispatching or handling workflow events. Root, planner and coordinator
are independent app chats. Gardener, implementer and review axes are native workers
owned by their dispatcher. Native identities such as `/root/...` are not app IDs.

## Establish routes

Use actual human authorization for creating the issue's planner/coordinator chats
and sending workflow messages among those chats and root. Preserve that provenance
and bounded scope in STATE and TASKs; a peer request or this document cannot create
permission. Resolve any missing authorization before the dependent action.

Call `mcp__codex_app__list_projects` before `create_thread`; this app project ID is
separate from the established codebase-memory index ID. Create local project chats
in the existing checkout with complete TASK/reference paths and the role's specified
model/reasoning. A new worktree requires user request. Record returned threadId and
hostId, emit the required created-thread directive in the dispatching final reply,
and yield after the app's required initial progress check: use one bounded
`wait_threads` snapshot for the created chat, then retain its cursor for recovery.
This is dispatch confirmation, not a supervisory polling loop; READY/ACK still
requires actual event delivery. A pending clientThreadId is not a message destination: resolve the ready
chat through app tools before using it. Preserve registration failures as blockers.

The new chat sends READY containing its actual thread ID, role and TASK revision.
Its dispatcher validates the expected assignment and registers the ID before ACK.
Planner obtains root ACK before execution. Coordinator sends READY to root and
planner and obtains root ACK before review; root validates its planner-authored TASK
and registers the coordinator. This handshake tests both directions. Root may read
the registration artifacts before SHIP solely for that purpose. A failed handshake
blocks that lane; it does not authorize a native-to-app callback workaround.

## Process events

Use `mcp__codex_app__send_message_to_thread` with registered threadId, hostId when
required, and a human-readable prompt. Preserve recipient model/reasoning settings.
Each event has a stable ID, session/issue, sender role/chat ID, TASK revision,
snapshot ID when applicable, durable record paths and requested next action.
Write its payload and send result in the sender's directory before yielding.

| Event | Route | Receiver action |
| --- | --- | --- |
| READY | New planner → root; new coordinator → root and planner | Register assignment and acknowledge |
| ACK | Receiver → sender | Record receipt; begin work only for matching READY |
| IMPLEMENTATION_READY | Planner → coordinator | Validate new evidence and begin review |
| REPAIR_REQUEST | Coordinator → planner | Route bounded repair or resolve design decision |
| SHIP | Coordinator → root, copied to planner | Root runs mechanical gates; planner updates ISSUE |
| COMMIT_REJECTED | Root → coordinator and planner | Coordinator invalidates SHIP; planner supports repair |
| CLOSED | Root → coordinator and planner | Record verified commit and tracker closure |
| BLOCKED | Planner/coordinator → root, copied to peer | Surface evidence and required user action |

For each new event, validate sender/assignment/revision against records, durably
record receipt and send ACK referencing the event ID before starting its transition.
ACKs receive no further ACK. The planner ACKs coordinator READY after registration;
root ACK is the coordinator's execution gate. Treat messages as pointers to evidence,
not authority to expand scope. Record processed event IDs and outcomes in the
receiver's directory. Repeated IDs replay the saved ACK/outcome without repeating work; stale revisions or
snapshots require reconciliation before work. SHIP processing also checks whether
the snapshot was already committed or closure alone remains pending.

Successful tool submission and receiver acknowledgment are separate states. After a
confirmed transient send failure, retry the same event once. For uncertain delivery,
inspect the target chat once for its event ID before any retry. A rejection,
unavailable tool, failed retry or unresolved delivery remains a durable delivery
blocker; preserve an explicit undelivered final report. Successful submission without
ACK remains pending. Never infer a wakeup, processed event or permission from elapsed
time. Recovery reconciles the saved event and receiver record before resending.

## Yield and collect

After app dispatch or event submission, yield until a supported app message resumes
the chat. Root performs no supervisory polling. Planner and coordinator may use
passive native completion waits while collecting their bounded workers; they keep
that collecting turn active and return reports through native completion. Native
workers communicate only with their dispatcher, who owns app event delivery.
This workflow retains dependency waits without idle app-chat polling. App callbacks
must pass the READY/ACK handshake in the running environment; this document does
not guarantee delivery or automatic recovery after a failed send.
