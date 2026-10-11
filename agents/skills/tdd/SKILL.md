---
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests.
---

# Test-Driven Development

TDD is the chunk-based red → green loop: a bounded set of tests reaches verified red before its implementation begins. This skill is the reference that makes that loop produce tests worth keeping: what a good test is, where tests go, the anti-patterns, and the rules of the loop. Every section applies on every cycle: consult them before and during the loop, not after.

When exploring the codebase, read `GLOSSARY.md` (if it exists) so test names and interface vocabulary match the project's domain language, and respect ADRs in the area you're touching.

## What a good test is

Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't. A good test reads like a specification: "user can checkout with valid cart" tells you exactly what capability exists, and it survives refactors because it doesn't care about internal structure.

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## Seams: where tests go

A **seam** is the public boundary you test at: the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

**Test only at pre-agreed seams.** Before writing any test, write down the seams under test and confirm them with the user. No test is written at an unconfirmed seam. You can't test everything, so agreeing the seams up front is how testing effort lands on the critical paths and complex logic instead of every edge case.

Ask: "What's the public interface, and which seams should we test?" Give each proposed seam a one-line note on what it catches and what it misses.

When the shape of that interface is itself in question (how deep the module is, where the seam belongs, what the interface should expose), call the Skill tool with "codebase-design" for the vocabulary. It is the shared source of the module, interface, depth, seam, adapter, leverage and locality terms, and it is a reference to consult, not a session to run.

## Anti-patterns

- **Implementation-coupled**: mocks internal collaborators, tests private methods, or verifies through a side channel (querying the database instead of using the interface). The tell: the test breaks when you refactor but behavior hasn't changed.
- **Tautological**: the assertion recomputes the expected value the way the code does (`expect(add(a, b)).toBe(a + b)`, a snapshot derived by hand the same way, a constant asserted equal to itself), so it passes by construction and can never disagree with the code. Expected values must come from an independent source of truth: a known-good literal, a worked example, the spec.
- **Unbounded test batches**: writing a whole ticket's tests before learning from implementation. Partition the ticket into at most three coherent chunks, then take each chunk from tests to green. Dependent chunks use what predecessor chunks established.

## Plan bounded chunks

The planner defines at most three chunks per ticket. Each chunk names its observable
behavior, methods affected, approved public seams, prerequisites, edit ownership,
and focused checks. Define test scenarios, inputs, independent expected results,
and intended failures; leave executable test code to the test author.

Use at most three meaningful behavioral cases per method being implemented across
the ticket, counting parameterized cases separately. This is a ceiling, not a
quota or a requirement to test private methods directly. Map cases to methods
through approved public seams. Prefer the required result and the most important
failure boundaries. If three cases cannot cover material responsibilities, flag
that before dispatch: simplify the method or obtain an explicit exception. Keep
existing valuable tests; the ceiling does not authorize deleting regression coverage.

## Rules of the loop

1. **Prepare the interface.** If an approved public interface is absent, stop for
   a separately scoped scaffold containing signatures and minimal placeholders,
   with no working behavior. Record the scaffold separately. Behavioral tests
   must compile and execute before red can be accepted.
2. **Write the chunk's tests.** A test-only author writes the planned tests,
   fixtures, and approved harness changes, then stops. Production behavior stays
   unchanged. Use independent expected outputs and validate external fixtures
   through the applicable domain contract before counting their failures.
3. **Verify red.** The orchestrator inspects the test diff, runs focused tests,
   verifies intended behavioral failures, confirms production files are unchanged
   from the post-scaffold baseline, and records test-file hashes. Compiler errors,
   invalid fixtures, and tooling failures require test/harness repair first.
   Already-green tests are characterization: reassess the production work and
   require a valid behavioral failure for every new behavior to be implemented.
4. **Hand off to green.** A fresh production implementer receives the accepted
   tests and red evidence, and makes the smallest implementation that passes the
   chunk. Tests and their supporting fixtures/harness stay fixed. A disputed test
   returns to its author for repair and another red gate before implementation
   resumes; use a fresh test-only author if the original is unavailable. Record
   any intervening production edits so a new failure is not mistaken for original
   test-first evidence.
5. **Integrate and review.** Finish dependent chunks in order; independent chunks
   may proceed concurrently only with independent prerequisites and disjoint edit
   ownership. Run combined ticket checks after all chunks are green, then perform
   independent review. Refactoring belongs to review, outside the red → green cycle.

Behavioral repairs use the same test-author → verified red → fresh production
implementer handoff. An existing failing behavioral test can supply red without
another test. Mechanical repairs, such as formatting, can go directly to an
implementer and receive fresh review afterward. Behavior-preserving work records
characterization or source-equivalence evidence instead of manufactured red.

Retain each chunk's test-author and production-implementer identities, baseline,
scaffold, cases, fixture validity, exact commands, observed failures, test hashes,
and green results. Implementation-before-test remains a chronology deviation;
reconstructed red proves regression sensitivity, not original test-first work.
The invoking orchestrator owns dispatch and evidence storage. Missing required
red evidence blocks dependent production dispatch and acceptance.
