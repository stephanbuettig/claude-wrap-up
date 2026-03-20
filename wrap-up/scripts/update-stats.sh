#!/usr/bin/env bash
set -e

# Update .state/stats.json with new session data
# Uses pure bash + sed — no Python dependency required

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly STATE_DIR="$SCRIPT_DIR/../.state"
readonly STATS_FILE="$STATE_DIR/stats.json"

readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_success() {
    echo -e "${GREEN}✓${NC}  $*"
}

log_error() {
    echo -e "${RED}✗${NC}  $*" >&2
}

init_stats_file() {
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    cat > "$STATS_FILE" <<EOF
{
  "total_sessions": 0,
  "total_rules": 0,
  "total_skill_patches": 0,
  "last_updated": "$timestamp"
}
EOF
}

increment_counter() {
    local counter=$1
    local amount=${2:-1}

    if [ ! -f "$STATS_FILE" ]; then
        init_stats_file
    fi

    # Read current value using grep + cut (pure bash, no Python)
    local current=$(grep -o "\"$counter\"[[:space:]]*:[[:space:]]*[0-9]*" "$STATS_FILE" | grep -o '[0-9]*$' || echo "0")
    local new_value=$((current + amount))
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    # Update the counter value using sed
    sed -i "s/\"$counter\"[[:space:]]*:[[:space:]]*[0-9]*/\"$counter\": $new_value/" "$STATS_FILE"

    # Update the timestamp
    sed -i "s/\"last_updated\"[[:space:]]*:[[:space:]]*\"[^\"]*\"/\"last_updated\": \"$timestamp\"/" "$STATS_FILE"

    echo "$new_value"
}

main() {
    local counter="${1:-}"
    local amount="${2:-1}"

    # Validate arguments
    if [ -z "$counter" ]; then
        log_error "Usage: update-stats.sh <counter> [amount]"
        log_error "Counters: total_sessions, total_rules, total_skill_patches"
        exit 1
    fi

    # Validate counter name
    case "$counter" in
        total_sessions|total_rules|total_skill_patches)
            ;;
        *)
            log_error "Unknown counter: $counter"
            exit 1
            ;;
    esac

    # Ensure state directory exists
    mkdir -p "$STATE_DIR"

    # Update the counter
    local new_value=$(increment_counter "$counter" "$amount")

    if [ $? -eq 0 ]; then
        log_success "Updated $counter: $new_value"
    else
        exit 1
    fi
}

main "$@"
