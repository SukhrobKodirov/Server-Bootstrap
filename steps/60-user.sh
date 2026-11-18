#!/usr/bin/env bash
# Create the admin user, add the SSh key, grant passwordless sudo.

# Safety: refuse to continue with a missing or example key,
# because the SSH step would then lock everyone out.
if [[ "$ADMIN_SSH_KEY" != ssh-* || "$ADMIN_SSH_KEY" == *replace* ]]; then
	log "ADMIN_SSH_KEY in config.env is not a real public key. Stopping."
	exit 1
fi

if id "$ADMIN_USER" >/dev/null 2>&1; then
	log "User $ADMIN_USER already exists"
else
	adduser --disabled-password --gecos "" "$ADMIN_USER"
	log "User $ADMIN_USER created"
fi
usermod -aG sudo "$ADMIN_USER"

home="/home/$ADMIN_USER"
install -d -m 700 -o "$ADMIN_USER" -g "$ADMIN_USER" "$home/.ssh"
keyfile="$home/.ssh/authorized_keys"
touch "$keyfile"
grep -qxF "$ADMIN_SSH_KEY" "$keyfile" || echo "$ADMIN_SSH_KEY" >> "$keyfile"
chown "$ADMIN_USER:$ADMIN_USER" "$keyfile"
chmod 600 "$keyfile"

tmp="$(mktemp)"
echo "$ADMIN_USER ALL=(ALL) NOPASSWD:ALL" > "$tmp"
visudo -cf "$tmp" >/dev/null
install -m 440 "$tmp" "/etc/sudoers.d/90-$ADMIN_USER"
rm -f "$tmp"
log "Admin user $ADMIN_USER ready"
