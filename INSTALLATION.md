# Wrap-Up Skill — Installation Guide

Complete setup instructions for the Claude Wrap-Up skill.

---

## Prerequisites

**Required:**
- **Claude Code CLI** installed and functional

**Optional (for extended functionality):**
- **Python 3.8+** (for automated signal extraction via `extract_signals.py`)
- **Git 2.0+** (for automated commit integration)
- **Bash 4.0+** (for shell scripts)

### Verify Prerequisites

```bash
claude --version          # Claude Code CLI (required)
python3 --version        # Python 3.8+ (optional)
git --version            # Git 2.0+ (optional)
bash --version           # Bash 4.0+ (optional)
```

---

## Quick Install

```bash
git clone https://github.com/unfassbarstephan/claude-wrap-up.git
cd claude-wrap-up
bash setup
```

The setup script will:
- Install the skill to `~/.claude/skills/wrap-up/`
- Make all scripts executable
- Initialize state files (auto-wrapup.json, stats.json)
- Optionally configure the Stop hook for auto wrap-up

**Time:** ~20 seconds

---

## What Gets Installed

After running `bash setup`, the skill installs to `~/.claude/skills/wrap-up/`:

```
~/.claude/skills/wrap-up/
├── SKILL.md                    # Skill definition and phases
├── references/
│   ├── signal-patterns.md      # Signal type definitions
│   ├── anti-drift-rules.md     # Validation checks
│   └── memory-hierarchy.md     # File organization rules
├── templates/
│   ├── wrap-up-report.md       # Output format template
│   └── session-protocol.md     # Session documentation template
├── scripts/
│   ├── extract_signals.py      # Automated signal extraction (optional)
│   ├── hook-stop.sh            # Stop hook for auto wrap-up
│   ├── git-commit.sh           # Automated git commit wrapper
│   ├── stats.sh                # Show statistics
│   ├── update-stats.sh         # Update statistics
│   ├── toggle-on.sh            # Enable auto wrap-up
│   ├── toggle-off.sh           # Disable auto wrap-up
│   └── toggle-status.sh        # Show current state
├── commands/
│   └── [command definitions]   # Slash command files
└── .state/
    ├── auto-wrapup.json        # Hook state
    └── stats.json              # Learning statistics
```

Project-level memory hierarchy (created on first `/wrap-up` in a project):
```
PROJECT_ROOT/
├── CLAUDE.md                   # Global rules and preferences
└── .claude/
    ├── rules/                  # Domain-specific rules
    │   └── [domain].md
    ├── sessions/               # Session reflections
    │   └── YYYY-MM-DD-[topic].md
    └── [other Claude CLI files]
```

---

## Slash Commands

| Command | Purpose |
|---------|---------|
| `/wrap-up` | Run full session wrap-up analysis |
| `/wrap-up-on` | Enable auto wrap-up at session end (Stop hook) |
| `/wrap-up-off` | Disable auto wrap-up |
| `/wrap-up-status` | Show current configuration and stats |
| `/wrap-up-review` | Periodic review of all rules and skill health |
| `/wrap-up-stats` | Show learning statistics across sessions |

---

## Stop Hook Configuration

To enable **automatic wrap-up when sessions end**, the setup script offers to configure the Stop hook.

If you chose "yes" during setup, you'll need to manually edit `~/.claude/settings.local.json`.

> **Note:** The exact hook format depends on your Claude CLI version. Check `claude --help` or the [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code) for the current hook specification. A common format:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/skills/wrap-up/scripts/hook-stop.sh"
          }
        ]
      }
    ]
  }
}
```

After editing, **restart the Claude CLI** for the hook to take effect.

To configure it later:
```bash
~/.claude/skills/wrap-up/scripts/toggle-on.sh
```

---

## First Run

```bash
# Verify installation succeeded
/wrap-up-status

# Expected: shows enabled/disabled state and session count

# Run a test wrap-up
/wrap-up

# View statistics
/wrap-up-stats
```

---

## Git Integration (Optional)

If your project uses Git, the wrap-up skill can automatically create commits from learned rules.

```bash
# Enable git commits during wrap-up
~/.claude/skills/wrap-up/scripts/toggle-on.sh

# Or configure manually in the Stop hook
```

After wrap-up analysis, rules are committed with message format:
```
wrap-up: [short description of learned rules]
```

---

## Troubleshooting

### Commands Not Registered

**Symptom:** `/wrap-up` returns "command not found"

**Solution:**
```bash
# Reinstall or verify the skill directory exists
ls -la ~/.claude/skills/wrap-up/SKILL.md

# If missing, run setup again from the cloned repository
bash setup
```

### Permission Denied on Scripts

**Symptom:** `Permission denied` when running shell scripts

**Solution:**
```bash
chmod +x ~/.claude/skills/wrap-up/scripts/*.sh
chmod +x ~/.claude/skills/wrap-up/scripts/*.py
```

### Stop Hook Not Triggering

**Symptom:** Auto wrap-up doesn't run when session ends

**Solution:**
```bash
# 1. Verify hook configuration
cat ~/.claude/settings.local.json | grep -A 2 '"hooks"'

# 2. Check hook script is executable
ls -la ~/.claude/skills/wrap-up/scripts/hook-stop.sh

# 3. Verify hook path is correct (use ~ or full /home/username path)
# Then restart Claude CLI

# 4. Test manually
bash ~/.claude/skills/wrap-up/scripts/hook-stop.sh
```

### Python Module Not Found

**Symptom:** Signal extraction fails with "ModuleNotFoundError"

**Solution:** The `extract_signals.py` script is optional. It requires no additional Python packages. If it fails, the wrap-up skill continues without automated extraction.

### State Files Permission Error

**Symptom:** `PermissionError` when updating stats or state

**Solution:**
```bash
# Fix directory permissions
chmod -R u+w ~/.claude/skills/wrap-up/.state/
```

---

## Uninstallation

### Remove Completely

```bash
# 1. Disable auto wrap-up
~/.claude/skills/wrap-up/scripts/toggle-off.sh

# 2. Remove the skill directory
rm -rf ~/.claude/skills/wrap-up/

# 3. Remove Hook configuration from ~/.claude/settings.local.json
# (manually delete the "hooks" section)

# 4. Remove cloned repository
cd ..
rm -rf claude-wrap-up/
```

### Keep Rules, Remove Skill

To preserve learned rules while removing the skill:

```bash
# Backup project rules before uninstalling
cp -r PROJECT_ROOT/CLAUDE.md PROJECT_ROOT/.claude ~/wrap-up-backup/

# Remove the skill
rm -rf ~/.claude/skills/wrap-up/

# Later, restore rules to a new project or re-install the skill
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Install | `bash setup` |
| Enable auto wrap-up | `/wrap-up-on` |
| Disable auto wrap-up | `/wrap-up-off` |
| Run wrap-up | `/wrap-up` |
| Check status | `/wrap-up-status` |
| View statistics | `/wrap-up-stats` |
| Review all rules | `/wrap-up-review` |

---

**Need help?** Open an issue: [github.com/unfassbarstephan/claude-wrap-up/issues](https://github.com/unfassbarstephan/claude-wrap-up/issues)
