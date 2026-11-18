#!/usr/bin/env bash
# Harden SSH. Test the config and roll back if it is invalid.

conf=/etc/ssh/sshd_config.d/10-hardening.conf
cat > "$conf" <<EOF
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
AllowUsers $ADMIN_USER
MaxAuthTries 3
X11Forwarding no
EOF

mkdir -p /run/sshd
if sshd -t; then
	systemctl try-reload-or-restart ssh
	log "SSH hardened: keys only, only $ADMIN_USER may log in"
else
	rm -f "$conf"
	log "SSH config test failed, change rolled back"
	exit 1
fi
