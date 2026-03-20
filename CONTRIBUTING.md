# Contributing to Claude Wrap-Up

We're excited that you want to contribute! This document outlines how to participate responsibly.

---

## Code of Conduct

- Be respectful and inclusive
- Focus on the problem, not the person
- Help others learn; assume good intent
- Report serious issues privately to the maintainer

---

## Ways to Contribute

### 1. Report Issues

Found a bug or have a feature idea?

**Before opening an issue:**
- Check [existing issues](https://github.com/unfassbarstephan/claude-wrap-up/issues)
- Run the latest version: `git pull && bash setup`
- Verify the problem persists

**When reporting:**
- Title: Be specific ("Anti-drift check fails for domain rules" not "bug")
- Steps to reproduce: Exact commands and expected behavior
- Environment: OS, Claude Code version

### 2. Submit Pull Requests

We welcome PRs for:
- Bug fixes
- New signal patterns (in `references/signal-patterns.md`)
- Improved documentation
- Script improvements
- Template enhancements

**Before submitting:**

```bash
# 1. Fork the repo
git clone https://github.com/YOUR_USERNAME/claude-wrap-up.git
cd claude-wrap-up

# 2. Create a feature branch
git checkout -b feature/your-feature-name

# 3. Test your changes
bash setup  # Verify installation works

# 4. Update docs if adding a feature

# 5. Commit with a clear message
git commit -m "[feature] brief description of change"

# 6. Push and open a PR
git push origin feature/your-feature-name
```

**PR checklist:**
- [ ] Feature is described in PR body
- [ ] No new external dependencies added (see Design Principles below)
- [ ] Docs updated where relevant
- [ ] Commit messages are clear

### 3. Improve Documentation

Documentation needs love! You can:
- Fix typos or clarity issues
- Add examples in `examples/`
- Improve the user guide in `docs/`

### 4. Improve Signal Patterns

Signal patterns are defined in `wrap-up/references/signal-patterns.md`. You can contribute:
- New detection patterns for corrections, preferences, etc.
- Better regex patterns for English or German
- Additional language support

---

## Design Principles

When contributing, respect these core principles from the MASTERKONZEPT:

1. **One skill, not five** — Everything lives in one skill with internal phases
2. **Analysis is read-only** — Changes only after user confirmation (Credo VI)
3. **No external dependencies** — The system works via Markdown and Claude's native abilities. Python scripts are optional CLI accelerators, not requirements.
4. **Platform-agnostic** — Same SKILL.md must work in CLI, Cowork, and Web-UI
5. **CLAUDE.md stays lean** — ≤200 lines; domain rules go to `.claude/rules/`
6. **Confidence, not scores** — Use HIGH/MEDIUM/LOW classification, not percentage scores
7. **Evidence-based rules only** — Every rule needs a documented trigger (Anti-Drift Rule 1)

---

## File Structure

```
claude-wrap-up/
├── setup                    # Installation script
├── README.md                # Project overview
├── INSTALLATION.md          # Setup guide
├── CONTRIBUTING.md          # This file
├── LICENSE                  # MIT License
├── VERSION                  # Version number
├── CLAUDE.md                # AI project context
├── wrap-up/
│   ├── SKILL.md             # The actual skill (core)
│   ├── references/          # Progressive disclosure docs
│   ├── templates/           # Output format templates
│   ├── scripts/             # CLI helper scripts
│   ├── commands/            # Slash command definitions
│   └── .state/              # Runtime state files
├── docs/
│   └── USER_GUIDE.md        # Comprehensive user guide
└── examples/
    └── example-session.md   # Full walkthrough
```

---

## Git Workflow

### Commit Messages

```
[type] Brief summary (50 chars max)

[type] can be:
  [feature] - New functionality
  [fix]     - Bug fix
  [docs]    - Documentation only
  [refactor]- Code restructuring
  [script]  - Script improvements
```

### Branch Naming

```
feature/description        # New feature
fix/issue-number          # Bug fix
docs/what-you-updated     # Documentation
```

---

## Questions?

- **Issues:** [GitHub Issues](https://github.com/unfassbarstephan/claude-wrap-up/issues)

---

## Recognition

Contributors are recognized in release notes and README.md for significant contributions.

Thank you for making wrap-up better!
