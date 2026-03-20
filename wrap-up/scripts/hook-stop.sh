#!/usr/bin/env bash
set -e

# Stop hook that triggers wrap-up when auto mode is enabled
# Called by Claude CLI on session stop
#
# Usage: Configure in ~/.claude/settings.local.json:
# {
#   "hooks": {
#     "stop": ["~/.claude/skills/wrap-up/scripts/hook-stop.sh"]
#   }
# }

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly STATE_DIR="$SCRIPT_DIR/../.state"
readonly AUTO_WRAPUP_FILE="$STATE_DIR/auto-wrapup.json"
readonly LOG_FILE="${HOME}/.claude/wrap-up-hook.log"
readonly LOCK_FILE="$STATE_DIR/.wrap-up.lock"
readonly LOCK_TIMEOUT_MINS=10

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_to_file() {
    local level=$1
    shift
    local msg="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $msg" >> "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}ℹ${NC}  $*"
    log_to_file "INFO" "$*"
}

log_error() {
    echo -e "${RED}✗${NC}  $*" >&2
    log_to_file "ERROR" "$*"
}

log_success() {
    echo -e "${GREEN}✓${NC}  $*"
    log_to_file "SUCCESS" "$*"
}

is_auto_wrapup_enabled() {
    if [ -f "$AUTO_WRAPUP_FILE" ]; then
        grep -q '"enabled"\s*:\s*true' "$AUTO_WRAPUP_FILE"
        return $?
    fi
    return 1
}

cleanup_stale_locks() {
    if [ -f "$LOCK_FILE" ]; then
        local lock_age=$(($(date +%s) - $(stat -f%m "$LOCK_FILE" 2>/dev/null || stat -c%Y "$LOCK_FILE" 2>/dev/null || echo 0)))
        local lock_timeout=$((LOCK_TIMEOUT_MINS * 60))

        if [ "$lock_age" -gt "$lock_timeout" ]; then
            log_to_file "WARN" "Removing stale lock file (age: ${lock_age}s)"
            rm -f "$LOCK_FILE"
        fi
    fi
}

main() {
    # Ensure state and log directories exist
    mkdir -p "$STATE_DIR"
    mkdir -p "$(dirname "$LOG_FILE")"

    log_to_file "INFO" "hook-stop triggered"

    # Check if auto wrap-up is enabled
    if ! is_auto_wrapup_enabled; then
        log_to_file "INFO" "Auto wrap-up is disabled, exiting"
        exit 0
    fi

    # Clean up stale locks
    cleanup_stale_locks

    # Check if another wrap-up is already running
    if [ -f "$LOCK_FILE" ]; then
        log_to_file "WARN" "Wrap-up already in progress (lock file exists)"
        exit 0
    fi

    # Create lock file
    touch "$LOCK_FILE"

    log_info "Auto wrap-up is enabled"
    log_info "Session ended — initiating wrap-up"

    # Update stats: increment session counter
    local update_script="$SCRIPT_DIR/update-stats.sh"
    if [ -x "$update_script" ]; then
        "$update_script" total_sessions 1 2>/dev/null || true
    fi

    # Notify user that wrap-up should be run
    # The actual wrap-up analysis is performed by Claude reading the SKILL.md,
    # not by this shell script. This hook serves as the trigger mechanism.
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log_success "Session ended — wrap-up triggered"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  Run /wrap-up in your next session to analyze learnings"
    echo "  from this session, or enable auto-analysis in your"
    echo "  Claude Code settings."
    echo ""

    log_to_file "SUCCESS" "Hook completed — wrap-up notification sent"

    # Clean up lock
    rm -f "$LOCK_FILE"

    exit 0
}

main "$@"
