#!/bin/sh

#arch-chroot /mnt refind-install --root /mnt/boot/EFI
arch-chroot /mnt refind-install --usedefault /dev/disk/by-label/EFI

if [ "$1" = "true" ]; then
{
	echo '"Boot with crypt"    "rw root=LABEL=root resume=LABEL=swap nowatchdog cryptdevice=LABEL=lvm-encrypted:lvm:allow-discards"'
	echo '"Boot with defaults" "rw root=LABEL=root resume=LABEL=swap nowatchdog splash quiet udev.log_priority=3"'
	echo '"Boot to terminal"   "rw root=LABEL=root resume=LABEL=swap systemd.unit=multi-user.target"'
} >> /mnt/boot/refind_linux.conf
else
{
	echo '"Boot with defaults" "rw root=LABEL=root resume=LABEL=swap nowatchdog splash quiet udev.log_priority=3"'
	echo '"Boot to terminal"   "rw root=LABEL=root resume=LABEL=swap systemd.unit=multi-user.target"'
	echo '"Boot with crypt"    "rw root=LABEL=root resume=LABEL=swap nowatchdog cryptdevice=LABEL=lvm-encrypted:lvm:allow-discards"'
} >> /mnt/boot/refind_linux.conf
fi

# virtualbox compatibility
#cp -r /mnt/boot/EFI/refind /mnt/boot/EFI/BOOT
