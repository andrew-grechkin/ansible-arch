#!/bin/sh

LAB=${1:-home}
PREFIX=${2:-@}

mkdir                             "/mnt-${LAB}"
mount  -L "${LAB}" -o subvolid=5  "/mnt-${LAB}"

btrfs subvolume create            "/mnt-${LAB}/${PREFIX}"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/.snapshots"
mkdir  -p                         "/mnt-${LAB}/${PREFIX}/.snapshots/init"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot/motion"
chgrp video                       "/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot/motion"
chmod u+rwXs,g+rwXs,o-rwx         "/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot/motion"
chattr +C                         "/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot/motion"

if [[ "$PREFIX" = "@" ]]; then
	btrfs subvolume set-default   "/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot"
fi

# quota makes btrfs slow
#btrfs quota enable                "/mnt-${LAB}"
#btrfs quota rescan -w             "/mnt-${LAB}"

ROOT="/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot"
mkdir  -p                         "/${ROOT}/home/.snapshots"

umount                            "/mnt-${LAB}"
rmdir                             "/mnt-${LAB}"
