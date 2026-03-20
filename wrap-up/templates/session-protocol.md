# Session Protocol Template — Phase 5: COMMIT

This protocol is inserted at the end of each session file. It provides the structured data foundation on which GENESIS and HARDENING operate in future sessions.

The protocol is intentionally compact — not forensic full documentation of every message, but focus on the 4 dimensions relevant for skill improvement: Corrections, deviations, errors, and confirmations.

---

## Template

Insert this block at the end of the session file (after Findings):

```markdown
## Session Protocol

**Skills activated:** [List of used skills, comma-separated, or "none"]
**Mode:** [GENESIS | HARDENING | MIXED]
**Session Type:** [Brief description, e.g., "Shopify theme customization", "n8n workflow development"]

### Interaction Summary
- User corrections: [Count]
- Self-corrections by Claude: [Count]
- Tool errors / failed calls: [Count]
- Explicit praise / confirmations: [Count]

### Critical Moments
1. [Round ~N] [What happened]: "[Quote or paraphrase]" → Impact: [what changed]
2. [Round ~N] [What happened]: "[Quote]" → Impact: [...]
3. [Additional moments if relevant]

### Skill Performance (HARDENING mode only)
| Skill | Trigger correct? | Coverage | Corrections needed? | Patch applied? |
|-------|:----------------:|----------|-------------------|:---------------:|
| [skill-name] | ✅ / ❌ | [complete / partial / incomplete] | [yes: Description / no] | [yes / no] |
| [skill-name] | ✅ / ❌ | [...] | [...] | [...] |
```

---

## Filling Instructions

### Interaction Summary

- **User corrections:** Count each place where the user explicitly corrected Claude. "No, do X instead of Y" = 1 correction.
- **Self-corrections by Claude:** Places where Claude recognized its own error and corrected it BEFORE the user had to intervene.
- **Tool errors:** Failed tool calls, timeouts, wrong file paths, etc.
- **Explicit praise:** "Perfect!", "Exactly!", "Great work" etc.

### Critical Moments

Document only moments relevant for future improvements:
- User corrections (strongest signals)
- Places where Claude deviated from the skill
- Tool errors with concrete impact
- Turning points in the session (e.g., direction change initiated by user)

Do NOT document:
- Routine interactions without learning potential
- Purely informational questions from the user
- Small talk

### Skill Performance Table

Only fill in HARDENING mode. For each skill activated in the session:

- **Trigger correct?** ✅ if the skill was activated at the right time and for the right purpose, ❌ if not
- **Coverage:** How much of the session's work did the skill cover?
  - *complete* — Skill covered all relevant steps
  - *partial* — Skill covered most steps, some missing
  - *incomplete* — Essential steps missing, Claude had to improvise heavily
- **Corrections needed?** Did the user have to correct the skill's output? If yes: briefly describe what
- **Patch applied?** Was a patch written for this skill in this wrap-up?

---

## Why This Protocol Matters

**For GENESIS:** Across multiple sessions, "skills activated: none" entries combined with similar session types reveal which workflows are repeatedly handled without a skill — the strongest signal for skill potential.

**For HARDENING:** The skill performance table and critical moments provide precise data for skill patches. Instead of guessing where a skill failed, the protocol shows exact locations.

**For Periodic Review:** The interaction summary shows trends: Are correction counts declining over sessions? Is praise increasing? That's measurable proof of Credo IV.

---

## Example: Completed Protocol

```markdown
## Session Protocol

**Skills activated:** sachsenpalmen-marketing, content-audit
**Mode:** HARDENING
**Session Type:** SEO content gap analysis for product pages

### Interaction Summary
- User corrections: 3
- Self-corrections by Claude: 2
- Tool errors / failed calls: 1
- Explicit praise / confirmations: 4

### Critical Moments
1. [Round 8] User corrected brand voice: "Not sarcastic, more authoritative" → Claude adjusted all subsequent product descriptions
2. [Round 15] sachsenpalmen-marketing skill skipped section on competitor positioning → Claude improvised, less consistent
3. [Round 22] User confirmed: "Perfekt! Genau diese Struktur" → Affected all subsequent section formatting

### Skill Performance
| Skill | Trigger correct? | Coverage | Corrections needed? | Patch applied? |
|-------|:----------------:|----------|-------------------|:---------------:|
| sachsenpalmen-marketing | ✅ | partial | yes: Brand bible load order unclear | yes |
| content-audit | ✅ | complete | no | no |
```
