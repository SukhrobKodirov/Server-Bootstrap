#!/usr/bin/env bash
# Install fail2ban to block repeated failed logins.

apt-get install -y fail2ban
systemctl enable --now fail2ban
log "fail2ban active"
