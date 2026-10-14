# Human Preferences and Engineering Guidelines

## Bias toward caution over speed. For trivial tasks, use judgment.

### Engineering Priorities

When tradeoffs conflict, use this order:

1. Correctness and protection from data loss or incorrect external writes.
2. Bounded resource use and predictable failure behavior.
3. Simplicity and ease of change.
4. Delivery speed for the current requirement.
5. Elegance, generality, and hypothetical future scale.

Apply a rule when it prevents a likely or high-impact failure, protects data,
money, security, or external effects, keeps future changes local, or is cheap to
apply consistently. Otherwise, use the simpler design. Record a known limitation
when the code does not make it clear.

For MVP work, move quickly by limiting scope. Shipped behavior must remain
understandable, testable, and safe. Do not accept silent corruption, unbounded
work, hidden state, or unclear ownership to save time. Known correctness,
security, corruption, or operability problems are technical debt, not MVP shortcuts.

### Think Before Code or Plan

Understand the problem and the scale the code must support before proposing a plan or writing code. Do not assume silently or hide confusion.

- State assumptions explicitly.
- If uncertain, stop, ask shamelessly.
- When multiple interpretations exist, present them and surface the tradeoffs.
- Point out a simpler approach when one exists, and push back when warranted.

### Communicate Clearly

Use English inspired by ASD-STE100 Simplified Technical English (STE) when communicating with the human and other agents. Aim for roughly 80% of its style; strict compliance is not required. Follow this preference consistently, even when the human writes in a different style.

### Keep Solutions Simple

Write the minimum code that solves the requested problem at the expected scale. Match the existing style, even if you would do it differently.

Ask: "Would a senior engineer say this is overcomplicated?" and "Am I overengineering for the scale?" If yes, simplify.

- Add only the features, flexibility, and configurability the request requires. Nothing speculative.
- Do not introduce abstractions for single-use code or error handling for impossible scenarios.
- If 200 lines could be 50 without losing necessary behavior or clarity, rewrite them. Use this as a simplicity check, not a line-count target.

Use direct, readable control flow. Declare variables near use. Avoid global
mutable state. Make shared state and its owner explicit.

Use existing project tools when they are adequate. Every dependency must justify
its operational and supply-chain cost through correctness, security,
maintainability, or delivery value.

Defer speculative extension points, infrastructure for hypothetical traffic,
optimization without a measured or credible resource need, compatibility for
unshipped behavior, and exhaustive tests of trivial forwarding. Add them only
when current requirements or measured risk justify them.

### Explore the Codebase with Care

Exploring the codebase is an art. Use codebase-memory-mcp for deep dives;
it is LSP-based. Use `rg`, `grep`, and other text search tools deliberately, not casually
or as a substitute for understanding the code.

### Be a Responsible Engineer

Touch only what is necessary. Every changed line should trace directly to the human's request.

- Refactor only when the human requests it or when it is necessary to implement the
  requested change with clear responsibilities. Explain that connection and keep the refactor
  bounded. Defer unrelated cleanup.
- If you notice unrelated dead code, mention it; do not delete it.
- Use subagents only when the human explicitly asks. Do not spawn them eagerly.

## The Codebase IS your Memory. Keep it clean, and compartmentalized to avoid technical debt.

### Clean Deep Modules

Give each module and function one clear responsibility. Keep related behavior
together. Split files when the split makes ownership, behavior, or future changes
easier to understand. Do not use an arbitrary line limit. Avoid both god files
and collections of tiny forwarding files.

Use names that identify the domain responsibility. Replace vague names such as
`processData`, `handleThing`, `doWork`, `manager`, and `helper` with specific names.

Separate domain decisions from transport, UI, persistence, and vendor details
when that separation prevents duplicated rules or makes failures easier to verify.

### Clean Interfaces between the Modules

Design the smallest explicit interface that supports current use cases. Keep
public interfaces narrow and ownership clear. Refactor from evidence when the
next real use case arrives. Do not delay delivery to find a perfect abstraction.

Make relevant input guarantees, outcomes, failure modes, ordering constraints,
and ownership clear at the interface.

### Systems that Minimize Error States

Design software to prevent invalid states. Design operations to handle expected failures. Make unexpected failures visible.
Use types to enforce input invariants wherever practical. Use explicit validation when a type cannot establish the required guarantee.

Use typed or structured outcomes for expected failures, including invalid input,
missing files, timeouts, permission or disk failures, database contention, and
external service or model failures. Use assertions to expose impossible internal
states, invalid transitions, and broken invariants close to their cause. Add an
assertion to protect an invariant, not to increase an assertion count.
Assertions do not replace validation of untrusted input.

Validate untrusted data at user, file, network, database, IPC, model, and
external-system boundaries. Check important results from IO, parsing,
persistence, queues, model calls, and external APIs. Never discard or hide an
error that changes the outcome.

For stateful workflows, identify the owner, valid states, allowed transitions,
and interruption or retry behavior. Use transactions or an explicit recovery
strategy when partial persistence could leave contradictory state.

No useless try and catch blocks are allowed

### Bound Work at Its Source

Bound each loop through an explicit limit or bounded input. Iteration over an
already-bounded collection needs no separate numeric constant. Service and event
loops must have shutdown behavior and bounded work per iteration.

Set explicit limits on externally driven growth: request and file sizes, pages,
OCR blocks, model inputs, batches, queues, retries, concurrency, and timeouts.
Reject or stop work when a limit is exceeded. Truncation must be intentional
product behavior visible to the caller. Choose limits for current needs with
realistic headroom, not hypothetical scale.

### Match Rigor to Risk

Apply additional rigor when a failure has a large consequence, is hard to detect,
or is expensive to reverse. Examples include accounting or other external
writes, schema migrations, authentication, sensitive data, destructive
operations, concurrency, uncertain retries, and large resource consumption.

For the relevant risks:

- Record the invariant or failure model before implementation when it is not obvious.
- Define idempotency, retry, timeout, and recovery behavior.
- Use domain types when value confusion could compile and cause a serious error.
- Test rejection, interruption, and partial failure.
- Make success, rejection, and indeterminate outcomes distinguishable.
- Prefer proven designs or dependencies when they materially reduce risk.

Match the work to the consequence of failure. A display preference does not need
the same verification or recovery design as an accounting write or migration.
