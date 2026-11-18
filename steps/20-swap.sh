#!/usr/bin/env bash
#Create a swap file once, if there is enough free disk space.

if swapon --show | grep -q '/swapfile'; then
	log "Swap already active, skipping"
else
	rm -f /swapfile
	need_kb=$(( $(numfmt --from=iec "$SWAP_SIZE") / 1024 + 1048576 ))
	avail_kb=$(df --output=avail -k / | tail -1)
	if (( avail_kb < need_kb )); then
		log "Not enough free disk for $SWAP_SIZE swap plus 1 GB margin, skipping"
	else
		fallocate -l "$SWAP_SIZE" /swapfile
		chmod 600 /swapfile
		mkswap /swapfile
		swapon /swapfile
		grep -q '^swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
		log "Swap of $SWAP_SIZE created"
	fi
fi

echo 'vm.swappiness=10' > /etc/sysctl.d/99-swappiness.conf
sysctl --system > /dev/null
