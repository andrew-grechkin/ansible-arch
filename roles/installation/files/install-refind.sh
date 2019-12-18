#!/bin/sh

#arch-chroot /mnt refind-install --root /mnt/boot/EFI
arch-chroot /mnt refind-install --usedefault /dev/disk/by-label/EFI
{
	echo '"Boot with defaults" "rw root=LABEL=root resume=LABEL=swap nowatchdog splash quiet udev.log_priority=3"'
	echo '"Boot to terminal"   "rw root=LABEL=root resume=LABEL=swap systemd.unit=multi-user.target"'
	echo '"Boot with crypt"    "rw root=LABEL=root resume=LABEL=swap nowatchdog cryptdevice=LABEL=crypto-lvm:lvm:allow-discards"'
} >> /mnt/boot/refind_linux.conf

# virtualbox compatibility
#cp -r /mnt/boot/EFI/refind /mnt/boot/EFI/BOOT
