---
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests.
---

# Test-Driven Development

TDD is the red → green loop: one behavioral test, verified red, then the smallest implementation that passes. Each cycle informs the next.

## Project policy and references

Before selecting seams or designing tests, read the active project's local `testing-policy` skill, conventionally `.agents/skills/testing-policy/SKILL.md`. Resolve it through the project's skill catalog or agent instructions. If missing or unreadable, stop test planning and ask for the policy to be supplied or created.

The project policy owns test scope, public/private boundary exceptions, harness choices and checks; it overrides generic testing advice. Explicit TDD still requires red before green. The invoking workflow owns any agent separation, dispatch and evidence storage requirements.

Read [test-quality.md](test-quality.md) before designing tests and during review. When authoring tests, read the relevant [TypeScript/JavaScript](patterns/typescript-javascript.md) or [Rust](patterns/rust.md) reference if its language-specific guidance applies. Follow the project's existing framework and harness.

When exploring the codebase, read the relevant `GLOSSARY.md` if present and respect ADRs in the affected area.

## What a good test is

Tests verify observable behavior through public interfaces. A good test reads like a specification and survives internal refactoring. Expected values come from an independent source: a known literal, worked example or specification.

## Seams: where tests go

A **seam** is the public boundary where behavior is observed. Record each proposed seam and what it catches and misses. Reuse approval from the user's task or accepted plan; confirm new or changed boundaries with the user before writing tests there.

When the interface shape or seam is undecided, consult `codebase-design` for the shared module and interface vocabulary.

## Anti-patterns

- **Implementation-coupled:** assertions depend on internal structure rather than the promised outcome.
- **Tautological:** expected values repeat production logic or assertions verify only fixture/mock configuration.
- **Horizontal slicing:** writing a batch of tests before implementation commits to imagined behavior. Use **vertical slices**: each test is a **tracer bullet** informed by the previous cycle.

## Rules of the loop

- **Prepare the interface.** If absent, add only the approved signatures and minimal placeholders needed to execute the test. Identify scaffolding separately from working behavior.
- **One slice at a time.** Write one test for one observable behavior. Several related assertions or public interfaces may establish that behavior. Let project policy determine sufficient coverage.
- **Verify red before green.** Run the focused test and observe its intended behavioral failure before implementing. Compiler errors, broken fixtures and tooling failures require repair; they are not red. Validate serialized external fixtures against their applicable contract.
- **Implement minimally.** Add the smallest coherent implementation that passes, then run the focused checks. Keep accepted test expectations intact; anticipate no future tests or speculative features.
- **Handle exceptions honestly.** An existing failing behavioral test can supply red. Already-green tests are characterization; reassess the needed change rather than manufacture failure. Correct defective or disputed tests openly and verify behavioral red again before continuing implementation. Reconstructed red proves regression sensitivity, not original test-first chronology.
- **Review after green.** Run the project checks appropriate to the combined change and report focused commands and red/green results. Structural refactoring belongs to review (see `code-review`), outside the red → green cycle; rerun affected checks after review changes.
