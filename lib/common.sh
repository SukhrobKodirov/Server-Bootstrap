#!/usr/bin/env bash

log() { printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }

require_root() {
	if [[ $EUID -ne 0 ]]; then
		log "Run this script with sudo"
		exit 1
	fi
}

load_config() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		log "Missing $file. Copy config.env.example and fill it in"
		exit 1
	fi
	# shellcheck source=/dev/null
	source"$file"
}
