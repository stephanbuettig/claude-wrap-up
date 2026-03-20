# /wrap-up-status

Show current wrap-up configuration and statistics.

## Description

Returns the current state of the wrap-up system: enabled/disabled, auto-wrap-up mode, rule counts by confidence level, and CLAUDE.md health.

No analysis is performed; this is a quick read-only status check.

## Usage

```
/wrap-up-status
```

## Output Example

```
✓ Wrap-Up Status

Auto wrap-up:         ENABLED
Mode:                 HARDENING
Last analysis:        2026-03-20 18:45

Rules Summary:
  HIGH:               8 rules
  MEDIUM:             5 rules
  LOW:                3 rules

CLAUDE.md:            165 lines (OK)
Session files:        12 stored
Skills patched:       3

State file:           .state/auto-wrapup.json
```

## Output Fields

| Field | Meaning |
|-------|---------|
| Auto wrap-up | ENABLED / DISABLED |
| Mode | GENESIS (new patterns) / HARDENING (refine active skills) |
| Last analysis | Timestamp of previous `/wrap-up` |
| Rules (HIGH/MEDIUM/LOW) | Confidence levels from Phase 2 CLASSIFY |
| CLAUDE.md | Current line count and health status |
| Session files | Total stored session reflections |
| Skills patched | Number of skills updated via wrap-up |

## Behavior

- **No side effects:** Read-only, no state changes
- **CLI-exclusive:** Executes `scripts/toggle-status.sh`
- **Quick execution:** Returns immediately
- **Health check:** Validates `.state/auto-wrapup.json` is readable

## Related Commands

- `/wrap-up` — Trigger manual analysis
- `/wrap-up-on` — Enable auto wrap-up
- `/wrap-up-off` — Disable auto wrap-up
- `/wrap-up-stats` — Lifetime statistics

## See Also

- [../../README.md](../../README.md) — Feature overview
- [../../SKILL.md](../../SKILL.md) — System architecture
