#!/bin/sh
#btrfs layout https://en.opensuse.org/SDB:BTRFS

set -e

LAB=${1:-root}
PREFIX=${2:-@}

mkdir                             "/mnt-${LAB}"
mount  -L "${LAB}" -o subvolid=5  "/mnt-${LAB}"

btrfs subvolume create            "/mnt-${LAB}/${PREFIX}"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/home"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/opt"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/srv"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/var"
chattr +C                         "/mnt-${LAB}/${PREFIX}/var"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/.snapshots"
mkdir  -p                         "/mnt-${LAB}/${PREFIX}/.snapshots/init"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot"

if [[ "$PREFIX" = "@" ]]; then
	btrfs subvolume set-default   "/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot"
fi

btrfs quota enable                "/mnt-${LAB}"
btrfs quota rescan -w             "/mnt-${LAB}"

ROOT="/mnt-${LAB}/${PREFIX}/.snapshots/init/snapshot"
mkdir  -p                         "/${ROOT}/"{efi,boot/efi,home,opt,srv,var,.snapshots}

umount                            "/mnt-${LAB}"
rmdir                             "/mnt-${LAB}"
