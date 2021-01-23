#!/bin/sh

set -e

### Update pacman config
sed -i 's|^#Color$|Color\nILoveCandy|'        /mnt/etc/pacman.conf
sed -i 's|^#VerbosePkgLists|VerbosePkgLists|' /mnt/etc/pacman.conf

### set time sync and time zone
ln -sf /usr/share/zoneinfo/Europe/Amsterdam   /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc --utc

### configure language and location
sed -i 's|.*\(en_DK\.UTF-8\)|\1|' /mnt/etc/locale.gen
sed -i 's|.*\(en_US\.UTF-8\)|\1|' /mnt/etc/locale.gen
sed -i 's|.*\(nl_NL\.UTF-8\)|\1|' /mnt/etc/locale.gen
sed -i 's|.*\(ru_RU\.UTF-8\)|\1|' /mnt/etc/locale.gen
arch-chroot /mnt locale-gen

echo LANG=en_DK.UTF-8 >> /mnt/etc/locale.conf

### set hostname and network
echo arch > /mnt/etc/hostname

# this is unnecessary as nss-myhostname is enabled in nsswitch.conf
#echo "127.0.1.1 $(cat /mnt/etc/hostname).ams $(cat /mnt/etc/hostname)" >> /mnt/etc/hosts
#echo "127.0.0.1 localhost"                                             >> /mnt/etc/hosts
#echo "::1       localhost"                                             >> /mnt/etc/hosts

### set font for console
#echo FONT=ter-u16n >> /mnt/etc/vconsole.conf

### set correct environment (let's use personal preferences in ~/.pam_environment)
#echo "EDITOR=vim"     >> /mnt/etc/environment
#echo "VISUAL=vim"     >> /mnt/etc/environment

sed -i 's|^use-ipv6=yes|use-ipv6=no|'                           /mnt/etc/avahi/avahi-daemon.conf

### configure mdns, enabled llmnr make all resolves to .local very slow
sed -i 's| resolve | mdns4_minimal [NOTFOUND=return] resolve |' /mnt/etc/nsswitch.conf
ln -sf /run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf

arch-chroot /mnt pacman -S --needed --noconfirm ansible git openssh vim

arch-chroot /mnt systemctl enable NetworkManager
arch-chroot /mnt systemctl enable systemd-resolved
arch-chroot /mnt systemctl enable sshd
arch-chroot /mnt systemctl enable avahi-daemon
arch-chroot /mnt systemctl enable fstrim.timer

USER_PASS=$(perl -MDigest::MD5=md5_hex -E '$pass=shift; $salt=md5_hex(rand); print crypt($pass,"\$6\$${salt}\$")' "$3")
ROOT_PASS=$(perl -MDigest::MD5=md5_hex -E '$pass=shift; $salt=md5_hex(rand); print crypt($pass,"\$6\$${salt}\$")' "$3")

arch-chroot /mnt useradd -m -G wheel,audio,log,network,optical,power,storage,sys,systemd-journal,users,uucp,video -u "$2" "$1"
arch-chroot /mnt usermod -p "$USER_PASS" "$1"
arch-chroot /mnt usermod -p "$ROOT_PASS" root

echo '%wheel      ALL         = (ALL) ALL' > /mnt/etc/sudoers.d/0wheel

# copy server ssh keys
#cp -f /etc/ssh/ssh_host_* /mnt/etc/ssh/

# former base group consists of:
#cryptsetup -- indirect dependency of base
#device-mapper -- indirect dependency of base
#dhcpcd
#diffutils
#e2fsprogs -- indirect dependency of base
#inetutils
#jfsutils
#less -- indirect dependency of base
#linux
#linux-firmware
#logrotate
#lvm2
#man-db
#man-pages
#mdadm
#nano
#netctl
#perl
#reiserfsprogs
#s-nail
#sysfsutils
#texinfo
#usbutils
#vi
#which
#xfsprogs
