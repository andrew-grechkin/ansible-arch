#!/bin/bash

refind-install --root /mnt
# arch-chroot /mnt refind-install --usedefault "/dev/disk/by-label/EFI$2"

CPU=$(lscpu)
if [[ $CPU =~ GenuineIntel ]]; then
	arch-chroot /mnt pacman -S --needed --noconfirm intel-ucode
	INITRD_U='initrd=\intel-ucode.img'
else
	INITRD_U=''
fi

INITRD_K='initrd=\initramfs-%v.img'
DRIVES="root=LABEL=root$2 resume=LABEL=swap$2"
OPTIONS="nowatchdog splash quiet udev.log_priority=3"
CRYPT="cryptdevice=LABEL=lvm-encrypted${2}:lvm:allow-discards"

if [ "$1" = "True" ]; then
{
	echo "\"Boot with crypt+ucode\" \"rw $DRIVES $OPTIONS $CRYPT $INITRD_U $INITRD_K\""
} > /mnt/boot/refind_linux.conf
else
{
	echo "\"Boot with ucode\"       \"rw $DRIVES $OPTIONS $INITRD_U $INITRD_K\""
} > /mnt/boot/refind_linux.conf
fi
{
	echo "\"Boot with defaults\"    \"rw $DRIVES $OPTIONS\""
	echo "\"Boot with crypt\"       \"rw $DRIVES $OPTIONS $CRYPT\""
	echo "\"Boot to terminal\"      \"rw $DRIVES systemd.unit=multi-user.target\""
	echo "\"Boot to bash\"          \"rw $DRIVES init=/bin/bash\""
} >> /mnt/boot/refind_linux.conf

perl -i -plE "s{^(LABEL=\w+)}{\1$2}" /mnt/etc/fstab

cat <<- "EOF" >> '/mnt/boot/EFI/refind/refind.conf'
include next-theme/theme.conf
#include themes/rEFInd-chalkboard/theme.conf
#include themes/rEFInd-indulgence/theme.conf
#include themes/rEFInd-sunset/theme.conf
EOF

perl -i -plE "s{\A #?timeout \s+ \d+ \z}{timeout 5}x"                                                                    '/mnt/boot/EFI/refind/refind.conf'
perl -i -plE "s{\A #?use_nvram \s+ true \z}{use_nvram false}x"                                                           '/mnt/boot/EFI/refind/refind.conf'
perl -i -plE "s{\A #?showtools .+}{showtools install,bootorder,netboot, shell,memtest,gdisk,apple_recovery,windows_recovery,mok_tool,about,hidden_tags,shutdown,reboot,firmware,fwupdate}x" '/mnt/boot/EFI/refind/refind.conf'
perl -i -plE "s{\A #fold_linux_kernels .+}{fold_linux_kernels false}x"                                                 '/mnt/boot/EFI/refind/refind.conf'
perl -i -plE "s{\A #extra_kernel_version_strings .+}{extra_kernel_version_strings linux-lts,linux-zen,linux}x"         '/mnt/boot/EFI/refind/refind.conf'

cp /mnt/boot/EFI/refind/icons/os_arch.png   /mnt/boot/vmlinuz-linux.png
cp /mnt/boot/EFI/refind/icons/os_arch-2.png /mnt/boot/vmlinuz-linux-lts.png
cp /mnt/boot/EFI/refind/icons/os_arch-1.png /mnt/boot/vmlinuz-linux-zen.png

### virtualbox compatibility
[[ -d /mnt/boot/EFI/BOOT ]] || {
	cp -r /mnt/boot/EFI/refind /mnt/boot/EFI/BOOT
	mv /mnt/boot/EFI/BOOT/refind_x64.efi /mnt/boot/EFI/BOOT/bootx64.efi
}
