# Memory Hierarchy: Storage Targets and Formats

This document describes the three storage levels, their formats, and conventions.

---

## File Structure Overview

```
project/
├── CLAUDE.md                          ← Router + global rules (≤200 lines)
├── CLAUDE.local.md                    ← Private notes (do not commit)
├── .claude/
│   ├── rules/
│   │   ├── style-preferences.md       ← Communication and code style
│   │   ├── project-conventions.md     ← Project-specific conventions
│   │   ├── anti-patterns.md           ← What Claude should NOT do
│   │   └── [domain].md               ← Domain-specific (n8n, shopify, etc.)
│   └── sessions/
│       └── YYYY-MM-DD-<slug>.md       ← Session reflections
```

---

## Level 1: CLAUDE.md — The Router (≤200 lines)

CLAUDE.md is the central configuration file that Claude automatically loads at the start of each session. It must remain short and clear — maximum 200 lines.

### Template for Initialization (Phase 0)

```markdown
# CLAUDE.md

## Identity
- Language: [English/German/...]
- Tone: [Professional/Casual/...]

## Critical Rules
<!-- Only HIGH-confidence, explicitly confirmed. Filled by /wrap-up. -->

## Domain Rules
For project-specific details see:
- @import .claude/rules/style-preferences.md
- @import .claude/rules/project-conventions.md

## Avoid
<!-- Errors that should NEVER repeat -->

## Last Updated
[Date] — via /wrap-up
```

### What belongs in CLAUDE.md:
- Global rules that apply in ALL contexts
- Language preference, communication style
- The most important "never" rules
- @import references to domain-specific rules

### What does NOT belong in CLAUDE.md:
- Domain-specific details (→ .claude/rules/)
- Temporary information (→ CLAUDE.local.md)
- Session-specific notes (→ .claude/sessions/)

---

## Level 2: .claude/rules/ — The Experts

Each rule file covers a domain or topic. They are automatically loaded by Claude when the `paths` frontmatter matches the current context, or when CLAUDE.md references them via @import.

### File Naming Convention
- **kebab-case** by domain: `n8n-workflows.md`, `shopify-theme.md`, `code-style.md`, `api-conventions.md`
- **Fixed names for standard topics:**
  - Style preferences → `style-preferences.md`
  - Anti-patterns → `anti-patterns.md`
  - Project conventions → `project-conventions.md`
- If unclear: ask the user for the desired file name

### Format for Rule Files

```markdown
---
paths: "src/workflows/**"  # Optional: Scope to specific file paths
---

# [Domain] Conventions

## Rules (HIGH Confidence)

### [Rule Name]
- Source: Session [YYYY-MM-DD], [what happened]
- Rule: [The rule text]
- Counterexample checked: [Yes/No] ([Describe exception])

## Best Practices (MEDIUM Confidence)
- [Observation not yet solidified into a rule]
```

### Conflict Resolution (Priority Rule)

If a rule in `.claude/rules/` contradicts a rule in `CLAUDE.md`:
**The more specific rule wins.**
`.claude/rules/shopify.md` overrides `CLAUDE.md` for Shopify context.
`CLAUDE.md` serves as fallback for everything not covered by more specific files.

---

## Level 3: .claude/sessions/ — The Archive

Session files document each wrap-up reflection. They serve as historical archive and data basis for MEDIUM→HIGH promotions and GENESIS detection.

### File Naming Convention
- Format: `YYYY-MM-DD-[slug].md`
- Slug: First 2-3 words of main topic in kebab-case
- Example: `2026-03-20-checkout-optimization.md`
- If a file for today exists: Add suffix (`-2`, `-3`)

### Format for Session Files

```markdown
# Session Reflection: [Topic]
**Date:** [YYYY-MM-DD]
**Duration:** ~[X] minutes
**Context:** [Brief description of work]
**Mode:** [GENESIS/HARDENING/MIXED]

## Summary
[2-3 sentences: What was done in the session?]

## Findings

### HIGH (→ Rules created)
1. [Description] — Rule written to [Target file]

### MEDIUM (→ Observed)
2. [Description]

### LOW (→ Only documented)
3. [Description]

## What worked well
- [Point 1]
- [Point 2]

## What didn't work
- [Point 1]
- [Point 2]

## Session Protocol
[See templates/session-protocol.md for format]
```

---

## CLAUDE.local.md — Private and Ephemeral

For information that should NOT be committed or shared:
- Current sprint focus
- Temporary credentials (though real secrets should NOT be stored here)
- Personal notes and preferences

This file is not actively filled by wrap-up, but offered as a routing target when an insight is private/ephemeral.

---

## Git Integration

All files in `.claude/` and CLAUDE.md are version-controlled. Session files create an auditable history:

```bash
# See rule evolution
git log --oneline .claude/rules/

# Diff a specific domain's rules
git diff .claude/rules/shopify-theme.md

# Archive old sessions
git mv .claude/sessions/2025-*.md archive/sessions/
```

The wrap-up skill automatically commits rule changes with message: `"wrap-up: [YYYY-MM-DD] - [summary of changes]"`.
