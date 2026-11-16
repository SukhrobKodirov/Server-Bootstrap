#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$ROOT_DIR/lib/common.sh"

require_root
load_config "$ROOT_DIR/config.env"

for step in "$ROOT_DIR"/steps/*.sh; do
 log "Running $(basename "$step")"
 #shellcheck source=/dev/null
 source "$step"
done

log "All steps finished"
