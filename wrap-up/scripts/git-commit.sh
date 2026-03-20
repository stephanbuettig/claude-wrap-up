#!/usr/bin/env bash
set -e

# Git commit helper for wrap-up learnings
# Stages .claude/rules/, .claude/sessions/, and CLAUDE.md
# Creates structured commit message with wrap-up prefix

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ${NC}  $*"
}

log_success() {
    echo -e "${GREEN}✓${NC}  $*"
}

log_error() {
    echo -e "${RED}✗${NC}  $*" >&2
}

log_warn() {
    echo -e "${YELLOW}⚠${NC}  $*"
}

main() {
    local description="${1:-}"

    # Check if git is available
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed"
        exit 1
    fi

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        exit 1
    fi

    log_info "Git repository detected"

    # Define files to stage
    local files_to_stage=(
        ".claude/rules/"
        ".claude/sessions/"
        "CLAUDE.md"
    )

    # Check if any of these files exist
    local has_changes=false
    for file in "${files_to_stage[@]}"; do
        if [ -e "$file" ]; then
            has_changes=true
            break
        fi
    done

    if [ "$has_changes" = false ]; then
        log_warn "No learning files found to commit"
        exit 0
    fi

    # Stage files
    log_info "Staging learning files..."
    for file in "${files_to_stage[@]}"; do
        if [ -e "$file" ]; then
            git add "$file" 2>/dev/null || true
        fi
    done

    # Check if there are staged changes
    if ! git diff --cached --quiet; then
        log_success "Staged wrap-up learnings"
    else
        log_warn "No changes to stage"
        exit 0
    fi

    # Get git user info
    local author_name=$(git config --get user.name || echo "Claude")
    local author_email=$(git config --get user.email || echo "learning@claude.ai")

    # Build commit message
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local commit_msg="wrap-up: capture learnings from session"

    if [ -n "$description" ]; then
        commit_msg="wrap-up: $description"
    fi

    # Create detailed commit body
    local commit_body="Automated wrap-up commit

Session date: $timestamp
Author: $author_name <$author_email>

Files updated:
- .claude/rules/ (decision rules)
- .claude/sessions/ (session logs)
- CLAUDE.md (project instructions)"

    # Perform commit
    log_info "Creating commit: '$commit_msg'"
    git commit \
        --author="$author_name <$author_email>" \
        -m "$commit_msg" \
        -m "$commit_body" || {
        log_error "Commit failed"
        exit 1
    }

    log_success "Commit created successfully"

    # Show commit info
    log_info "Commit details:"
    git log -1 --oneline
}

main "$@"
