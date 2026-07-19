---
name: lavish
description: Turn complex or visual agent responses into rich, reviewable HTML artifacts the user can annotate and send feedback on, using lavish-axi and optional React/Tailwind/shadcn builder scripts. Use when about to give a plan, comparison, diagram, table, code diff, report, prototype, or anything easier to grasp visually than as prose.
argument-hint: <what the artifact should show>
author: Harsh Sharma
metadata:
  codex:
    tags: [html, review, artifacts, visualization]
    category: productivity
---

# Lavish Editor

Lavish Editor helps agents turn rich HTML artifacts into collaborative human review surfaces. Whenever you are about to give user a complex response that will be easier to understand via a rich / interactive page, consider using Lavish Editor. First generate an interactive HTML artifact according to user request, then run `npx -y lavish-axi <html-file>` so the user can visually review it, annotate elements or selected text, queue prompts, and send feedback back through `npx -y lavish-axi poll`.

For simple artifacts, write a portable single HTML file directly. For complex artifacts that need React state management, routing, Tailwind CSS, or shadcn/ui components, use the bundled Web Artifacts Builder scripts in `scripts/`, then pass the bundled HTML output to lavish-axi.

You do not need lavish-axi installed globally - invoke it with `npx -y lavish-axi <html-file>`.
If lavish-axi output shows a follow-up command starting with `lavish-axi`, run it as `npx -y lavish-axi ...` instead.

## Request

$ARGUMENTS

If the request above is non-empty, the user invoked `/lavish` explicitly - build an HTML artifact for that request now, following the workflow below.
If it is empty, infer what to visualize from the conversation.

## When to use

Use lavish-axi when the user asks for a visual artifact, HTML explainer, interactive prototype, review surface, product or technical plan, comparison, report, or browser-based feedback loop

## Workflow

1. Choose the artifact path:
   - Default to a fresh per-artifact directory under `/tmp`, for example `/tmp/lavish-<name>-<timestamp>/<name>.html`.
   - Include a timestamp or unique suffix in the directory name so each run starts from a new file and never resumes stale `.lavish/` artifacts.
   - Use the advanced React builder only when the artifact needs complex state, routing, or shadcn/ui.
2. Create or bundle the HTML artifact.
3. Run `npx -y lavish-axi <html-file>` to open or resume a review session in the browser.
4. Run `npx -y lavish-axi poll <html-file>` to long-poll for the user's annotations, queued prompts, and browser-reported `layout_warnings`.
   The poll stays silent until the user acts or the real browser reports fresh layout warnings - leave it running, never kill it.
   If your harness limits how long a foreground command may run, run the poll as a background task; if it gets killed or times out anyway, just re-run it - queued feedback is never lost.
5. If poll returns `layout_warnings`, fix overflow, clipped text, or overlapping unreadable content and re-check before involving the human.
6. If poll returns user feedback, do not treat a normal chat reply as sufficient. Apply any requested change, or explicitly decide that no file change is needed, then immediately run `npx -y lavish-axi poll <html-file> --agent-reply "<message>"` so the browser session receives the acknowledgement and the feedback loop stays open.
7. Run `npx -y lavish-axi end <html-file>` when the review is finished.

## Advanced React builder

Use this path only for elaborate, multi-component artifacts where single-file HTML would become brittle or too slow to maintain.

The bundled builder creates a React 18 + TypeScript + Vite project with Tailwind CSS 3.4.1, shadcn/ui theming, preinstalled Radix dependencies, lucide-react, and Parcel bundling to a single HTML file.

1. Resolve the skill directory that contains this `SKILL.md`.
2. Initialize a throwaway artifact project:

   ```bash
   bash <lavish-skill-dir>/scripts/init-artifact.sh /tmp/lavish-<artifact-name>-<timestamp>
   ```

3. Build the artifact by editing the generated React project.
4. Bundle it to one portable HTML file from inside the generated project:

   ```bash
   cd /tmp/lavish-<artifact-name>-<timestamp>
   bash <lavish-skill-dir>/scripts/bundle-artifact.sh
   ```

5. Open the bundled artifact in Lavish:

   ```bash
   npx -y lavish-axi /tmp/lavish-<artifact-name>-<timestamp>/bundle.html
   ```

6. Continue with the normal `poll`, layout-warning, feedback, and `end` loop.

Builder requirements: Node.js 18 or newer, `pnpm`, and network access for package installation. The scripts are vendored from Anthropic's `web-artifacts-builder` skill and keep the upstream license in `scripts/LICENSE.txt`.

## Visual guidance

- Use visual hierarchy to make the most important decisions, risks, tradeoffs, and next actions obvious at a glance
- Use visual structure such as sections, cards, tables, diagrams, annotated snippets, and side-by-side comparisons instead of long prose
- Choose typography, spacing, color, and layout deliberately so the artifact has a clear point of view
- Prevent horizontal overflow at every nesting level: nested grid/flex children also need minmax(0, 1fr) tracks and min-width: 0, especially when badges, labels, or status text use wide pixel or monospace fonts; wrap, truncate, or contain long unbreakable text deliberately

## Playbooks

Run `npx -y lavish-axi playbook <id>` for focused, detailed guidance on any of these.
One artifact often combines several playbooks (for example a plan that includes a comparison and a diagram), so MUST open each matching playbook before writing HTML.
For flows, architecture, state, or sequence diagrams, do not hand-build boxes-and-arrows from div/flexbox; open the diagram playbook and use Mermaid unless SVG is needed for richly annotated nodes.

- `diagram` - Map relationships, flows, state, and architecture
- `table` - Turn dense records into scan-friendly review surfaces
- `comparison` - Show options, tradeoffs, and current vs target behavior
- `plan` - Explain a product or technical plan before implementation
- `code` - Render source code, code files, patches, PR diffs, and before/after code inside Lavish artifacts
- `input` - Must be used when the agent needs to collect user input on decisions, choices, preferences, triage, scope, or other structured feedback from within the artifact
- `slides` - Create a deliberate presentation when slides are requested

## Commands & rules

- Run `npx -y lavish-axi <html-file>` to open or resume a Lavish Editor session
- Unless the user specifies another location, create HTML artifacts in a fresh per-artifact directory under `/tmp`, for example `/tmp/lavish-<name>-<timestamp>/`. Do not use or reuse `.lavish/` as the default artifact location.
- Lavish serves the html file through a local express.js server. If your html needs to reference other filesystem assets such as images, CSS, fonts, and local scripts, copy them into the same directory as the HTML file, then reference them with relative paths from that directory. Never prepend `/` to those asset paths - root paths won't work
- Run `npx -y lavish-axi poll <html-file>` to wait for user feedback or browser-reported layout_warnings. It long-polls and stays silent until the user sends feedback, ends the session, or the real browser reports fresh layout_warnings, so leave it running - never kill it. Fix layout_warnings before involving the human. If your harness limits how long a foreground command may run, run the poll as a background task; if it gets killed or times out anyway, just re-run it - queued feedback is never lost
- When poll returns user feedback, always send the acknowledgement or result back through `npx -y lavish-axi poll <html-file> --agent-reply "<message>"` before finalizing in chat, even when the feedback only says the artifact is good and no edits are needed.
- Run `npx -y lavish-axi end <html-file>` to end a session
- Run `npx -y lavish-axi stop` to shut down the background server (it also self-stops when idle or after the last session ends with nothing connected)
- Run `npx -y lavish-axi playbook <playbook_id>` for focused artifact guidance. One artifact often combines several playbooks (for example a plan that includes a comparison and a diagram), so MUST open each matching playbook before writing HTML.
- Lavish does not auto-inject any design system - artifacts stay portable so they render identically when opened directly without lavish-axi running. Before writing any HTML, decide the design direction in this strict priority order, and only move to the next step when the current one truly yields nothing: (1) if the user asked for a specific look or named design system, use that; (2) otherwise you must first inspect the project the artifact is about - the subject or product whose content or UI it represents, which may differ from your current working directory - and match that project's design system: Tailwind or theme config, shared CSS variables or design tokens, component library, brand assets, or existing styled pages. If the artifact previews, proposes, or mocks a specific app's UI, render it in that app's own design system so it faithfully shows the product, even when you are running in a different repo; (3) only when both steps come up empty, use the Lavish-recommended Tailwind CSS browser runtime v4 + DaisyUI v5, available via CDN - run `npx -y lavish-axi design` for a content-to-playbook router, a copy-pasteable CDN snippet, a Mermaid CDN snippet/init for diagrams, and the DaisyUI component reference, and prefer the Tailwind/DaisyUI CDN snippet over hand-writing styles unless explicitly instructed otherwise by the user. When you deliver the artifact, state which of the three design sources you used and why.
- Use lavish-axi when the user asks for a visual artifact, HTML explainer, interactive prototype, review surface, product or technical plan, comparison, report, or browser-based feedback loop
