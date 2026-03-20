# Claude Wrap-Up: Project Context

This document provides context about the claude-wrap-up skill to Claude AI when working in this repository.

---

## Project Identity

**Name:** Claude Wrap-Up
**Version:** 1.0.0
**Purpose:** Session reflection with structured analysis and recursive skill hardening
**Author:** Stephan ([@unfassbarstephan](https://github.com/unfassbarstephan))
**License:** MIT

---

## Core Concepts

### 5-Phase Session Model

Each `/wrap-up` runs through these phases sequentially:

- **Phase 0 SETUP:** Check/create infrastructure (CLAUDE.md, .claude/ directories)
- **Phase 0.5 MODE DETECTION:** Determine GENESIS, HARDENING, or MIXED mode
- **Phase 1 CAPTURE:** Extract signals from session transcript (11 signal types)
- **Phase 2 CLASSIFY:** Assign confidence — HIGH, MEDIUM, or LOW
- **Phase 3 ROUTE:** Determine storage target (CLAUDE.md, .claude/rules/, session file)
- **Phase 4 PROPOSE:** Present evidence-based recommendations, await user confirmation
- **Phase 5 COMMIT:** Apply approved changes, create session reflection, optional git commit

### Confidence Classification (not phases)

- **HIGH:** Explicit correction or ≥2 occurrences → Proposed as rule
- **MEDIUM:** Implicit pattern or single correction → Documented in session file
- **LOW:** Single observation → Only documented

### Operational Modes

**GENESIS:** Detects recurring workflows without an existing skill. Recommends skill creation via /skill-creator when patterns emerge.

**HARDENING:** Analyzes performance of skills used in the session across 6 dimensions (Completeness, Correctness, Trigger Quality, Efficiency, User Corrections, Edge Cases). Generates SKILL.md patches.

### 7 Anti-Drift Rules

1. **Evidence Requirement** — No rule without documented trigger
2. **Repetition Threshold** — Single observations don't become rules (≥2 for HIGH)
3. **Generalization Test** — Task-specific rules go to .claude/rules/, not CLAUDE.md
4. **Contradiction Check** — New rules checked against existing ones
5. **200-Line Limit** — CLAUDE.md must stay ≤200 lines
6. **Expiration Date** — Stale rules flagged during /wrap-up-review
7. **Counterexample Check** — HIGH rules tested for legitimate exceptions

---

## Slash Commands

| Command | Action |
|---------|--------|
| `/wrap-up` | Full session analysis |
| `/wrap-up-on` | Enable auto wrap-up (Stop hook) |
| `/wrap-up-off` | Disable auto wrap-up |
| `/wrap-up-status` | Show configuration and stats |
| `/wrap-up-review` | Periodic multi-session review |
| `/wrap-up-stats` | Show learning statistics |

---

## File Structure

The skill installs to `~/.claude/skills/wrap-up/`. Project-level memory uses:

```
project/
├── CLAUDE.md                    ← Global rules (≤200 lines)
├── CLAUDE.local.md              ← Private notes
├── .claude/
│   ├── rules/                   ← Domain-specific rules
│   │   └── [domain].md
│   └── sessions/                ← Session reflections
│       └── YYYY-MM-DD-[topic].md
```

---

## Design Principles

1. **One skill, not five** — User runs one command: /wrap-up
2. **Analysis is read-only** — Changes only after user confirmation
3. **No external dependencies** — Works via Markdown and Claude's native abilities. Python scripts are optional CLI accelerators.
4. **Platform-agnostic** — Same skill works in CLI, Cowork, and Web-UI
5. **CLAUDE.md stays lean** — ≤200 lines, domain rules in .claude/rules/

---

## Last Updated

2026-03-20 — Initial v1.0.0 release
