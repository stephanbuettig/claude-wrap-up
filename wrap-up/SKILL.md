---
name: wrap-up
description: >
  Session wrap-up with structured reflection and recursive skill hardening. Analyzes
  conversation transcripts for errors, corrections, insights, and style preferences.
  Two modes: GENESIS (detects skill potential from recurring workflows) and HARDENING
  (improves only skills actively loaded in the current session). Creates evidence-based
  proposals for CLAUDE.md, .claude/rules/, and SKILL.md files. Packages patched skills
  as installable .skill files. Trigger on: /wrap-up, wrap up, wrap-up, session beenden,
  sitzung abschließen, was haben wir gelernt, session zusammenfassen, close session,
  end session, wrap things up, reflektiere, was lief gut, was können wir verbessern,
  Feierabend, fertig für heute, das wars, Schluss, save progress, skill verbessern,
  härten, harden skills, session review, learnings sichern, was lief schief. Also:
  /wrap-up-on, /wrap-up-off, /wrap-up-status, /wrap-up-review, /wrap-up-stats.
---

# Wrap-Up — Session Reflection & Recursive Self-Improvement

## Language Parity Rule

All internal skill instructions are in English for optimal LLM comprehension.
**Always respond to the user in the language they use.** German user → German output.
English user → English output. Technical terms (skill, wrap-up, commit, HARDENING,
GENESIS) may stay in English regardless.

---

## Core Philosophy

Achieve cumulative results better than 99.9999% of all outcomes through systematic
reflection after every session. Not through a single brilliant run, but through hundreds
of small improvements across many sessions.

### The 7 Credos

> **I.** Perfection arises exclusively through self-reflection followed by improvement.
> **II.** Every error is a gift — but only when converted into a rule. "Correct once, never again."
> **III.** Skills are living organisms. A skill that is never improved is a dead skill.
> **IV.** Top 0.0001% quality is achieved through hundreds of small improvements.
> **V.** What isn't persisted doesn't exist.
> **VI.** Governance protects against degeneration. Every rule needs evidence and human approval.
> **VII.** The best skill is one you don't notice — because it delivers exactly right on the first try.

---

## Slash Commands

| Command | Action |
|---------|--------|
| `/wrap-up` | Run full wrap-up analysis on current session |
| `/wrap-up-on` | Enable auto-wrap-up at session end via Stop hook |
| `/wrap-up-off` | Disable auto-wrap-up |
| `/wrap-up-status` | Show current configuration and stats |
| `/wrap-up-review` | Periodic review of all rules and skill health |
| `/wrap-up-stats` | Show learning statistics across sessions |

### Toggle Commands (CLI-exclusive)

When the user runs `/wrap-up-on`:
→ Execute `scripts/toggle-on.sh` to enable the Stop hook.

When the user runs `/wrap-up-off`:
→ Execute `scripts/toggle-off.sh` to disable the Stop hook.

When the user runs `/wrap-up-status`:
→ Execute `scripts/toggle-status.sh` to show current state.

When the user runs `/wrap-up-stats`:
→ Execute `scripts/stats.sh` to show learning statistics.

---

## Skill Architecture & References

This skill bundle contains specialized reference documents and templates.
Load them by phase:

| Phase / Task | Load this file |
|-------------|---------------|
| Phase 1 CAPTURE: Detect signals | `references/signal-patterns.md` |
| Phase 3 ROUTE: Anti-drift checks | `references/anti-drift-rules.md` |
| Phase 3 ROUTE: Storage targets | `references/memory-hierarchy.md` |
| Phase 4 PROPOSE: Format report | `templates/wrap-up-report.md` |
| Phase 5 COMMIT: Session protocol | `templates/session-protocol.md` |

---

## Phase 0: SETUP (once on first invocation)

Check whether the required infrastructure exists. If not, create it:

1. **CLAUDE.md** in the project directory? If not → Create minimal version.
   Load `references/memory-hierarchy.md` for the exact template.
2. **`.claude/rules/`** directory? If not → Create it.
3. **`.claude/sessions/`** directory? If not → Create it.

**CLI-exclusive:** Also check:
4. Is Git initialized in the project? If yes → Enable git-commit in Phase 5.
5. Are the wrap-up scripts executable? If not → Run `chmod +x scripts/*.sh scripts/*.py`.

If no filesystem operations are possible (Web-UI), skip Phase 0 and work text-based.

---

## Phase 0.5: MODE DETECTION

Determine the operating mode. This is the most critical branching decision:

**Check: Were any skills activated or referenced in this session?**

- **YES → Mode HARDENING** (Recursive Skill Perfection)
  Create a list of all skills that were actually loaded and used.
  **Scope Rule: Only session-active skills are analyzed and patched.
  Installed but unused skills are NOT considered.**
  Note: Which skills were activated? At which moments?
  Where did Claude deviate from skill behavior? Why?

- **NO → Mode GENESIS** (Potential Skill Creation)
  Note: Which workflow type dominated?
  Were there recurring patterns a skill could codify?

- **BOTH → Mode MIXED**
  Parts used skills (→ HARDENING for those),
  other parts were skill-free (→ check GENESIS).

**Important:** A skill is only "activated" if Claude loaded a SKILL.md and followed its
instructions. Merely touching a topic for which a skill exists is not enough.

---

## Phase 1: CAPTURE

Scan the entire conversation history.
For each signal, extract exact context (who said what, situation, result).

→ **Load `references/signal-patterns.md`** for full signal type list.

### Signal Types (all modes):
1. **Corrections** — User explicitly contradicts or corrects
2. **Repetitions** — Repeatedly explained fact or recurring error
3. **Preferences** — Style, format, language, depth
4. **Successes** — Explicit praise or confirmation
5. **Insights** — New domain knowledge

### Additional in HARDENING (Signals 6-9):
6. Skill Deviations — Where did Claude deviate from the skill?
7. Skill Corrections — User corrections to skill output
8. Trigger Quality — Was the skill activated correctly/on time?
9. Missing Coverage — Situations the skill didn't cover

### Additional in GENESIS (Signals 10-11):
10. Workflow Patterns — Recurring structured approaches
11. Codifiable Rules — Ad-hoc decisions as skill instructions

**CLI-exclusive (optional):** If `scripts/extract_signals.py` is available and
Python 3 is installed, run it for automated signal pre-extraction from the
transcript. Use results as starting point and verify manually.
The system works fully without this script — it is a convenience accelerator.

If no notable signals: say "No notable learnings in this session" and stop.

---

## Phase 2: CLASSIFY

Assign each signal a confidence level:

- **HIGH** — Explicit correction or repeated error (≥2 times).
  In HARDENING: Skill instruction demonstrably led to incorrect result.
  → Proposed as rule candidate.

- **MEDIUM** — Implicit pattern or one-time correction without generalizability.
  → Documented in session file, becomes HIGH on repetition.

- **LOW** — Single observation without clear generalizability.
  → Only documented in session file.

---

## Phase 3: ROUTE

Determine the storage target for each HIGH signal:

- **Global?** → CLAUDE.md (Example: language preference)
- **Domain-specific?** → `.claude/rules/[domain].md` (Example: n8n conventions)
- **Private/ephemeral?** → CLAUDE.local.md (Example: sprint focus)
- **Skill-specific?** (HARDENING only) → Patch for the affected skill's SKILL.md.
  Only for skills actually activated in this session (Phase 0.5 Scope Rule).
- **Not generalizable yet?** → Session file only

→ **Load `references/anti-drift-rules.md`** and apply all 7 anti-drift checks.
→ **Load `references/memory-hierarchy.md`** for file naming conventions.

---

## Phase 4: PROPOSE

Present a compact overview of all findings.

→ **Load `templates/wrap-up-report.md`** for the exact output format.

### Short format:

**Wrap-Up Report — [Date] | Mode: [GENESIS/HARDENING/MIXED]**

- 🔴 HIGH findings with target file, rule text, evidence
- 🟡 MEDIUM findings documented in session file
- 🟢 LOW findings noted only
- **HARDENING:** Skill performance table (6 dimensions) + OLD→NEW patches
- **GENESIS:** Skill potential analysis with core rules.
  If skill potential detected, ask: "Should I invoke /skill-creator?"
  **The Wrap-Up does NOT create skills.** It recommends /skill-creator.

**Governance Rule (Credo VI):** Ask: "Should the proposed changes be applied?"
Apply NOTHING before user confirms.

---

## Phase 5: COMMIT

After user confirmation:

1. **Update target files** — Write approved rules (rule text, source, date).

2. **Apply skill patches** (HARDENING only) — OLD→NEW changes exclusively on
   SKILL.md files of session-active skills. Check: stays under 500 lines?
   On error: output patch as copyable text block.

3. **Package patched skills as .skill file** (HARDENING only, after step 2) —
   For EACH patched skill:
   a. Copy complete skill directory (SKILL.md + subdirectories) to temp.
   b. Ensure all patches from step 2 are applied.
   c. Create ZIP archive as `.skill` file. Root folder = skill name in kebab-case.
   d. Save to workspace and present with `computer://` link (Cowork) or file path (CLI).
   e. Message: "✅ Updated skill `[name]` provided as installable .skill file."
   On error: output patch as text and inform user.

4. **Create session file** at `.claude/sessions/YYYY-MM-DD-[topic].md`

5. **Insert session protocol** → Load `templates/session-protocol.md`.

6. **CLAUDE.md health check** — If >200 lines: suggest extraction.

7. **Git commit** (only if Git available):
   **CLI-exclusive:** Run `scripts/git-commit.sh` for automated commit with
   structured message. Falls back to manual `git commit` if script unavailable.
   Message format: `wrap-up: [short description]`

8. **Update stats** (CLI-exclusive):
   Run `scripts/update-stats.sh` to increment session counters.

9. **Final report:**

   ✅ Wrap-Up complete. [Mode: GENESIS/HARDENING/MIXED]
   - X rule(s) written to [files]
   - [HARDENING:] X skill patch(es) on [skill names] → .skill file(s) provided
   - [GENESIS:] Skill potential: [detected/not detected]
   - Session reflection at [path]
   - CLAUDE.md: [X] lines [OK / Warning]

   Remember Credo IV: "Every session with Wrap-Up brings the system closer
   to its theoretical ceiling."

---

## Environment Adaptation

- **CLI (Claude Code):** Full power. Hooks, scripts, git integration, auto-wrap-up.
  Scripts execute directly. Transcript analysis via `extract_signals.py`.
- **Cowork:** Filesystem access. Skills patched and packaged as .skill files.
  Use `computer://` links. No hooks, but manual `/wrap-up` works.
- **Web-UI:** Text-only mode. Everything as copyable Markdown. No file operations.

## Error Handling

- File write error: Report, offer rule as text, continue.
- CLAUDE.md corrupted: Suggest backup (`git checkout CLAUDE.md`).
- Skill file not found (HARDENING): Patch as text, ask for path.
- User cancels: Still create session file with "Cancelled" note.
- Script failure: Fall back to manual execution, log error.

## Periodic Review (`/wrap-up-review`)

Trigger: "review my rules", "what have we learned", "wrap-up review"

1. Load all rules from CLAUDE.md and .claude/rules/
2. Review session archive
3. Unused rules → Deletion candidates
4. Contradictions → Resolution proposal
5. Check CLAUDE.md length
6. Skill health: Evaluate session protocols (trend better/same/worse)
7. GENESIS retrospective: Recurring workflows without a skill?
8. Review report with concrete recommendations

**CLI-exclusive:** Run `scripts/stats.sh` to show quantitative trends.
