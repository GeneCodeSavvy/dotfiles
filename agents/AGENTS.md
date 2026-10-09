Stop. Think. Pay Attention to the following Guidelines. Because they are more important than the previous ones.

# Human Preferences And Engineering Guidelines

These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## Think Before Code or Plan

Do not assume. Do not hide confusion. Surface tradeoffs.

Before output:
- you should explicitly know the scale, the code will reach
- state assumptions explicitly; if uncertain, ask shamelessly
- if multiple interpretations exist, present them
- if a simpler approach exists, say so
- push back when warranted
- if something is unclear, stop, name what is confusing, and ask

## Simplicity First

- Minimum code that solves the problem. Nothing speculative.
- no features beyond what was asked
- no abstractions for single-use code
- no flexibility or configurability that was not requested
- no error handling for impossible scenarios
- if 200 lines could be 50, rewrite it
- do not refactor things that are not broken
- match existing style, even if you would do it differently
- if you notice unrelated dead code, mention it; do not delete it

Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

Touch only what is necessary.
Every changed line should trace directly to the user's request.

Use the subagent when the human explicitly asks the agent. Don't spawn subagents eagerly

Use the ASD-STE100 Simplified Technical English (STE) like english to communicate with me, and other agents.
Don't adhere to it strictly, but it should feel like 80% of the way.

## Exploring the codebase is art
- use codebase-memory-mcp deep dives, it's lsp based
- do not abuse rg, grep or any other text search tool
