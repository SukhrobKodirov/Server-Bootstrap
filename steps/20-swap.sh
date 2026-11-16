#!/usr/bin/env bash
#Create a swap file once. Do nothing if it already exists.

if swapon --show | grep -q '/swapfile'; then
	log "Swap already active, skipping"
else
	fallocate -l "$SWAP_SIZE" /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	grep -q '^swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
	log "Swap of $SWAP_SIZE created"
fi

echo 'vm.swappiness=10' > /etc/sysctl.d/99-swappiness.conf
sysctl --system > /dev/null
