#!/usr/bin/env bash
set -e

# Show current auto wrap-up status and statistics

readonly STATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.state" && pwd)"
readonly AUTO_WRAPUP_FILE="$STATE_DIR/auto-wrapup.json"
readonly STATS_FILE="$STATE_DIR/stats.json"

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

get_json_value() {
    local file=$1
    local key=$2
    if [ -f "$file" ]; then
        grep -o "\"$key\"[^,]*" "$file" | cut -d'"' -f4
    fi
}

main() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  wrap-up status${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    # Check auto wrap-up status
    if [ -f "$AUTO_WRAPUP_FILE" ]; then
        local enabled=$(get_json_value "$AUTO_WRAPUP_FILE" "enabled")
        if [ "$enabled" = "true" ]; then
            log_success "Auto wrap-up is ENABLED"
            local enabled_at=$(get_json_value "$AUTO_WRAPUP_FILE" "enabled_at")
            if [ -n "$enabled_at" ]; then
                echo "  Enabled at: $enabled_at"
            fi
        else
            echo -e "${YELLOW}○${NC}  Auto wrap-up is DISABLED"
            local disabled_at=$(get_json_value "$AUTO_WRAPUP_FILE" "disabled_at")
            if [ -n "$disabled_at" ]; then
                echo "  Disabled at: $disabled_at"
            fi
        fi
    else
        echo -e "${YELLOW}○${NC}  No auto wrap-up configuration found"
    fi

    echo ""

    # Show statistics
    if [ -f "$STATS_FILE" ]; then
        log_info "Learning Statistics"
        local total_sessions=$(get_json_value "$STATS_FILE" "total_sessions")
        local total_rules=$(get_json_value "$STATS_FILE" "total_rules")
        local total_patches=$(get_json_value "$STATS_FILE" "total_skill_patches")

        cat <<EOF

  Sessions processed:    ${total_sessions:-0}
  Rules extracted:       ${total_rules:-0}
  Skill patches created: ${total_patches:-0}
EOF
    else
        echo -e "${YELLOW}○${NC}  No statistics available yet"
    fi

    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

main "$@"
