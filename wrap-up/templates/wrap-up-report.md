# Wrap-Up Report Template — Phase 4: PROPOSE

Use this exact format for output in Phase 4. Only adjust the placeholders in square brackets.

---

## Output Format

```
## Wrap-Up Report — [YYYY-MM-DD]
**Mode:** [GENESIS | HARDENING | MIXED]
**Session Topic:** [Brief description]

---

### Proposed Changes

1. 🔴 HIGH — [Signal type]: [Brief description]
   → **Target file:** `[Path to target file]`
   → **Rule:** "[Rule text, concrete and actionable]"
   → **Evidence:** [What exactly happened in the session, quote if applicable]

2. 🔴 HIGH — [Signal type]: [Brief description]
   → **Target file:** `[Path]`
   → **Rule:** "[Rule text]"
   → **Evidence:** [Context]

### Documented (no change)

3. 🟡 MEDIUM — [Description]
   → Session file: Noted for later evaluation
   → Becomes HIGH upon repetition in future session

4. 🟢 LOW — [Description]

---
```

## Addition for HARDENING Mode — Skill Patches

After the general findings, add a separate section for EACH skill that was actively loaded and used in this session. Analyze ONLY skills that were actually activated in this session — not all installed skills:

```
### Skill Patch: [skill-name]

**Skill Performance Analysis:**

| Dimension | Rating | Action |
|-----------|--------|--------|
| Completeness | [complete / incomplete] | [Describe enhancement or "no action"] |
| Correctness | [correct / faulty] | [Describe correction or "no action"] |
| Trigger Quality | [good / too early / too late / wrong] | [Change to description or "no action"] |
| Efficiency | [good / bloat detected] | [What to remove or "no action"] |
| User Corrections | [none / X instances] | [Which corrections directly related to skill output?] |
| Edge Cases | [none / detected] | [Which situations did the skill not cover?] |

**Concrete Changes to SKILL.md:**

**Patch 1:**
> **OLD:** [Existing instruction from SKILL.md, quoted exactly]
>
> **NEW:** [Improved instruction]
>
> **Reason:** [What went wrong in the session and why this change fixes it]

**Patch 2:** [If multiple changes needed]
> **OLD:** ...
> **NEW:** ...
> **Reason:** ...
```

## Addition for GENESIS Mode — Skill Potential

```
### Skill Potential Detected? [Yes / No]

[If Yes:]

**Identified Workflow:** [What was done repeatedly manually?]
**Frequency:** [X times in this session / Y times across sessions]

**Quality Criteria Check (all must pass):**
- [ ] **Recurring?** Workflow appears ≥3 times (in this session or across sessions)
- [ ] **Complex enough?** Workflow is non-trivial and justifies its own skill
- [ ] **No interference?** New skill doesn't collide with existing skills
- [ ] **Anthropic standards?** Name in kebab-case, description with trigger phrases, <500 lines SKILL.md

**Core Rules for the new skill:**
1. [Rule 1]
2. [Rule 2]
3. [Rule 3]
4. [Additional rules if needed]

**Recommendation:** "Should I call the /skill-creator to turn this into a standalone skill?"

[If No:]
No recurring workflow pattern detected that would justify its own skill.
```

## Report Conclusion

```
---

Should the proposed changes be applied?
You can respond with:
- **Yes** → Apply all changes (on HARDENING: package patched skills as .skill files)
- **No** → Create only session file, write no rules
- **Exclude numbers** → e.g., "Yes, but without 2"
- **Change requests** → e.g., "1 reformulated: ..."

**Note on HARDENING:** After applying skill patches, each patched skill is automatically packaged as an installable `.skill` file and made available for download.
```

## Quality Guidelines

- **Rule texts must be concrete and actionable.** Not: "Be more careful with APIs" → Rather: "Always use Shopify API v3, never v2"
- **Evidence must be specific.** Not: "User was dissatisfied" → Rather: "User said in round 3: 'No, that's v2, we need v3' and repeated this in round 7"
- **Every rule needs a storage target.** No rule without a file path.
- **Anti-drift rules were already checked in Phase 3.** Don't mention it again in the report — the user sees only the clean result.
