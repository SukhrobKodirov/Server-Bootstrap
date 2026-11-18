# server-bootstrap

One script that turns a fresh Ubuntu 24.04 server into a hardened base

## Usage

	cp config.env.example config.env # then fill in your values
	sudo ./bootstrap.sh

Safe to run more than once.

## Steps

| File | What it does |
|---|---|
| 10-packages.sh | Updates the system, installs base tools|
| 20-swap.sh | Creates a swap file |
