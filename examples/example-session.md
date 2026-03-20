# Example: Real Wrap-Up Session Walkthrough

A complete example showing Claude Wrap-Up in practice. German user, HARDENING mode, Sachsenpalmen.de marketing domain.

---

## Session Context

- **User:** Stephan
- **Date:** 2026-03-23
- **Domain:** Sachsenpalmen.de (e-commerce, plant products)
- **Task:** Optimize Merchant Center feed validation
- **Mode:** HARDENING (improving existing skills)
- **Duration:** 45 minutes

---

## Before the Session

Stephan checks status:

```bash
/wrap-up-status
```

**Output:**
```
Wrap-Up Status
──────────────
Status:          ENABLED
Mode:            HARDENING
Rules by confidence:
  🔴 HIGH:      4 rules
  🟡 MEDIUM:    8 rules
  🟢 LOW:       5 rules
Total:           17 rules
Last wrap-up:    2026-03-22T18:45:00Z
```

System is in HARDENING mode. Existing rules will be enforced. Live MC API will be checked for drift.

---

## During the Session

**Task:** Update feed for 200 new plant products.

**What happens:**
1. Stephan checks old MC export template against current Sachsenpalmen.de Brand Bible
2. Notices: "Documentation says field 'color' is optional, but live MC API now requires it"
3. Updates template to include color field with correct values
4. Bulk exports 200 products
5. MC console shows 40 products flagged as "pending review"
6. Investigation: Plant variety 'Areca' maps to 'green', but MC taxonomy requires [green, red, blue]
7. Creates explicit color mapping table
8. Re-runs export
9. All 200 products accepted

**Wrap-up passively observes:**
- Signal 1: Documentation vs. live state mismatch (existing HIGH rule applies → verified)
- Signal 2: Color taxonomy mismatch (new error observation)
- Signal 3: Successful workaround applied (mapping table created)

---

## Executing /wrap-up

```bash
/wrap-up
```

**Output (from template: wrap-up-report.md):**

```
Wrap-Up Report — 2026-03-23 | Mode: HARDENING

Signals captured: 3

🔴 HIGH — Documentation vs Live MC Data
   → [CLAUDE.md] Rule: "Always verify MC field requirements against live API before applying rules"
   Confidence: HIGH | Evidence: 2 occurrences + live verification

🟡 MEDIUM — Product Taxonomy Mapping Required
   → [Session file] Pattern: Product attributes need explicit mapping
   Evidence: One-time solution; potential cross-domain pattern

🟢 LOW — Color Taxonomy Specifics
   → [Session file] Noted for future reference
   Evidence: Single observation

────────────────────────────────────────

HARDENING MODE: Skill Performance Analysis
───────────────────────────────────────────

If a Sachsenpalmen marketing skill is active:

| Dimension      | Status | Evidence |
|---|---|---|
| Completeness   | ✓ | Skill covered MC feed optimization steps |
| Correctness    | ✓ | Skill guidance led to correct results |
| Trigger Quality| ✓ | Skill activated at right time |
| Efficiency     | ✓ | No unnecessary steps |
| User Corrections| ~ | Minimal (brand bible reference added) |
| Edge Cases     | ✗ | Color taxonomy mapping not covered |

Patch recommendation: Add explicit taxonomy handling to skill

────────────────────────────────────────

Should the proposed changes (1/1 HIGH) be applied?
[Yes] [No] [Edit]
```

**After approval:**

All changes written to files. Session reflection created at `.claude/sessions/2026-03-23-sachsenpalmen-mc-feed.md`

```bash
git commit -m "wrap-up: MC field validation - live API check protocol"
```

---

## Key Elements Demonstrated

1. **Signal Capture (Phase 1):** Errors, patterns, successes all detected passively
2. **Classification (Phase 2):** HIGH evidence, MEDIUM pattern, LOW observation
3. **Anti-Drift Rule 3 (Generalization Test):** "Doc vs. live" applies to all MC work → CLAUDE.md (global)
4. **Anti-Drift Rule 5 (200-Line Limit):** CLAUDE.md checked for length; migrate if needed
5. **HARDENING Mode (6 Dimensions):** Skill tested for Completeness, Correctness, Trigger, Efficiency, Corrections, Edge Cases
6. **Confidence:** HIGH rules eligible for CLAUDE.md; MEDIUM/LOW stay in session file
7. **Phase 5 Commit:** Git tracks every wrap-up with structured message

---

## Next Session Benefit

When Stephan works with MC again:
- HIGH rule "doc vs. live" auto-loaded into context
- Skill patches applied (if skill was active)
- HARDENING mode active: auto-verifies against live MC API before proceeding

---

**This shows wrap-up transforming one session's learnings into persistent, drift-protected rules for all future sessions.**
