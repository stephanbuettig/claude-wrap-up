# /wrap-up-on

Enable auto wrap-up at session end via Stop hook.

## Description

Enables automatic wrap-up execution when a session ends. Once enabled, wrap-up will run automatically at the Stop hook (CLI) instead of requiring manual `/wrap-up` invocation.

## Usage

```
/wrap-up-on
```

## Output

Returns confirmation:

```
✓ Auto wrap-up enabled
├─ Mode: GENESIS (learn from new patterns) or HARDENING (refine active skills)
├─ State file: .state/auto-wrapup.json
└─ Ready: Next session end will trigger automatic analysis
```

## Behavior

- **CLI-exclusive:** Executes `scripts/toggle-on.sh` to enable the Stop hook
- **State storage:** Writes to `.state/auto-wrapup.json`
- **First run:** Creates `.state/` directory if needed
- **Idempotent:** Safe to run multiple times
- **Mode detection:** Automatically chooses GENESIS or HARDENING based on session content

## Related Commands

- `/wrap-up` — Trigger manual wrap-up analysis
- `/wrap-up-off` — Disable auto wrap-up
- `/wrap-up-status` — Check if auto wrap-up is enabled

## See Also

- [../../README.md](../../README.md) — Feature overview
- [../../SKILL.md](../../SKILL.md) — Wrap-up system architecture
