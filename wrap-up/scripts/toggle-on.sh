#!/usr/bin/env bash
set -e

# Enable auto wrap-up by writing enabled:true to .state/auto-wrapup.json

readonly STATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.state" && pwd)"
readonly STATE_FILE="$STATE_DIR/auto-wrapup.json"

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

main() {
    # Ensure state directory exists
    if [ ! -d "$STATE_DIR" ]; then
        mkdir -p "$STATE_DIR"
    fi

    # Update or create auto-wrapup.json
    cat > "$STATE_FILE" <<EOF
{
  "enabled": true,
  "enabled_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

    log_success "Auto wrap-up enabled"
    echo -e "${BLUE}ℹ${NC}  Wrap-up will run automatically when sessions end"
}

main "$@"
