# /wrap-up-stats

Show learning statistics across all sessions.

## Description

Displays aggregated metrics across all wrap-up sessions: total sessions processed, rule counts by confidence level, skill patches applied, and CLAUDE.md health.

CLI-exclusive feature. Useful for understanding system evolution over time.

## Usage

```
/wrap-up-stats
```

## Output Example

```
Wrap-Up Statistics
══════════════════

Sessions processed:       47
First session:            2026-02-15
Latest session:           2026-03-20
Active days:              34

Rules by Confidence:
  HIGH:                   8 rules (CLAUDE.md + .claude/rules/)
  MEDIUM:                 5 rules (in session files, awaiting repetition)
  LOW:                    3 rules (noted only)

Skill Patches Applied:    3 skills
CLAUDE.md:                165 lines (OK)
Git commits:              23

Trends (Last 7 days):
  New signals:            6
  Rules to HIGH:          1
  Drift events:           0
```

## Output Fields

| Field | Meaning |
|-------|---------|
| Sessions processed | Total wrap-up analyses run |
| First/Latest session | Date range of activity |
| Rules (HIGH/MEDIUM/LOW) | Confidence distribution from Phase 2 |
| Skill patches applied | Count of skills updated |
| CLAUDE.md | Current line count and status |
| Git commits | Number of wrap-up commits (if repo available) |
| Trends | Recent signal and rule activity |

## Behavior

- **CLI-exclusive:** Executes `scripts/stats.sh`
- **Read-only:** No state changes
- **Quick output:** Simple tabular format, no huge charts
- **Drift check:** Include alert if Rule 5 (200-line limit) is near threshold

## Related Commands

- `/wrap-up` — Trigger analysis
- `/wrap-up-status` — Configuration check
- `/wrap-up-review` — Multi-session analysis and drift audit

## See Also

- [../../README.md](../../README.md) — Feature overview
- [../../references/anti-drift-rules.md](../../references/anti-drift-rules.md) — Drift prevention mechanisms
