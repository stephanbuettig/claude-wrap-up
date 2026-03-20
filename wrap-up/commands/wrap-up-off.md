# /wrap-up-off

Disable auto wrap-up at session end.

## Description

Disables automatic wrap-up execution at session end. Manual `/wrap-up` calls will still work, but the Stop hook will not trigger automatic analysis.

## Usage

```
/wrap-up-off
```

## Output

Returns confirmation:

```
✗ Auto wrap-up disabled
├─ State file: .state/auto-wrapup.json (updated)
├─ Manual /wrap-up: Still available
└─ To re-enable: /wrap-up-on
```

## Behavior

- **CLI-exclusive:** Executes `scripts/toggle-off.sh` to disable the Stop hook
- **Preserves state:** All rules, sessions, and CLAUDE.md remain intact
- **Manual analysis:** Users can still run `/wrap-up` explicitly to analyze a session
- **Idempotent:** Safe to run multiple times

## Use Cases

- Temporarily disable during debugging
- Disable in high-volume or confidential sessions
- Pause auto-analysis while making large changes

## Related Commands

- `/wrap-up-on` — Re-enable auto wrap-up
- `/wrap-up` — Trigger manual analysis
- `/wrap-up-status` — Check current state

## See Also

- [../../README.md](../../README.md) — Feature overview
- [../../SKILL.md](../../SKILL.md) — Wrap-up system architecture
