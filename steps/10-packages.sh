#!/usr/bin/env bash
# Update the system and install base tools.

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get full-upgrade -y
apt-get install -y curl git htop unattended-upgrades
log "Packages up to date"
