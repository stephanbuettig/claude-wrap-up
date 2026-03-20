# Signal Patterns for Phase 1: CAPTURE

This document describes all signal types that the wrap-up extracts from the conversation flow during Phase 1. For each signal, the exact context is documented: Who said what, in what situation, what was the result.

---

## General Signals (all modes)

### Signal 1: Corrections

**What:** The user explicitly corrected or contradicted something.

**Detection Patterns — watch for these formulations:**
- "No, ..." / "That's wrong" / "That's not correct"
- "Not like that, but ..." / "Instead ..."
- "You should actually ..."
- "You should always/never ..."
- "Do it differently" / "Try again"
- "That's not what I meant"
- "I already told you that ..."

**Capture:** Record the exact wording of the correction, what Claude did wrong, and what the correct solution was.

**Confidence Tendency:** HIGH for explicit correction, MEDIUM for indirect reformulation.

---

### Signal 2: Repetitions

**What:** Something had to be explained multiple times, or the same error occurred repeatedly.

**Detection Patterns:**
- "I already told you that ..."
- "Again: ..." / "As already mentioned ..."
- Claude makes the same mistake in round X and round Y
- User explains the same concept/detail for the second time

**Capture:** Record all places where the repetition occurred and why Claude didn't implement it correctly the first time.

**Confidence Tendency:** HIGH — Repetitions are the strongest signal for a missing rule. Credo II: "Correct once, never again."

---

### Signal 3: Preferences

**What:** Style, format, language, depth, structure — both explicitly stated and recognizable through consistent behavior.

**Detection Patterns:**
- "Please answer in English / German"
- "Shorter please" / "More details"
- "Always use tables for comparisons"
- "Always include code examples with comments"
- User formats own messages consistently in a certain way
- User consistently chooses a certain style (e.g., always formal)

**Capture:** Distinguish between explicitly stated (stronger) and implicitly observed (weaker).

**Confidence Tendency:** HIGH for "always/never" instructions, MEDIUM for single statement, LOW for purely implicit behavior.

---

### Signal 4: Successes

**What:** Explicit praise, confirmation, or particularly effective approaches.

**Detection Patterns:**
- "Perfect!" / "Exactly!" / "Great"
- "That's exactly what I wanted"
- "Always do it that way in the future"
- User adopts output without modifications
- Positive feedback after a specific approach

**Capture:** Note the context: What did Claude do that led to success? Which approach/format/structure was praised?

**Confidence Tendency:** HIGH for "always do it that way", MEDIUM for single praise, LOW for silent adoption.

---

### Signal 5: Insights

**What:** New domain knowledge that emerged during the conversation and will be relevant in the future.

**Detection Patterns:**
- API endpoints, version numbers, access credentials (no secrets!)
- Project structure, file paths, naming conventions
- Business logic, business rules, domain constraints
- Technical decisions: "We use X instead of Y because Z"
- Organizational: Team structure, responsibilities, processes

**Capture:** Only document knowledge that is relevant beyond the current session. One-off facts (e.g., "send the email to max@example.com") are usually LOW.

**Confidence Tendency:** HIGH for reusable domain knowledge, MEDIUM for project-specific details, LOW for one-time information.

---

## Additional Signals in HARDENING Mode

These signals are only captured when skills were actively used in the session.

### Signal 6: Skill Deviations

**What:** Places where Claude deviated from skill behavior and improvised instead.

**Core Question:** Was the deviation necessary (skill incomplete) or an error (skill not followed)?

**Detection Patterns:**
- Claude acts differently than the SKILL.md prescribes
- Claude skips steps from the skill
- Claude adds its own steps not in the skill
- Claude uses different tools/formats than the skill specifies

**Capture:** Note: Which skill, which step skipped/changed, why, and whether the result improved or worsened.

---

### Signal 7: Skill Corrections

**What:** User corrections that directly relate to a skill's output (not general Claude behavior).

**Important Distinction:**
- "You should always answer in English" → General correction → Signal 1
- "The skill should load the brand Bible before writing" → Skill correction → Signal 7

**Capture:** Exact reference to the skill and the SKILL.md instruction that caused the problem.

---

### Signal 8: Trigger Quality

**What:** Was the skill activated correctly and at the right time?

**Check:**
- Skill activated too early (user wanted something else)?
- Skill activated too late (user had to explicitly ask)?
- Skill not activated (even though it should have been)?
- Wrong skill activated (different one would have been better)?

**Capture:** For trigger problems: What did the user say, which skill was (not) loaded, and what would have been correct?

---

### Signal 9: Missing Coverage

**What:** Situations the skill didn't cover but should have.

**Detection Patterns:**
- Claude had to improvise outside the skill for a step that belongs to the skill topic
- User asked something the skill should have been able/should have answered
- Edge case occurred that the skill doesn't handle

**Capture:** Describe the situation, what was missing, and formulate a concrete suggestion for enhancing SKILL.md.

---

## Additional Signals in GENESIS Mode

These signals are only captured when NO skills were active and recurring patterns are recognizable.

### Signal 10: Workflow Patterns

**What:** Structured procedures the user established or repeated during the session.

**Skill Potential Criteria:**
- The same workflow type appears ≥3 times in the session
- Similar work was performed manually in previous sessions (recognizable from session archive)
- User has explicitly established structured procedures
- Corrections concern systematic procedures, not individual facts

**Capture:** Describe the pattern: Which steps, in what order, which inputs/outputs.

---

### Signal 11: Codifiable Rules

**What:** User's ad-hoc decisions that could be generalized as skill instructions.

**Detection Patterns:**
- "Always do it this way for all X"
- User gives step-by-step instructions that would be standardizable
- User corrects Claude multiple times in the same direction for different subtasks

**Capture:** Formulate the rule as potential skill instruction: "If [context], then [action], because [reason]."

---

## CLI Enhancement

The `scripts/extract_signals.py` automates signal detection from session transcripts. It uses regex patterns and semantic matching to identify signal types with confidence scores.

### Common Regex Patterns

**English patterns:**
```regex
# Corrections
/\b(No|That's wrong|Incorrect|Not like that|Instead)\b/i
/\b(should\s+(always|never|use|do))\b/i

# Repetitions
/\b(again|already\s+told|already\s+mentioned|as\s+previously)\b/i
/\b(same\s+mistake|repeated)\b/i

# Preferences
/\b(always\s+use|prefer|format\s+as|please\s+answer\s+in)\b/i

# Successes
/\b(perfect|exactly|great|exactly\s+what|do\s+it\s+that\s+way)\b/i
```

**German patterns:**
```regex
# Korrektionen
/\b(Nein|Falsch|Das stimmt nicht|Nicht so|Stattdessen)\b/
/\b(solltest?\s+(immer|nie|nutzen|machen))\b/

# Wiederholungen
/\b(Nochmal|Hab ich|Wie bereits|Wie bereits erwähnt)\b/

# Präferenzen
/\b(nutze\s+immer|benutze\s+immer|formatiere\s+als|antworte\s+(auf|in))\b/

# Erfolge
/\b(Perfekt|Genau|Super|Genau so|Mach das immer)\b/
```

See `scripts/extract_signals.py --help` for customization options.
