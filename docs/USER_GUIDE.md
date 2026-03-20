# Claude Wrap-Up: Comprehensive User Guide

Learn how Claude Wrap-Up works: 5-phase process, confidence classification, anti-drift protection, and recursive skill hardening.

---

## Quick Navigation

- [5-Phase Wrap-Up Process](#5-phase-wrap-up-process)
- [GENESIS vs HARDENING Modes](#genesis-vs-hardening-modes)
- [Signal Types](#signal-types)
- [Confidence Classification](#confidence-classification)
- [7 Anti-Drift Rules](#7-anti-drift-rules)
- [Periodic Review](#periodic-review)
- [Slash Commands](#slash-commands)

---

## 5-Phase Wrap-Up Process

Every `/wrap-up` session follows 5 sequential phases:

### Phase 0: SETUP
Check or initialize infrastructure (CLAUDE.md, .claude/ directories). Run once on first invocation.

### Phase 0.5: MODE DETECTION
Determine: Are skills actively loaded in this session?
- **YES** → HARDENING mode (analyze and patch session-active skills)
- **NO** → GENESIS mode (detect recurring workflows for skill potential)

### Phase 1: CAPTURE
Extract all signal types from conversation:
- Corrections, Repetitions, Preferences, Successes, Insights
- Skill Deviations, Skill Corrections, Trigger Quality, Missing Coverage (HARDENING only)
- Workflow Patterns, Codifiable Rules (GENESIS only)

### Phase 2: CLASSIFY
Assign confidence levels:
- **HIGH:** Explicit correction or ≥2 occurrences
- **MEDIUM:** Implicit pattern or one-time correction
- **LOW:** Single observation without generalizability

### Phase 3: ROUTE
Determine storage target for each HIGH signal:
- CLAUDE.md (global rules)
- .claude/rules/[domain].md (domain-specific)
- CLAUDE.local.md (private)
- Skill patches (HARDENING only)
- Apply 7 anti-drift checks to every HIGH candidate

### Phase 4: PROPOSE
Display findings in compact format:
- 🔴 HIGH findings with target file and evidence
- 🟡 MEDIUM findings documented in session file
- 🟢 LOW findings noted
- HARDENING: Skill performance table (6 dimensions) + patches
- Ask: "Should the proposed changes be applied?"

### Phase 5: COMMIT
After user confirmation:
1. Write approved rules to target files
2. Apply skill patches (HARDENING only)
3. Package patched skills as installable `.skill` files (HARDENING only)
4. Create session reflection at .claude/sessions/YYYY-MM-DD-[topic].md
5. Git commit (if available)
6. CLAUDE.md health check (>200 lines?)

---

## GENESIS vs HARDENING Modes

### GENESIS Mode (Default)

**Use when:** Working in a new domain, best practices uncertain, collecting observations.

**Behavior:**
- Detects recurring workflows without an existing skill
- Recommends skill creation when patterns emerge
- Signals captured passively, rules accumulate
- Emphasis on observation

### HARDENING Mode

**Use when:** Improving existing skills actively loaded in the current session.

**Behavior:**
- Analyzes application of session-active skills
- Tests skill performance across 6 dimensions:
  - **Completeness:** Did the skill cover all necessary steps?
  - **Correctness:** Did the skill lead to correct results?
  - **Trigger Quality:** Was the skill activated at the right time?
  - **Efficiency:** Were there unnecessary steps?
  - **User Corrections:** Which corrections affected the skill?
  - **Edge Cases:** Which situations weren't covered?
- Generates patches to improve skill's SKILL.md
- Only session-active skills are analyzed (not just installed)

---

## Signal Types

### All Modes
1. **Corrections** — User explicitly contradicts or corrects
2. **Repetitions** — Repeatedly explained fact or recurring error
3. **Preferences** — Style, format, language, depth
4. **Successes** — Explicit praise or confirmation
5. **Insights** — New domain knowledge

### HARDENING Only
6. **Skill Deviations** — Where did Claude deviate from the skill?
7. **Skill Corrections** — User corrections to skill output
8. **Trigger Quality** — Was the skill activated correctly?
9. **Missing Coverage** — Situations the skill didn't handle

### GENESIS Only
10. **Workflow Patterns** — Recurring structured approaches
11. **Codifiable Rules** — Ad-hoc decisions as skill instructions

---

## Confidence Classification

Signals mature as evidence accumulates:

| Confidence | Criteria | Action |
|---|---|---|
| **HIGH** | Explicit correction OR ≥2 occurrences | Propose as rule candidate |
| **MEDIUM** | Implicit pattern OR one-time correction | Document in session file; becomes HIGH on repetition |
| **LOW** | Single observation | Document in session file only |

---

## 7 Anti-Drift Rules

Every HIGH candidate must pass all 7 checks before proposal:

1. **Evidence Requirement** — No rule without documented trigger (date, context, who identified it)
2. **Repetition Threshold** — ≥2 occurrences (explicit) or ≥3 (MEDIUM→HIGH promotion)
3. **Generalization Test** — Domain-specific? → .claude/rules/[domain].md. Global? → CLAUDE.md
4. **Contradiction Check** — Does it conflict with existing rules? Resolve before proposing
5. **200-Line Limit** — CLAUDE.md checked every wrap-up; >200 lines? Migrate to .claude/rules/
6. **Expiration Date** — Only during `/wrap-up-review`: Rules unused >10 sessions marked "possibly stale"
7. **Counterexample Check** — For every HIGH rule: Is there a legitimate exception? Formulate conditionally

---

## Periodic Review

Run `/wrap-up-review` weekly or after major domain switches:

**Analyzes across multiple sessions:**
- Rule maturity distribution
- Cross-session pattern consolidation
- Drift audit (rules with stale verification)
- Anti-drift health (mechanisms passing/failing)
- CLAUDE.md line count and extraction recommendations

---

## Slash Commands

| Command | Action |
|---------|--------|
| `/wrap-up` | Trigger manual session analysis |
| `/wrap-up-on` | Enable auto-wrap-up |
| `/wrap-up-off` | Disable auto-wrap-up |
| `/wrap-up-status` | Show configuration and rule statistics |
| `/wrap-up-review` | Multi-session periodic review |
| `/wrap-up-stats` | Cumulative learning statistics |

---

## File Structure

```
project/
├── CLAUDE.md                          ← Global rules (≤200 lines)
├── CLAUDE.local.md                    ← Private notes (don't commit)
├── .claude/
│   ├── rules/
│   │   ├── style-preferences.md
│   │   ├── project-conventions.md
│   │   └── [domain].md               ← Domain-specific rules
│   └── sessions/
│       └── YYYY-MM-DD-[topic].md     ← Session reflections
```

---

## Best Practices

- **Session discipline:** Trigger `/wrap-up` at every session end
- **Explicit rules:** Every rule needs source (session, date), not assumptions
- **Global stays small:** Keep CLAUDE.md ≤200 lines; migrate domain-specific to .claude/rules/
- **Drift testing:** Phase 4+ rules get automatic live state verification
- **Periodic review:** Run `/wrap-up-review` weekly to catch cross-session patterns
- **Skill feedback:** HARDENING mode provides 6-dimensional performance metrics for iterative improvement

---

**Master the 5 phases, trust the confidence system, enforce the 7 anti-drift rules, and your knowledge system stays aligned with reality.**
