# The 7 Anti-Drift Rules

These rules prevent the knowledge system from degenerating through uncontrolled rule growth (Credo VI). Apply EACH of these checks to EVERY HIGH candidate before proposing it to the user.

---

## Rule 1: Evidence Requirement

**No rule without documented trigger.**

Every proposed rule must contain:
- What was the concrete problem? (Context)
- Who identified it? (User correction, Claude observation)
- In which session? (Date)
- What is the solution? (Rule text)

**Anti-Pattern:** "Claude should always do X" without explaining when and why X became relevant.

---

## Rule 2: Repetition Threshold

**Single observations do NOT become rules.**

- HIGH confidence: Only after ≥2 occurrences (explicit corrections) OR a single, unambiguous "always/never" instruction
- MEDIUM → HIGH promotion: Only after ≥3 occurrences across multiple sessions

**Anti-Pattern:** "User wanted a table instead of flowing text once" → Immediately suggest as global rule "Always use tables". That's overgeneralization.

---

## Rule 3: Generalization Test

**Does the rule apply in all contexts or only in specific ones?**

Check: If I apply this rule to ALL future sessions, will it sometimes cause wrong behavior?

- YES → Rule belongs in `.claude/rules/[domain].md`, not CLAUDE.md
- NO → Rule can be in CLAUDE.md as global rule

**Example:**
- "Always add error handling in n8n workflows" → Specific → `.claude/rules/n8n-workflows.md`
- "Always answer in English" → Global → CLAUDE.md

---

## Rule 4: Contradiction Check

**Before every new rule: Does it contradict an existing one?**

1. Read all existing rules in CLAUDE.md and relevant `.claude/rules/` files
2. Check for direct contradictions
3. If contradiction exists: Which rule is more current? Which is better reasoned?
4. Resolve the contradiction before proposing the new rule

**Example:** Existing rule: "Use pip for Python packages" → New correction: "Always use uv instead of pip" → Old rule must be explicitly replaced, not just supplemented.

---

## Rule 5: 200-Line Limit

**CLAUDE.md is checked for length with every wrap-up.**

CLAUDE.md should function as a router — short, clear, maximum 200 lines. If it exceeds 200 lines after the update:

1. Identify rules specific enough for `.claude/rules/`
2. Propose to user an outmigration: "CLAUDE.md is now [X] lines. Should I move these rules to .claude/rules/?"
3. Replace migrated rules with `@import` references

---

## Rule 6: Expiration Date (only during periodic review)

**Rules that haven't been relevant for a long time are marked.**

This does NOT happen automatically with every wrap-up, only during explicit review (`/wrap-up --review` or "review my rules"):

1. Check: Which rules in CLAUDE.md and .claude/rules/ have had no recognizable relation to work topics for >10 sessions?
2. Mark them as "possibly outdated"
3. Propose to user: Keep, archive, or delete?

**Never automatically delete.** Always let the user decide.

---

## Rule 7: Counterexample Check

**For every HIGH rule: Is there a legitimate case where the rule should NOT apply?**

Actively think about exceptions:

- "Always use Markdown tables" → Counterexample: A single data point doesn't need a table → Make rule conditional: "Use Markdown tables for comparisons with ≥2 data points"
- "Always answer in English" → Counterexample: In explicitly English code reviews, German would be hindering → Rule conditional: "Answer in English, except in explicitly English contexts"

**Formulation:** If a counterexample exists, formulate the rule as conditional rather than absolute.

---

## Checklist for Phase 3 (ROUTE)

Apply this checklist to every HIGH candidate:

- [ ] **Evidence present?** (Rule 1)
- [ ] **Repetition threshold reached?** (Rule 2)
- [ ] **Generalization test passed?** → Correct storage location (Rule 3)
- [ ] **No contradiction?** → Or contradiction resolved (Rule 4)
- [ ] **CLAUDE.md stays ≤200 lines?** → Otherwise migrate (Rule 5)
- [ ] **Counterexample checked?** → Formulated conditionally if needed (Rule 7)

---

## CLI Enhancement

The `scripts/stats.sh` tracks rule growth over time and alerts if the system is drifting:

```bash
scripts/stats.sh --history
# Output: Rule count by session, trend analysis, CLAUDE.md line count
```

Example output:
```
Rule Growth Report
─────────────────
2026-03-15: 8 rules, 145 lines
2026-03-18: 10 rules, 178 lines  (↑ 2 rules, +33 lines)
2026-03-20: 10 rules, 165 lines  (→ stable, -13 lines via cleanup)

Drift Warning: None. System healthy.
Recommendation: Rule 5 (200-line limit) next trigger at ~12 rules.
```

Run `scripts/stats.sh --drift-check` to validate anti-drift compliance.
