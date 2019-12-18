#!/bin/sh

mdadm --detail --scan >> /mnt/etc/mdadm.conf

#HOOKS=(base udev autodetect <keyboard> consolefont modconf block <encrypt lvm2 resume> filesystems fsck)

sed -i 's|MODULES=()|MODULES=(vfat btrfs)|'                                    /mnt/etc/mkinitcpio.conf
sed -i 's|BINARIES=()|BINARIES=(lsblk vim cfdisk)|'                            /mnt/etc/mkinitcpio.conf
sed -i 's|block filesystems|block mdadm_udev encrypt lvm2 resume filesystems|' /mnt/etc/mkinitcpio.conf
sed -i 's|autodetect|autodetect keyboard|'                                     /mnt/etc/mkinitcpio.conf

arch-chroot /mnt mkinitcpio -n -P
