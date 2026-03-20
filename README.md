# Claude Wrap-Up — Session Reflection & Recursive Self-Improvement

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Built%20for-Claude%20Code-3451ff.svg)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A Claude Code skill that automatically captures session learnings, detects behavioral patterns, and hardens rules—turning reactive notes into a living system of domain-specific protocols. **No manual review boards. No stale playbooks. Just signals, confidence classification, and drift detection.**

---

## The Problem

You finish a productive Claude session. You learned something important. You write it down in a random document. Three weeks later, another session goes sideways in *exactly the same way*—and you've forgotten the fix.

Or worse: You created a "best practice" six months ago. It worked perfectly then. Now your environment changed, but the rule is still enforced as truth. You're flying blind with outdated protocols.

**This is the drift problem.** Manual notes decay. Playbooks ossify. Tribal knowledge disappears.

## The Solution

**Claude Wrap-Up** is a persistent, self-aware session framework that:

- **Captures signals** automatically at session end (errors, false starts, pattern detections)
- **Classifies confidence** from raw observations → LOW → MEDIUM → HIGH with explicit promotion gates
- **Detects drift** by testing rules against live system state—not static documentation
- **Hardens** by recursively refining signal patterns and adding anti-drift checks
- **Survives** in version-controlled rules files, checkable by future sessions

Think of it as a **living feedback loop** between Claude, your codebase, and your practices. Every session makes the next one smarter.

---

## Quick Start

### Install

```bash
git clone https://github.com/unfassbarstephan/claude-wrap-up.git
cd claude-wrap-up
bash setup
```

### Enable

```bash
/wrap-up-on
```

### At Session End

```bash
/wrap-up
```

Your session learnings are now captured, analyzed, and (if confident enough) merged into your living rule system.

---

## Features

### The 5-Phase Wrap-Up Process

Each `/wrap-up` runs through 5 sequential phases:

```
Phase 0: SETUP
    └─ Check or initialize infrastructure (CLAUDE.md, .claude/ directories)

Phase 0.5: MODE DETECTION
    └─ Determine: GENESIS (new workflows) or HARDENING (improving existing skills)?

Phase 1: CAPTURE
    └─ Extract all signal types from the session transcript
       (Corrections, Repetitions, Preferences, Successes, Insights, etc.)

Phase 2: CLASSIFY
    └─ Assign confidence levels:
       • HIGH: Explicit correction or ≥2 occurrences
       • MEDIUM: Implicit pattern or one-time correction
       • LOW: Single observation without clear generalizability

Phase 3: ROUTE
    └─ Determine storage target for each HIGH signal:
       • CLAUDE.md (global rules)
       • .claude/rules/[domain].md (domain-specific)
       • CLAUDE.local.md (private)
       • .claude/sessions/ (session-only)

Phase 4: PROPOSE
    └─ Show user compact overview of all findings with evidence

Phase 5: COMMIT
    └─ After user confirmation:
       • Write approved rules to target files
       • Apply skill patches (HARDENING mode)
       • Create session reflection at .claude/sessions/YYYY-MM-DD-[topic].md
       • Git commit (if available)
```

### Two Operational Modes

**GENESIS Mode** (Default)
- Detects recurring workflows without an existing skill
- Recommends skill creation when patterns emerge
- Best for learning new domains, establishing best practices

**HARDENING Mode**
- Analyzes application of existing skills in the session
- Tests skill performance across 6 dimensions:
  - **Completeness:** Did the skill cover all necessary steps?
  - **Correctness:** Did the skill lead to correct results?
  - **Trigger Quality:** Was the skill activated at the right time?
  - **Efficiency:** Were there unnecessary steps?
  - **User Corrections:** Which corrections affected the skill?
  - **Edge Cases:** Which situations weren't covered?
- Generates patches to improve the skill's SKILL.md
- Best for domains with established protocols

---

## Slash Commands

| Command | Action |
|---------|--------|
| `/wrap-up` | Trigger manual session analysis and rule capture |
| `/wrap-up-on` | Enable auto-wrap-up at session end |
| `/wrap-up-off` | Disable auto-wrap-up |
| `/wrap-up-status` | Show current configuration and statistics |
| `/wrap-up-review` | Periodic review of all rules and skill health |
| `/wrap-up-stats` | Show cumulative learning statistics |

---

## 7 Anti-Drift Rules

These hardened principles protect your rule system from decay:

1. **Evidenzpflicht (Evidence Requirement)** — No rule without documented trigger (session, date, context)
2. **Wiederholungsschwelle (Repetition Threshold)** — Single observations don't become rules; require ≥2 occurrences (HIGH) or ≥3 (MEDIUM→HIGH promotion)
3. **Generalisierungstest (Generalization Test)** — Does this rule apply everywhere or only in specific contexts? Task-specific rules go to .claude/rules/, not CLAUDE.md
4. **Widerspruchsprüfung (Contradiction Check)** — Before proposing a new rule, check: Does it conflict with existing rules? Which is newer/better-justified?
5. **200-Zeilen-Limit (200-Line Limit)** — CLAUDE.md is checked on every wrap-up. Exceeding 200 lines triggers extraction recommendation to .claude/rules/
6. **Ablaufdatum (Expiration Date)** — Rules not relevant for extended periods are marked "possibly stale" during periodic `/wrap-up-review`
7. **Gegenbeispiel-Check (Counterexample Check)** — For each HIGH rule: Are there legitimate cases where it shouldn't apply? If yes, phrase as conditional

---

## How It Works

```
┌─ Session Start
│
├─→ Claude operates normally
│   (User query, tool calls, responses)
│
├─→ Signals captured passively
│   • Errors, false starts
│   • Pattern detections
│   • System state observations
│
├─→ Session End → /wrap-up triggered
│
├─→ Analysis Phase (Phases 1–3)
│   ├─ CAPTURE: Extract raw signals
│   ├─ CLASSIFY: Assign confidence (HIGH/MEDIUM/LOW)
│   └─ ROUTE: Determine storage target
│
├─→ Proposal Phase (Phase 4)
│   ├─ Show evidence-based recommendations
│   ├─ Display HARDENING patches (if applicable)
│   └─ Request user confirmation
│
├─→ Commit Phase (Phase 5)
│   ├─ Write rules to CLAUDE.md / .claude/rules/
│   ├─ Apply skill patches (HARDENING mode)
│   ├─ Save session reflection
│   └─ Git commit (if available)
│
└─→ Next Session Benefits
    ├─ Rules loaded into context
    ├─ Known drift scenarios detected proactively
    └─ Recursive hardening applied to skills
```

---

## Architecture

### File Structure

```
project/
├── CLAUDE.md                          ← Global rules (≤200 lines)
├── CLAUDE.local.md                    ← Private notes (don't commit)
├── .claude/
│   ├── rules/
│   │   ├── style-preferences.md
│   │   ├── project-conventions.md
│   │   └── [domain].md               ← Domain-specific (e.g., n8n.md)
│   └── sessions/
│       └── YYYY-MM-DD-[topic].md     ← Session reflections
```

### Signal Types

**Core signals (all modes):**
1. **Corrections** — User explicitly contradicts or corrects
2. **Repetitions** — Repeatedly explained fact or recurring error
3. **Preferences** — Style, format, language, depth
4. **Successes** — Explicit praise or confirmation
5. **Insights** — New domain knowledge

**Additional in HARDENING:**
6. **Skill Deviations** — Where did Claude deviate from the skill?
7. **Skill Corrections** — User corrections to skill output
8. **Trigger Quality** — Was the skill activated correctly?
9. **Missing Coverage** — Situations the skill didn't handle

**Additional in GENESIS:**
10. **Workflow Patterns** — Recurring structured approaches
11. **Codifiable Rules** — Ad-hoc decisions as skill instructions

---

## Example Session Walkthrough

### Scenario: Merchant Center Feed Optimization

**Session Start:** User works on MC feed validation.

**During Session:**
- Tries to apply a rule from old playbook → fails (system changed)
- Captures error signal: "MC field validation is 1.2x stricter than documented"
- Tests live state: Confirms 3 new required fields
- Makes fix, documents observation

**At /wrap-up:**

```
Wrap-Up Report — 2026-03-20 | Mode: HARDENING

Signals captured: 3

🔴 HIGH — Documentation vs. Live Data Mismatch
   → [CLAUDE.md] Rule: "Always verify MC field requirements against live API before applying old rules"
   Confidence: HIGH | Evidence: Explicit correction + live verification

🟡 MEDIUM — Playbook Assumption Outdated
   → [Session file] Noted for pattern evaluation
   Evidence: Single correction without repeated confirmation

---
Should the proposed changes (1/1 HIGH) be applied?
[Yes] [No] [Edit]
```

**Next Session (Marketing domain):**
- Rules auto-loaded into context
- New safeguard active: "Check live MC state before applying field rules"
- HARDENING mode enabled: Verifies skill quality across all 6 dimensions

---

## Optional Python Accelerator

For CLI users, `scripts/extract_signals.py` provides automated signal pre-extraction from transcripts (optional performance booster). The system works fully without Python—scripts are just convenience tools.

---

## Comparison with Alternatives

| Feature | Claude Wrap-Up | Manual Playbooks |
|---------|---|---|
| Automatic signal capture | ✓ | ✗ |
| Confidence classification | ✓ (HIGH/MEDIUM/LOW) | ✗ |
| Drift detection | ✓ | ✗ |
| Version controlled rules | ✓ | ✓ |
| Recursive skill hardening | ✓ | ✗ |
| 7 anti-drift safeguards | ✓ | Manual |
| Local storage (no cloud) | ✓ | ✓ |

---

## FAQ

**Q: Will wrap-up slow down my sessions?**
A: No. Signal capture is passive. Wrap-up analysis runs once at session end (typically <5 seconds).

**Q: What if a rule is wrong?**
A: Phase it down. Create a timestamped record and trigger review. The confidence system naturally demotes incorrect rules when they fail to prevent errors.

**Q: Can I use this across teams?**
A: Yes. Push your `.claude/rules/` to a shared Git branch. Each team member's session contributes signals; rules mature collectively.

**Q: What about sensitive domain data?**
A: Rules are stored locally and versioned locally. Nothing is sent to Anthropic or cloud services. Git access controls apply.

**Q: How does the 5-phase model work?**
A: Phases 0–5 are sequential steps in a single wrap-up session. Confidence classification (HIGH/MEDIUM/LOW) is orthogonal—it describes signal maturity across sessions. See the SKILL.md for complete phase definitions.

---

## Changelog

### v1.0.1 (2026-03-20)

**Review Fixes**
- Fixed README: Replaced incorrect "5-Phase Confidence Model" with "5-Phase Wrap-Up Process"
- Fixed INSTALLATION.md: Updated Stop Hook JSON format to match Claude CLI specification
- Fixed all documentation to use correct .claude/ directory structure (was ~/.wrap-up/)
- Fixed all references to use correct 7 Anti-Drift Rules from MASTERKONZEPT
- Fixed GENESIS mode description (was: "collects observations" → now: "detects recurring workflows")
- Fixed update-stats.sh: Rewritten in pure Bash (was Python-dependent)
- Fixed hook-stop.sh: Real implementation (was placeholder with `sleep 2`)
- Fixed setup script: Python/Git marked as optional prerequisites
- Fixed all slash command names to match specification
- Fixed example-session.md: Git commit format aligned with actual format
- Removed all invented features (Slack/Discord webhooks, batch analysis, YAML signals)
- Removed all non-existent scripts (init_rules_db.py, verify_install.sh, etc.)

### v1.0.0 (2026-03-20)

**Initial Release**
- Core 5-phase session analysis (SETUP, MODE DETECTION, CAPTURE, CLASSIFY, ROUTE, PROPOSE, COMMIT)
- Confidence-based classification (HIGH/MEDIUM/LOW)
- 7 hardened anti-drift rules
- GENESIS and HARDENING modes
- All slash commands (/wrap-up, /wrap-up-on, /wrap-up-off, /wrap-up-status, /wrap-up-review, /wrap-up-stats)
- .claude/ directory structure for rules and sessions
- Git integration and version control
- Signal pattern extraction
- Drift detection
- Multi-session periodic review
- MIT License

---

## Credits

Built by **Stephan** ([@unfassbarstephan](https://github.com/unfassbarstephan)) with [Claude Code](https://claude.com/claude-code).

Inspired by hard-learned lessons in marketing automation, feed optimization, and the endless battle against documentation drift.

**Tags:** `claude-code`, `productivity`, `session-management`, `confidence-maturation`, `drift-detection`, `self-improvement`, `automation`, `git-native`

---

**License:** MIT • **Repo:** [github.com/unfassbarstephan/claude-wrap-up](https://github.com/unfassbarstephan/claude-wrap-up)
