#!/usr/bin/env bash
set -e

# Show learning statistics with pretty-printed box drawing

readonly CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
readonly STATS_FILE="$CLAUDE_DIR/rules/.stats.json"

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ${NC}  $*"
}

get_count() {
    local dir=$1
    if [ -d "$dir" ]; then
        find "$dir" -type f \( -name "*.md" -o -name "*.json" \) | wc -l
    else
        echo "0"
    fi
}

get_json_value() {
    local file=$1
    local key=$2
    if [ -f "$file" ]; then
        grep -o "\"$key\"[^,]*" "$file" | cut -d':' -f2 | tr -d ' "' || echo "0"
    else
        echo "0"
    fi
}

print_box() {
    local title=$1
    local width=50

    echo -e "${CYAN}┌$(printf '─%.0s' $(seq 1 $width))┐${NC}"
    printf "${CYAN}│${NC} ${YELLOW}%-47s${CYAN}│${NC}\n" "$title"
    echo -e "${CYAN}└$(printf '─%.0s' $(seq 1 $width))┘${NC}"
}

main() {
    echo ""
    print_box "Learning Statistics"
    echo ""

    # Count sessions
    local session_count=$(get_count "$CLAUDE_DIR/sessions")
    log_info "Sessions processed:"
    echo -e "     ${GREEN}$session_count${NC} session(s)"
    echo ""

    # Count rules
    local rule_count=$(get_count "$CLAUDE_DIR/rules")
    log_info "Rules extracted:"
    echo -e "     ${GREEN}$rule_count${NC} rule(s)"
    echo ""

    # Count skill patches
    local patch_count=$(find "$CLAUDE_DIR" -name "*.patch" -o -name "*patch*" 2>/dev/null | wc -l)
    log_info "Skill patches created:"
    echo -e "     ${GREEN}$patch_count${NC} patch(es)"
    echo ""

    # Show stats file info if available
    if [ -f "$STATS_FILE" ]; then
        local last_updated=$(get_json_value "$STATS_FILE" "last_updated")
        log_info "Last updated:"
        echo "     $last_updated"
        echo ""
    fi

    # Show trend (simplified version)
    if [ "$rule_count" -gt 0 ]; then
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✓${NC}  Learning pipeline is active"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    else
        echo -e "${YELLOW}○${NC}  No learnings captured yet"
    fi

    echo ""
}

main "$@"
