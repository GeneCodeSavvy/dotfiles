# LLD Output Template

This document defines the output format templates for each stage of lld-writer.

---

## Context Collection Report

**Output timing**: Phase 0.5

```markdown
## Context Collection Report

### Baseline Documentation
| Document Type | Path | Version | Status |
|----------|------|------|------|
| PRD | {path} | {version} | Confirmed |
| HLD | {path} | {version} | Confirmed |
| Contract | {path} | {version} | Confirmed |
| Guardrails | {path/none} | - | Confirmed |

### Key constraint extraction
- Technology Stack: {Extracted from HLD/Guardrails}
- Mandatory module: {extracted from Guardrails}
- Reuse requirements: {extracted from HLD}
```

---

## LLD document information

**Output timing**: Phase 2.2

```markdown
## 1. Document Information

| Properties | Values ​​|
|------|-----|
| Document Name | LLD - {Module Name} |
| Version | v1.0 |
| Author | {Author} |
| Creation Date | {YYYY-MM-DD} |
| PRD baseline | {PRD path} v{version} |
| HLD baseline | {HLD path} v{version} |
| Contract Baseline | {Contract Path} |
| Guardrails | {path/none} |
```

---

## Traceback mapping table

**Output timing**: Phase 2.6

```markdown
## Traceback mapping

| Upstream entry | Source | LLD Chapter | Status |
|----------|------|----------|------|
| {PRD-001} User Login | PRD | §5.2 Authentication Process | ✅ Covered |
| {HLD-003} Cache Strategy | HLD | §6.1 Cache Design | ✅ Covered |
| POST /api/v1/users | Contract | §5.1 User Interface | ✅ Covered |
```

**Status Description**:
- ✅ Covered: The upstream entry has a corresponding design in LLD
- ⚠️ Partial coverage: Supplementary required
- ❌ Not covered: missing, must be added

---

## List of issues to be confirmed

**Output timing**: Phase 2.7

```markdown
## Questions to be confirmed

| # | Issue | Affected Chapters | Status |
|---|------|----------|------|
| 1 | {Problem description} | §X.X | To be confirmed |
| 2 | {Problem description} | §X.X | To be confirmed |
```

---

## Self-test report

**Output timing**: Phase 3.7

```markdown
## Self-test report

### Coverage statistics
| Check items | Results |
|--------|------|
| PRD demand coverage | 100% (X/X) |
| HLD decision making | ✅ Passed |
| Contract consistency | ✅ No conflicts |
| Guardrails Coverage | ✅ Full Coverage / N/A |

### Question list
| # | Problem | Severity | Status |
|---|------|--------|------|
| - | None | - | - |

### Self-examination conclusion
✅ After passing the self-inspection, you can submit it for review
```

**Severity Definition**:
- P0 (blocking): Contract violation, Guardrails violation
- P1 (critical): missing modules, insufficient coverage
- P2 (recommendation): readability, details
