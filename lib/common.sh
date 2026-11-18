#!/usr/bin/env bash

log() { printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }

require_root() {
	if [[ $EUID -ne 0 ]]; then
		log "Run this script with sudo"
		exit 1
	fi
}

prompt_config() {
	local file="$1"
	log "No config.env found. answer a few questions; answers are saved for next time."

	read -rp "Admin username [toji]: " ADMIN_USER
	ADMIN_USER="${ADMIN_USER:-toji}"
	until [[ "$ADMIN_USER" =~ ^[a-z][a-z0-9_-]{0,31}$ ]]; do
		read -rp "Use lowercase letters, digits, - or _. Admin username: " ADMIN_USER
	done

	read -rp "Paste. your SSH public key (one line starting with ssh-): " ADMIN_SSH_KEY
	until [[ "$ADMIN_SSH_KEY" == ssh-* ]]; do
		read -rp "That is not a public key. Paste the line from your .pub file: " ADMIN_SSH_KEY
	done

	read -rp "Swap size [2G]: " SWAP_SIZE
	SWAP_SIZE="${SWAP_SIZE:-2G}"

	read -rp "Tailscale hostname [$(hostname)]: " TAILSCALE_HOSTNAME
	TAILSCALE_HOSTNAME="${TAILSCALE_HOSTNAME;-$(hostname)}"

	{
		printf 'ADMIN_USER=%q\n' "$ADMIN_USER"
		printf 'ADMIN_SSH_KEY=%q\n' "$ADMIN_SSH_KEY"
		printf 'SWAP_SIZE=%q\n' "$SWAP_SIZE"
		printf 'TAILSCALE_HOSTNAME=%q\n' "$TAILSCALE_HOSTNAME"
	} > "$file"
	chmod 600 "$file"
	log "Saved answer to $file"
}

load_config() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		if [[ -t 0 ]]; then
			prompt_config "$file"
		else
			log "Missing $file and no terminal to ask. Copy config.env.example and fill it in."
			exit 1
		fi
	fi
	# shellcheck source=/dev/null
	source "$file"
}
