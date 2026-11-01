# Conditional evidence

Load only the applicable sections: planner, implementer and Spec reviewer for
external producer fixtures; planner, implementer and Spec reviewer for worker
retry/artifact changes. SHIP requires recorded, rerun evidence.
These rules validate selected behavior; they do not expand scope or justify an
elaborate harness. Apply testing-policy before selecting cases or runtimes.

## External producer fixtures

Apply this gate to serialized payloads representing an external service/process,
including synthetic worker output; the plan records applicability and why.

Run exact emitted payloads through the existing production contract validator or
approved adapter. Include request identity, child order, scope, status and manifest
rules where applicable. Deliberately malformed payloads must show their specified
rejection. Independent expected outcomes remain literal or independently computed,
not derived from production serializers/validators. Plan a bounded adapter if
needed; do not invent a parallel schema.

Record literal payload content hashes, validator/check commands and results;
revalidate after payload edits. Inspect behavioral outcomes separately: confirm
the producer reached the intended boundary. Compiler, producer, fixture and
tooling failures do not establish a production defect. Repair invalid fixtures
or harnesses and rerun before accepting dependent evidence or changing production.
The planner inspects stopped-lane payloads and assigns independent reruns of
validation and behavioral checks within the issue team. Validity and behavior
require separate evidence; later sensitivity checks must retain their actual
chronology.

### Synthetic worker fixture preflight

When the plan uses external synthetic worker protocol fixtures, materialize the
actual submitted `start-job` and emitted `operation-attempt-result` frames. Dynamic
producers use the same construction path, not a rewritten approximation. With
current contract builds available, run:

```sh
pnpm --filter @invello/worker validate:fixture --job /absolute/job.json --frame /absolute/result-frame.json
```

Record both input hashes and the exact result before accepting behavioral evidence.
Contract/tooling failure requires fixture repair and revalidation. This snapshot
check proves payload admissibility, not native lifecycle or handoff acceptance.
See [worker fixture usage](../../../../packages/worker/PROTOCOL.md#development-fixture-preflight).

## Worker retry and artifact handoff

Preserve the accepted domain contract, retry eligibility and cancellation rules;
this checklist does not authorize a retry-policy redesign. Every handoff/report
identifies the exact producer attempt represented by its evidence.

1. **Settle before handoff.** Confirm authoritative producer termination, drain
   preceding protocol events, reconcile outcomes/retry eligibility, then release
   process reservations before emitting generation handoff. A result frame,
   shutdown request or successful kill request alone does not establish this
   barrier. Readiness does not prove Document Manager validated files.
2. **Separate attempt evidence.** Take initial child evidence from initial history
   and follow-up evidence from that child's retry history, carrying outcome,
   status and manifest together. Preserve successful siblings; retry cannot reuse
   initial artifacts or overwrite sibling evidence. Missing retry history becomes
   an explicit failed/incomplete unit.
3. **Carry producer provenance.** Preserve public parent operation, actual worker
   operation, generation, child and selected attempt identities. Use a
   scheduler-issued typed source distinction for ordinary attempts, initial
   onboarding children and follow-ups. Child identity alone cannot distinguish
   initial from retry output. App checks consistency and derives permitted scope;
   Document Manager owns staging and file validation. A worker directory is not
   trusted scope.
4. **Make admissibility explicit.** Queued/running retry evidence is provisional.
   Only complete/partial evidence from a trustworthy settled producer can be
   admissible. Failed, cancelled, incomplete or untrustworthy evidence stays
   non-admissible; cancellation suppresses follow-up per the existing contract.
   Protocol validity alone does not establish admissibility.
5. **Bind durable tickets explicitly.** App resolves each child through
   `(run_id, request_index, row_number, child)` and its supplied `OperationTicket`.
   Do not infer tickets from worker IDs or automatically inherit a parent ticket.
   Missing/conflicting bindings fail explicitly.

For Invello onboarding, `hash` is lowercase SHA256 of the actual worker operation
ID's UTF-8 bytes. Paths are relative to that producer generation's Document
Manager-issued staging area:

| Source | Worker identity | Artifact scope |
| --- | --- | --- |
| Initial child | Initial parent worker ID | `operations/<hash>/attempt-1/onboarding/<child-slot>` |
| Child follow-up | `<parent-operation-id>:r2:<child-slot>` | `operations/<hash>/attempt-2` |
| Ordinary attempt | Actual worker operation ID | `operations/<hash>/attempt-N` |

Initial and follow-up producers retain distinct generation identities/staging
areas. Initial/sibling files cannot satisfy follow-up/other-child scope even
when bytes are identical.

### Public behavioral evidence

Select cases for the changed invariant, not the entire checklist by default.
Use controlled producers, explicit gates/acknowledgements, bounded timeouts and
real files through the public scheduler/App/Document Manager interfaces in a
controlled hermetic/integration runtime. These tests require no live portal
traffic; record separate live/platform gaps. Useful scenarios for applicable changes include:

- Result while producer lives: no reliable handoff yet. Exit with queued results:
  draining/reconciliation preserves final evidence.
- Successful siblings with a provisional transient child failure, followed by
  successful retry, unsuccessful retry or cancellation: check identities,
  attempts, dispositions and sibling preservation. The established onboarding
  fixture has four successful children and one provisional failure.
- Sibling-directory or initial-generation/attempt-1 substitution for retry output:
  reject even identical bytes; accept correct retry scope.
- Explicit durable-ticket mapping and retained source files after validation
  success/failure: assert selected paths/evidence, not just unit counts.

Validate applicable fixtures first. Reports map each changed invariant to public
evidence and record initial/retry worker IDs, generation IDs, child slots, scopes
and ticket bindings. Spec blocks SHIP for violated invariants or missing required
evidence. Independently review a bounded repair before continuing unrelated work;
that repair's acceptance does not establish completion of its larger issue.
