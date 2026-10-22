---
name: deepen
description: Deepen a task prompt when the user asks for a more professional, evidence-grounded version within the same scope, or another skill requires prompt preparation before agent dispatch.
---

# Deepen

Make the task deeper, not bigger. Replace shallow treatment with the professional work needed to make the same result trustworthy.

## 1. Fix the scope

Use the prompt supplied with this invocation, or the task it clearly refers to in the conversation. If neither identifies a task, ask for the prompt and stop.

Identify its intended outcome, subject, deliverable, and explicit constraints. Preserve these as the scope boundary. When context leaves a consequential choice open, state a narrow assumption; ask only when different answers would change the task itself. use *"grilling"* to clarify the intent if gaps remains.

Done when you can distinguish a deeper treatment of the requested result from an additional assignment.

## 2. Diagnose before rewriting

Use these four questions internally, in this order, tailored to the actual task. Carry the useful conclusions into the rewritten prompt. Keep the questions, answers, and diagnosis out of the response.

1. **Professional practice:** What would a professional in this field do here that the prompt leaves unasked? Name the consequential judgment or work and explain how it improves the requested result. If the prompt already asks for it, identify the remaining gap or say this part is already covered.
2. **Rawest material:** What would they start from instead of material already digested for the user? Name the closest relevant sources, observations, artifacts, or records and what they establish. Treat summaries and earlier assistant conclusions as navigation aids. Mark unavailable material as something to obtain, not something inspected.
3. **Methods and tools:** Name the specific techniques and suitable tools, tied to the material and the question each resolves. Choose the smallest sufficient method. Distinguish proposed tools from tools actually available; use manual methods where adequate.
4. **Independent evidence:** What, other than agreement between the user and assistant, would show the result is right? Name observable evidence and the acceptance or failure condition. Separate checks that establish presentation or mechanics from evidence that establishes substantive correctness. For work without a single correct answer, use relevant constraints, audience response, or an explicit evaluation rubric and state what remains judgment.

Done when all four answers are concrete enough to guide execution, and each proposed addition serves the original result. Replace vague demands such as “be rigorous” with the actual work and evidence.

## 3. Rewrite the prompt

Return only one rewritten prompt, in the user's voice, as instructions to the person or agent doing the task. Begin directly with the prompt, without a preface or explanation of the rewrite.

Use ASD-STE100-inspired English: short, direct sentences, active voice, concrete verbs, and consistent terms. Give each instruction one clear action. Preserve necessary technical terms and exact names. Add depth through specific work, sources, methods, and evidence, rather than longer or more formal wording.

Carry the original outcome and constraints forward. Incorporate the professional work, starting material, methods, and acceptance evidence identified above. Resolve references such as “this task” into the relevant subject so the rewrite works outside this conversation. Identify required missing inputs without fabricating their contents.

Keep the assignment within the scope boundary: deepen how the work is done and checked, while retaining the requested deliverable, audience, and resource limits. Include only the diagnosis items that the rewrite actually asks for; reconcile any mismatch before returning it.

Stop after the rewritten prompt. This invocation rewrites the task; it does not authorize executing it.
