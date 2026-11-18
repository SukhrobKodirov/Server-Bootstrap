#!/usr/bin/env bash
# Disable services a cloud server does not need

for unit in rpcbind.socket rpcbind.service ModemManager.service; do
	systemsctl disable --now "$unit" 2>dev/bull || true 
done
log "Unneeded services disabled"
