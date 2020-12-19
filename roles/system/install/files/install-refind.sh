#!/bin/bash

arch-chroot /mnt refind-install --root       "/mnt/boot"
# arch-chroot /mnt refind-install --usedefault "/dev/disk/by-label/EFI$2"

if [ "$1" = "True" ]; then
{
	echo "\"Boot with crypt\"    \"rw root=LABEL=root$2 resume=LABEL=swap$2 nowatchdog splash quiet udev.log_priority=3 cryptdevice=LABEL=lvm-encrypted${2}:lvm:allow-discards\""
	echo "\"Boot with defaults\" \"rw root=LABEL=root$2 resume=LABEL=swap$2 nowatchdog splash quiet udev.log_priority=3\""
	echo "\"Boot to terminal\"   \"rw root=LABEL=root$2 resume=LABEL=swap$2 systemd.unit=multi-user.target\""
} >> /mnt/boot/refind_linux.conf
else
{
	echo "\"Boot with defaults\" \"rw root=LABEL=root$2 resume=LABEL=swap$2 nowatchdog splash quiet udev.log_priority=3\""
	echo "\"Boot with crypt\"    \"rw root=LABEL=root$2 resume=LABEL=swap$2 nowatchdog splash quiet udev.log_priority=3 cryptdevice=LABEL=lvm-encrypted${2}:lvm:allow-discards\""
	echo "\"Boot to terminal\"   \"rw root=LABEL=root$2 resume=LABEL=swap$2 systemd.unit=multi-user.target\""
} >> /mnt/boot/refind_linux.conf
fi

perl -i -plE "s{^(LABEL=\w+)}{\1$2}" /mnt/etc/fstab

### virtualbox compatibility
[[ -d /mnt/boot/EFI/BOOT ]] || {
	cp -r /mnt/boot/EFI/refind /mnt/boot/EFI/BOOT
}
