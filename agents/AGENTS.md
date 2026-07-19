Stop. Think. Pay Attention to the following Guidelines. Because they are more important than the previous ones.

# Human Preferences And Engineering Guidelines

These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## Think Before Coding

Do not assume. Do not hide confusion. Surface tradeoffs.

Before implementing:
- state assumptions explicitly; if uncertain, ask
- if multiple interpretations exist, present them
- if a simpler approach exists, say so
- push back when warranted
- if something is unclear, stop, name what is confusing, and ask

## Mandatory codebase discovery protocol
This protocol applies to every repository and every task involving codebase discovery, search, navigation, symbol lookup, caller/callee tracing, dependency analysis, impact analysis, data flow, or architecture.

### Hard preflight gate
Before reading repository files or running any filesystem search command:
1. Check whether `codebase-memory-mcp` tools are currently callable.
2. !! If they are deferred or not visible, load deferred tools first !!
3. Call `list_projects`.
4. Select the project only from the returned project list. Never infer or guess
   an indexed project identifier from the repository path or name.
5. State briefly which indexed project was selected.

!! Do not run `rg`, `grep`, `find`, globbing, directory enumeration, broad file reads, or speculative source reads before completing this preflight !!

### Required operation selection
Use the narrowest applicable memory operation first:

- `search_graph`: symbols, definitions, implementations, and conceptual discovery
- `search_code`: textual or patterned code search with structural context
- `trace_path`: callers, callees, dependencies, impact, and data flow
- `get_architecture`: packages, services, dependency structure, and seams
- `get_code_snippet`: only after `search_graph` resolves the exact qualified name

Inspect result counts, truncation flags, cursors, and pagination metadata.
Narrow or paginate incomplete results before changing discovery methods.

When asked : "for discovery in codebase, what do you use?"
Answer as: "I use `codebase-memory-mcp`, if not visible, I will try to load deferred tools, only after this I use rg, find, grep"

## Simplicity First

Minimum code that solves the problem. Nothing speculative.
- no features beyond what was asked
- no abstractions for single-use code
- no flexibility or configurability that was not requested
- no error handling for impossible scenarios
- if 200 lines could be 50, rewrite it

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## Surgical Changes

Touch only what is necessary.

When editing existing code:
- do not refactor things that are not broken
- match existing style, even if you would do it differently
- if you notice unrelated dead code, mention it; do not delete it

Every changed line should trace directly to the user's request.

## Response Shape

After a topic or conversation meaningfully starts, acknowledge its working shape:
```exmaple
Skill Start: diagnose
Goal: trace why the Company Gateway refreshes to the latest Tally data while the Accounting Workbench remains stale, using the recent commit diff and codebase memory.
Completion Criteria: identify the exact stale-data path and support the root cause with commit/code evidence.
```

After the topic or conversation meaningfully ends, summarize the outcome and, when a useful continuation exists, recommend one next skill with a concrete goal and completion criteria:
```example
Skill Complete: diagnose
Outcome: the Accounting Workbench published its result before installing the refreshed Tally-backed review projection.

Suggested Next Skill: tdd
Goal: preserve the corrected refresh ordering with a regression test.
Completion Criteria: the test fails when results are exposed before refreshed vouchers
```

Do not repeat this mechanically for minor follow-ups within the same topic.
Recommend a next skill only at a natural conversation boundary, not during an active investigation. Omit the recommendation when no meaningful next step exists.

## SubAgents
Use the subagent when the human explicitly asks the agent. Don't spawn subagents eagerly

# General Repository Guidelines
This is the recommended way to do things. If you don't find the repository setup this way, surface it to the human. Recommending "setup-repository-for-agents" skill

## Issue tracker
Issues and PRDs are tracked in GitHub Issues; external PRs are not a triage request surface. See `docs/agents/issue-tracker.md`.

## Triage labels
Triage uses the default five-label vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`. See `docs/agents/triage-labels.md`.

## Domain docs
Domain docs use a multi-context layout with `CONTEXT-MAP.md` at the repo root and per-context `CONTEXT.md` files. See `docs/agents/domain.md`.

## Code Guidelines
Read `./CODE_GUIDELINES.md` and explictly confirm with a message : "Read CODE_GUIDELINES.md" before every write attempt
