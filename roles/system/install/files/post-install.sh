#!/bin/sh

set -e

USR_NAM="$1"
USR_UID="$2"
USR_PAS="$3"

D_HOST="$4"
D_LANG="$5"
D_TIME="$6"

### Update pacman config
sed -i 's|^#Color$|Color\nILoveCandy|'        /mnt/etc/pacman.conf
sed -i 's|^#VerbosePkgLists|VerbosePkgLists|' /mnt/etc/pacman.conf

### set time sync and time zone
ln -sf "/usr/share/zoneinfo/$D_TIME"          /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc --utc

### configure language and location
echo "LANG=$D_LANG"                        >> /mnt/etc/locale.conf

sed -i "s|.*\(${D_LANG}\)|\1|"                /mnt/etc/locale.gen
sed -i 's|.*\(en_US\.UTF-8\)|\1|'             /mnt/etc/locale.gen
sed -i 's|.*\(nl_NL\.UTF-8\)|\1|'             /mnt/etc/locale.gen
sed -i 's|.*\(ru_RU\.UTF-8\)|\1|'             /mnt/etc/locale.gen
arch-chroot /mnt locale-gen

### set hostname and network
echo "$D_HOST"                              > /mnt/etc/hostname

# this is unnecessary as nss-myhostname is enabled in nsswitch.conf
#echo "127.0.1.1 $(cat /mnt/etc/hostname).ams $(cat /mnt/etc/hostname)" >> /mnt/etc/hosts
#echo "127.0.0.1 localhost"                                             >> /mnt/etc/hosts
#echo "::1       localhost"                                             >> /mnt/etc/hosts

### set font for console
#echo FONT=ter-u16n >> /mnt/etc/vconsole.conf

### set correct environment (let's use personal preferences in ~/.pam_environment)
#echo "EDITOR=vim"     >> /mnt/etc/environment
#echo "VISUAL=vim"     >> /mnt/etc/environment

# sed -i 's|^use-ipv6=yes|use-ipv6=no|'                           /mnt/etc/avahi/avahi-daemon.conf

### configure mdns, enabled llmnr make all resolves to .local very slow
# sed -i 's| resolve | mdns4_minimal [NOTFOUND=return] resolve |' /mnt/etc/nsswitch.conf
ln -sf /run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf

arch-chroot /mnt systemctl enable NetworkManager
arch-chroot /mnt systemctl enable avahi-daemon
arch-chroot /mnt systemctl enable btrfs-scrub@-.timer
arch-chroot /mnt systemctl enable btrfs-scrub@home.timer
arch-chroot /mnt systemctl enable fstrim.timer
arch-chroot /mnt systemctl enable sshd
arch-chroot /mnt systemctl enable systemd-resolved

USER_PASS=$(perl -MDigest::MD5=md5_hex -E '$pass=shift; $salt=md5_hex(rand); print crypt($pass,"\$6\$${salt}\$")' "$USR_PAS")
ROOT_PASS=$(perl -MDigest::MD5=md5_hex -E '$pass=shift; $salt=md5_hex(rand); print crypt($pass,"\$6\$${salt}\$")' "$USR_PAS")

arch-chroot /mnt useradd -m -s /usr/bin/zsh -G network,systemd-journal,users,uucp,wheel -u "$USR_UID" "$USR_NAM"
arch-chroot /mnt usermod -p "$USER_PASS" "$USR_NAM"
arch-chroot /mnt usermod -p "$ROOT_PASS" root

echo '%wheel      ALL         = (ALL) ALL' > /mnt/etc/sudoers.d/additional

# copy server ssh keys
#cp -f /etc/ssh/ssh_host_* /mnt/etc/ssh/

# former base group consists of:
#cryptsetup -- indirect dependency of base
#device-mapper -- indirect dependency of base
#dhcpcd
#diffutils
#e2fsprogs -- indirect dependency of base
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
