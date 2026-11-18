# server-bootstrap

One script that turns a fresh Ubuntu 24.04 server into a hardened base

## Usage

	sudo ./bootstrap.sh

The first run asks for your username, SSH public key, swap size and
Tailscale hostname, and saves them to 'config.env'. Later runs read that
file and ask nothing. for automation, create 'config.env' yourself from
'config.env.example'.
Safe to run more than once.

## Steps

| File | What it does |
|---|---|
| 10-packages.sh | Updates the system, installs base tools|
| 20-swap.sh | Creates a swap file |
