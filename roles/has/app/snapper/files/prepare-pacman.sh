#!/bin/bash

if [[ -d "/var/lib/pacman" ]]; then
	umask 022
	mkdir -p /usr/var/lib
	mv "/var/lib/pacman" /usr/var/lib/

	sed -i 's|#DBPath.*|DBPath = /usr/var/lib/pacman|' /etc/pacman.conf
fi
