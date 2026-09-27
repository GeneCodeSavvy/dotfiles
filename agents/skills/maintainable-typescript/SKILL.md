---
name: maintainable-typescript
description: Guides maintainability-first cleanup, refactoring, and review in strict TypeScript repos and monorepos. Use when improving code health, deleting dead code, reducing duplication, or enforcing boundaries.
---

# Maintainable TypeScript

Use this skill when the project needs maintainability doctrine, not just local code changes.

## Load Order

Do not read the whole skill directory by default.

1. Read this file first.
2. Load only files that match the task.
3. If the repo matches the house stack, read [`stack/start-here.md`](./stack/start-here.md).
4. Treat [`doctrine/`](doctrine/), [`stack/`](stack/), and [`prompts/`](prompts/) as references, not required context.

## Codebase Discovery

Use `codebase-memory-mcp` before repository file reads, filesystem searches, or speculative source inspection.

1. Check whether the MCP tools are callable and load deferred tools when necessary.
2. Select an indexed project that matches the exact Git repository. Use `list_projects` when exposed; if it is unavailable, use an MCP response that reports `available_projects` or index the exact repository root. State the selected project identifier.
3. Use the narrowest operation first: `search_graph` for symbols and concepts, `search_code` for text patterns, `trace_path` for callers, dependencies, impact, and data flow, and `get_architecture` for structure and seams. Call `get_code_snippet` only after `search_graph` resolves the exact qualified name.
4. Inspect totals, truncation flags, cursors, and pagination metadata. Narrow or paginate incomplete results before changing discovery methods.

Use targeted local inspection only when the MCP is unavailable, the repository is not indexed, the index is demonstrably stale or incomplete, the needed fact is not represented, or exact working-tree verification is required. State the reason and keep the fallback narrow.

## Task Router

- Backbone: [`maintainability-equals-correctness`](./doctrine/foundations/maintainability-equals-correctness.md), [`resolve-uncertainty-into-contracts`](./doctrine/foundations/resolve-uncertainty-into-contracts.md), [`ssot-or-die`](./doctrine/abstractions/ssot-or-die.md), [`integration-first-testing`](./doctrine/testing/integration-first-testing.md), [`external-boundary-mocks-only`](./doctrine/testing/external-boundary-mocks-only.md), [`assert-observable-outcomes`](./doctrine/testing/assert-observable-outcomes.md)
- Cleanup/refactor: [`clean-up-what-you-touch`](./doctrine/deletion/clean-up-what-you-touch.md), [`delete-obsolete-code`](./doctrine/deletion/delete-obsolete-code.md), [`no-backwards-compat-shims`](./doctrine/deletion/no-backwards-compat-shims.md), [`delete-fake-layers`](./doctrine/deletion/delete-fake-layers.md), [`edit-real-owners`](./doctrine/deletion/edit-real-owners.md), [`build-deep-modules-not-shallow-abstractions`](./doctrine/abstractions/build-deep-modules-not-shallow-abstractions.md), [`cleanup-module-rewrite`](prompts/cleanup-module-rewrite.md), [`review-structural-slop`](prompts/review-structural-slop.md)
- Packages/boundaries: [`structure-typescript-apps-around-feature-owners`](./doctrine/abstractions/structure-typescript-apps-around-feature-owners.md), [`monorepo-package-boundaries`](./doctrine/packages/monorepo-package-boundaries.md), [`treat-critical-code-like-a-library`](./doctrine/foundations/treat-critical-code-like-a-library.md), [`naming-is-navigation`](./doctrine/foundations/naming-is-navigation.md), [`no-re-exports`](./doctrine/packages/no-re-exports.md), [`no-barrel-exports`](./doctrine/packages/no-barrel-exports.md)
- Stack/API/types: [`stack-overview`](./stack/stack-overview.md), [`design-openapi-for-inference`](./stack/design-openapi-for-inference.md), [`errors-are-schema`](./stack/errors-are-schema.md), [`document-fields-in-derived-zod-schemas`](./stack/document-fields-in-derived-zod-schemas.md), [`use-canonical-named-types`](./stack/use-canonical-named-types.md), [`jsdoc-with-first-party-sources`](./stack/jsdoc-with-first-party-sources.md), [`no-magic-values`](./stack/no-magic-values.md), [`use-branded-scalar-types`](./stack/use-branded-scalar-types.md)
- Testing/frontend/tooling: [`contract-gate-synthetic-fixtures`](./doctrine/testing/contract-gate-synthetic-fixtures.md), [`test-ai-apps-by-artifacts-not-prose`](./doctrine/testing/test-ai-apps-by-artifacts-not-prose.md), [`no-type-casts`](./doctrine/boundaries/no-type-casts.md), [`boundaries-validate-internals-trust`](./doctrine/boundaries/boundaries-validate-internals-trust.md), [`do-not-synchronize-state-with-useeffect`](./stack/do-not-synchronize-state-with-useeffect.md), [`use-the-design-system-not-ad-hoc-tailwind`](./stack/use-the-design-system-not-ad-hoc-tailwind.md), [`test-react-apps-in-real-browsers`](./stack/test-react-apps-in-real-browsers.md), [`maintainability-tooling`](./doctrine/tooling/maintainability-tooling.md)
- Editing this skill: read the files you touch, then run the skill validator and verify changed links.

## Maintainability Workflow

Use indexed results to find candidate owners, dependencies, unused surfaces, duplication, cycles, boundaries, and hotspots. Treat those results as leads, not proof: verify decisive facts against the current worktree and run the repository's native type-check, lint, and test commands before changing or deleting code.

If the target repo is Vite+, use `vp` for the normal toolchain entrypoint: `vp lint`, `vp test`, `vp fmt`, `vp pack`, `vp add`, and `vp dlx`.

## Defaults

- Structure is expensive; preserve contracts, tests, and invariants.
- Prefer deletion over shims, real owners over fake layers, and stable subsystem files over helper forests.
- Resolve uncertainty into contracts, not adapters, defaults, optionals, spreads, or catches.
- Prefer derived types/schemas, durable integration tests, external-boundary mocks only, and assertions on observable outcomes.
- Prefer MCP-first discovery followed by targeted working-tree and repository-native verification.
- Leave the codebase more coherent now.
