#!/usr/bin/env bash
# Install Tailscale. Signing in needs a person, so it is left as a reminder.
if command -v tailscale >/dev/null 2>&1; then
	log "Tailscale already installed, skipping"
else
	curl -fsSL https://tailscale.com/install.sh | sh
	log "Tailscale installed"
fi
log "Next: run 'sudo tailscale up --hostname=$TAILSCALE_HOSTNAME' and approve the link"
