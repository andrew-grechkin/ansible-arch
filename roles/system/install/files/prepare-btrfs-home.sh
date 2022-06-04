#!/bin/sh

set -e

LAB=${1:-home}
PREFIX=${2:-@}
ROOT="/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot"

mkdir                             "/mnt-${LAB}"
mount  -L "${LAB}" -o subvolid=5  "/mnt-${LAB}"

mkdir  -p                         "/mnt-${LAB}/${PREFIX}"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/.snapshots"
mkdir  -p                         "/mnt-${LAB}/${PREFIX}/.snapshots/init"
btrfs subvolume create            "${ROOT}"
btrfs subvolume create            "${ROOT}/motion"
chgrp video                       "${ROOT}/motion"
chmod u+rwX,g+rwXs,o-rwx          "${ROOT}/motion"
chattr +C                         "${ROOT}/motion"

if [[ "$PREFIX" = "@" ]]; then
	btrfs subvolume set-default   "${ROOT}"
fi

# quota makes btrfs slow
#btrfs quota enable                "/mnt-${LAB}"
#btrfs quota rescan -w             "/mnt-${LAB}"

mkdir  -p                         "/${ROOT}/.snapshots"

umount                            "/mnt-${LAB}"
rmdir                             "/mnt-${LAB}"
