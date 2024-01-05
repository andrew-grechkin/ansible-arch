#!/bin/bash

set -e

if [[ -d "/efi" ]]; then
	MNT="$(grep '/efi' < /etc/fstab | awk '{print $1}')"
	if [[ -n "$MNT" ]]; then
		sed -i 's|\(GRUB_CMDLINE_LINUX_DEFAULT="\)|\1resume='"$MNT"' |' /etc/default/grub

		rm -f  /boot/*.png
		rm -rf /boot/EFI/BOOT
		rm -rf /boot/EFI/tools

		grub-install --removable --efi-directory=/boot --force

		grub-mkconfig -o /boot/grub/grub.cfg

		/usr/bin/rsync -rtv --delete /boot/ /efi 1>/dev/null
	fi
fi
