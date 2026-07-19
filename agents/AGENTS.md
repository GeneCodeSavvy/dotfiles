# AGENTS.md

## Human Preferences And Engineering Guidelines

These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### Think Before Coding

Do not assume. Do not hide confusion. Surface tradeoffs.

Before implementing:
- state assumptions explicitly; if uncertain, ask
- if multiple interpretations exist, present them
- if a simpler approach exists, say so
- push back when warranted
- if something is unclear, stop, name what is confusing, and ask
- always use memory-mcp first instead of eagerly abusing grep, rg, or read tool calls. 

### Simplicity First

Minimum code that solves the problem. Nothing speculative.
- no features beyond what was asked
- no abstractions for single-use code
- no flexibility or configurability that was not requested
- no error handling for impossible scenarios
- if 200 lines could be 50, rewrite it

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### Surgical Changes

Touch only what is necessary.

When editing existing code:
- do not refactor things that are not broken
- match existing style, even if you would do it differently
- if you notice unrelated dead code, mention it; do not delete it

Every changed line should trace directly to the user's request.

Use the subagent skill when the user explicitly asks you to. Don't spawn subagents eagerly

## General Repository Guidelines
This is the recommended way to do things. If you don't find the repository setup this way, surface it to the human.

### Issue tracker
Issues and PRDs are tracked in GitHub Issues; external PRs are not a triage request surface. See `docs/agents/issue-tracker.md`.

### Triage labels
Triage uses the default five-label vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs
Domain docs use a multi-context layout with `CONTEXT-MAP.md` at the repo root and per-context `CONTEXT.md` files. See `docs/agents/domain.md`.
