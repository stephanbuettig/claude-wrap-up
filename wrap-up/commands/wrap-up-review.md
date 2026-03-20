# /wrap-up-review

Periodic review of all rules and skill health.

## Description

Analyzes the last N sessions to identify cross-session patterns, rule health trends, skill performance, and anti-drift mechanism compliance.

Designed to run weekly or on-demand to catch systemic issues and consolidation opportunities.

## Usage

```
/wrap-up-review
```

## Output Sections

**Rule Health Check**
- Total HIGH/MEDIUM/LOW rules in CLAUDE.md and `.claude/rules/`
- Contradictions between rules (if any)
- CLAUDE.md line count (warn if >200)

**Skill Health Per Skill**
- Session protocol trend (better/same/worse)
- Skills advancing vs. regressing
- Patches applied across sessions

**GENESIS Retrospective**
- Workflows appearing 3+ times without a skill
- Recommendation: "Should we create a skill for pattern X?"

**Anti-Drift Compliance**
- Rule 1: Evidence Requirement — All rules have context and date
- Rule 2: Repetition Threshold — HIGH rules only after ≥2 occurrences
- Rule 3: Generalization Test — Domain-specific rules in correct files
- Rule 4: Contradiction Check — No conflicting rules
- Rule 5: 200-Line Limit — CLAUDE.md length status
- Rule 6: Expiration Date — Rules unverified >10 sessions (if applicable)
- Rule 7: Counterexample Check — Rules formulated as conditional where needed

**Summary & Recommendations**
- Consolidation opportunities
- Rules ready for cleanup or archival
- Next priority actions

## Output Example

```
Wrap-Up Review — Last 7 sessions
═════════════════════════════════

RULE HEALTH
─────────────
Total rules: 16 (8 HIGH, 5 MEDIUM, 3 LOW)
CLAUDE.md: 165 lines (OK)
Contradictions: None detected

SKILL HEALTH
─────────────
Skills analyzed: 3 active in sessions
  sachsenpalmen-marketing: STABLE → BETTER
  n8n-workflows: STABLE
  content-ops: STABLE → BETTER

GENESIS RETROSPECTIVE
──────────────────────
Pattern detected: "color_taxonomy_mapping"
  Occurrences: 3 (Sessions 8, 10, 12)
  Recommendation: Consider /skill-creator

ANTI-DRIFT AUDIT (7 rules)
──────────────────────────
✓ Rule 1 (Evidence): All rules documented with source
✓ Rule 2 (Repetition): HIGH rules confirmed ≥2 times
✓ Rule 3 (Generalization): Domain rules correctly placed
✓ Rule 4 (Contradiction): No conflicts detected
✓ Rule 5 (200-Line): CLAUDE.md at 165 lines (16 lines buffer)
✓ Rule 6 (Expiration): All rules verified <10 sessions ago
✓ Rule 7 (Counterexample): 2 rules formulated conditionally

System Status: HEALTHY

RECOMMENDATIONS
────────────────
→ Watch "color_taxonomy_mapping" for skill creation
→ No cleanup needed at this time
```

## Behavior

- **Analysis range:** Last 7 sessions by default
- **No state changes:** Read-only operation
- **CLI-exclusive feature:** Uses `scripts/stats.sh`
- **Rule auditing:** Applies all 7 anti-drift rules from `references/anti-drift-rules.md`

## Related Commands

- `/wrap-up` — Analyze single session
- `/wrap-up-status` — Quick configuration check
- `/wrap-up-stats` — Lifetime statistics

## When to Run

**Weekly (Recommended)**
- Catch drift early
- Monitor skill maturity
- Plan consolidations

**After Drift Event**
- Validate anti-drift mechanisms
- Confirm rules are recovered

**When CLAUDE.md Approaches 200 Lines**
- Plan rules outmigration to `.claude/rules/`

## See Also

- [../../README.md](../../README.md) — Feature overview
- [../../references/anti-drift-rules.md](../../references/anti-drift-rules.md) — The 7 anti-drift rules
- [../../SKILL.md](../../SKILL.md) — Phases and architecture
