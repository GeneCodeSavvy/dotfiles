---
name: landing-page-conversion
description: Use when creating, designing, writing, implementing, auditing, reviewing, improving, or optimizing conversion-focused landing pages, including PPC, lead generation, SaaS, ecommerce offer, signup, demo, trial, download, local-service, and campaign pages.
---

# Landing Page Conversion

Use this skill to make landing pages convert, not just look finished.

Start by choosing exactly one mode:

- **Build Mode**: Use when the user asks to create, design, write, implement, or plan a new landing page.
- **Audit Mode**: Use when the user provides or references an existing page, screenshot, repo, URL, copy, or layout and asks for review, critique, optimization, or fixes.

If the request could be either, ask one concise clarification before proceeding.

## References

Load [references/conversion-patterns.md](references/conversion-patterns.md) when the page needs concrete conversion patterns, example-backed section choices, PPC/local-service guidance, or an A/B test backlog. Use those examples as evidence and pattern inspiration, not as universal formulas.

## Shared Conversion Framework

Use this framework in both modes:

1. **Intent**: Identify traffic source, audience, awareness level, search/ad/message context, and conversion context.
2. **Offer**: State what the visitor gets, why it matters, why now, and why this is better than the obvious alternative.
3. **Hero**: Make the first screen explain the desired outcome, mechanism, proof, visual context, and next action within seconds.
4. **CTA**: Use one primary action, clear button copy, nearby risk reducers, and no avoidable competing links.
5. **Proof**: Prefer specific testimonials, reviews, named logos, metrics, screenshots, case studies, publication quotes, or examples that are credible enough to verify.
6. **Objections**: Address price, effort, trust, risk, timing, switching cost, uncertainty, and alternatives before they block action.
7. **Structure**: Make the page scannable. Headings should carry the argument even when body text is skipped.
8. **Mobile and performance**: Treat fast load, visible CTA, readable layout, and visible proof as conversion requirements.
9. **Test plan**: Prefer tests on hero copy, CTA wording, proof placement, pricing framing, preview media, form friction, and section order.

## Above-the-Fold Standard

Treat the first screen as the main conversion surface, especially for paid traffic and mobile. It must quickly answer:

- What is this?
- Why should this visitor care now?
- What should they do next?
- Why is the action credible and low risk?

Include a benefit-led headline, mechanism-oriented subhead, primary CTA, risk reducer, credible proof, and contextual product/service visual unless the conversion goal clearly requires a simpler lead-capture layout.

## Build Mode

Before writing code or final copy, produce an implementation-ready page brief unless the user has already provided one.

### Build Steps

1. Identify the conversion goal, success event, audience, traffic source, awareness level, offer, and brand/product constraints.
2. Choose one primary CTA. If a secondary CTA is requested, explain the tradeoff and keep it visually subordinate.
3. Draft the above-the-fold section first:
   - outcome-driven headline
   - explanatory subhead that states the mechanism or differentiator
   - primary CTA with button copy that describes the next step
   - nearby risk reducer
   - credible proof above the fold when available
   - contextual image, product visual, video, screenshot, or demo direction
4. Build the page narrative section by section:
   - problem or desire
   - promised outcome
   - mechanism or product explanation
   - benefits over features
   - proof
   - objection handling
   - process or how it works
   - offer details
   - FAQ
   - final CTA
5. Make every major heading benefit-bearing and scannable. Avoid headings like "Features", "Services", "Why Us", or "How It Works" unless the heading also states the specific benefit.
6. Specify mobile behavior for CTA access, proof visibility, media, forms, section order, and sticky elements.
   - For the stated conversion action, specify the exact interaction mechanics, visibility, post-click expectation, and tracking event, such as tap-to-call, SMS, form submit, booking calendar, map directions, demo request, signup, or download.
7. Define performance and accessibility expectations that matter to conversion: fast initial load, readable contrast, clear focus states, descriptive labels, and no layout shifts around the CTA.
8. End with a short A/B test backlog.

When the request involves PPC, lead generation, local services, ecommerce, SaaS, education, finance, contests, or deadline-driven offers, read [references/conversion-patterns.md](references/conversion-patterns.md) before finalizing the brief.

### Build Output

Fill every bracketed field with concrete page-specific content; never return bracketed template text. If information is missing, state the assumption or missing input.

Return this structure:

```markdown
**Page Goal**
[Audience, traffic source, offer, conversion action, and success event.]

**Hero**
- Headline:
- Subhead:
- CTA:
- Risk reducer:
- Proof:
- Visual direction:

**Page Structure**
1. [Section name]: [purpose, key copy angle, proof/asset needs]
2. [Section name]: [purpose, key copy angle, proof/asset needs]

**Proof and Objections**
- Proof to show:
- Objections to answer:

**Mobile and Performance**
- [Specific mobile/performance requirements]

**A/B Test Backlog**
- [High-impact test]
- [High-impact test]
```

If implementation is requested after the brief is clear, implement the page with the smallest code that satisfies the brief and the existing codebase conventions.

## Audit Mode

Audit Mode produces prioritized findings, not generic CRO advice. Every finding must name the page element, explain the conversion problem, and give replacement copy, layout direction, or removal guidance specific enough to implement.

### Audit Steps

1. Inspect the available artifact: URL, screenshot, code, copy, page file, or user-provided description.
2. Identify the current conversion goal and whether the page supports it. If the traffic source is missing, state that as an assumption.
3. Review message match between traffic intent, headline, visual, offer, and CTA.
4. Review the above-the-fold section for:
   - clear outcome
   - clear mechanism
   - visible CTA
   - credible proof
   - contextual visual
   - risk reduction
5. Review CTA friction, form friction, competing links, button copy, and secondary actions.
6. Review proof quality. Flag proof that is vague, hidden, unverifiable, repeated without context, or disconnected from the offer.
7. Review scan structure: headings, hierarchy, clutter, section order, repeated claims, hidden content, and whether each section advances conversion.
8. Review mobile and performance risks when evidence is available. If evidence is not available, list the exact check that remains.
9. Prioritize fixes by likely conversion impact and implementation effort.

When auditing a page with paid traffic, forms, local intent, mobile-heavy traffic, or weak proof, read [references/conversion-patterns.md](references/conversion-patterns.md) before writing findings.

### Audit Output

Fill every bracketed field with concrete page-specific content; never return bracketed template text. If information is missing, state the assumption or missing input.

Return this structure:

```markdown
**Top Conversion Blockers**

1. **[Finding]** - Priority: high
   Evidence: [specific page detail]
   Fix: [exact recommended change]
   Test: [optional A/B test when validation is better than a blind change]

2. **[Finding]** - Priority: medium
   Evidence: [specific page detail]
   Fix: [exact recommended change]
   Test: [optional A/B test]

**Quick Wins**
- [Small change with clear conversion rationale]

**Open Assumptions**
- [Missing traffic source, audience, analytics, mobile evidence, or conversion definition]
```

## Guardrails

- Prefer clarity over novelty.
- Keep one dominant conversion goal.
- Do not add multiple competing CTAs unless the page goal requires it.
- Do not invent testimonials, logos, metrics, customer names, screenshots, publication quotes, certifications, guarantees, or pricing. Mark missing proof as an asset need.
- Do not hide critical proof in mobile carousels, accordions, tabs, or interactions users may never open.
- Do not use vague proof. Make proof specific, attributed, contextual, and connected to the offer.
- Do not recommend long copy unless every section resolves a real conversion need.
- Do not treat conversion percentages as meaningful without traffic source, sample size, and conversion definition.
- Do not overfit isolated examples. Use source examples as evidence for principles, not formulas.
- Do not add decorative complexity when a clearer section, stronger headline, or better proof would do more.
- For paid traffic, prioritize message match and load speed before polishing lower-page details.
- For local-service pages, make location relevance, trust, offer, and contact action visible early.
- For SaaS or product pages, show the product, outcome, proof, and pricing or next-step expectation as early as practical.
- For mobile-heavy pages, expose critical proof and CTA access directly; do not hide them in carousels, tabs, or accordions.

## Verification Checklist

Before claiming the work is done:

1. Confirm the request was routed to Build Mode or Audit Mode.
2. Confirm the primary conversion goal is explicit.
3. Confirm the CTA is visible, specific, and low friction.
4. Confirm proof appears early and is credible.
5. Confirm headings are scannable and benefit-bearing.
6. Confirm mobile CTA, proof, and performance risks were considered.
7. Confirm the final output follows the mode-specific output contract.
