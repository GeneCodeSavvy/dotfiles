# Maintainability Tooling

Use these tools when the task is not just "make it work", but "leave the TypeScript repo easier to change next week."

## Discovery preflight

Use `codebase-memory-mcp` before reading repository files or running filesystem searches.

1. Confirm that the MCP tools are callable. If they are deferred or hidden, load them before continuing.
2. Select an indexed project that matches the exact Git repository and state its identifier. Use `list_projects` when available. If it is not exposed, use an MCP response that reports `available_projects` or index the exact repository root.
3. Start with the narrowest operation for the question.
4. Inspect result totals, truncation flags, cursors, and pagination metadata. Narrow or paginate incomplete results before switching tools.

Use local search or direct source reads only when the MCP is unavailable, the repository is not indexed, the index is stale or incomplete, the needed fact is not represented, or exact working-tree verification is required. State the observed reason and keep the fallback narrow.

## Operation routing

- `search_graph`: symbols, definitions, implementations, and conceptual discovery
- `search_code`: textual or patterned code search with structural context
- `trace_path`: callers, callees, dependencies, impact, and data flow
- `get_architecture`: packages, services, dependencies, boundaries, hotspots, and seams
- `get_code_snippet`: source for an exact qualified name already resolved by `search_graph`

## Maintainability passes

- For dead-code or obsolete-API candidates, resolve the definition with `search_graph`, inspect inbound use with `trace_path`, include tests when relevant, and verify framework conventions, generated usage, public contracts, and the current worktree before deletion.
- For duplication, use `search_code` to find repeated patterns and inspect their real owners. Similar text alone does not justify an abstraction.
- For dependency and boundary work, start with `get_architecture`, then use `trace_path` for the specific dependency or impact path.
- For hotspots, use architecture hotspot evidence to select targets, resolve exact symbols through `search_graph`, and inspect only the relevant source.

Indexed evidence can lag the working tree. Use it to navigate and form hypotheses; use current source and repository-native checks for final decisions.

## TypeScript, linting, and formatting

Keep the repository's native commands as the authority for executable checks:

- use `tsc --noEmit` or the repo's normal type-check command
- use `vp lint`, not raw `oxlint`, in Vite+ repos
- use `vp test`, not raw `vitest`, in Vite+ repos
- use `vp fmt`, not raw `oxfmt`, in Vite+ repos

Put repo-specific local rules in the existing linter config before adding another scanner. Ban `as any`, `@ts-ignore`, deprecated imports, restricted paths, and migration-only APIs through ESLint, Oxlint, or the repo's current lint layer. Keep formatting in the formatter config.

## Vite+ defaults

When the target repo is on Vite+:

- use `vp lint`, not raw `oxlint`
- use `vp test`, not raw `vitest`
- use `vp fmt`, not raw `oxfmt`
- use `vp pack`, not raw `tsdown`
- use `vp add` and `vp dlx` instead of direct package-manager commands

## Interpretation rules

- An audit finding is not automatically a delete.
- Public APIs, generated files, framework conventions, and intentional compatibility surfaces need human judgment.
- Prefer fixing the source of truth instead of silencing the tool.
- If the same category of lint or formatting issue appears repeatedly, add or tighten a linter or formatter rule instead of relying on memory.
