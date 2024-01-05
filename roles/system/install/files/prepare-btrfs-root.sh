#!/bin/bash

# btrfs layout https://en.opensuse.org/SDB:BTRFS

set -e

LAB=${1:-root}
PREFIX=${2:-@}
ROOT="/mnt-${LAB}/${PREFIX}/.snapshots/1/snapshot"

umask '0022'

mkdir                             "/mnt-${LAB}"
mount  -L "$LAB" -o subvolid=5    "/mnt-${LAB}"

mkdir -p                          "/mnt-${LAB}/${PREFIX}"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/.snapshots"
mkdir -p                          "/mnt-${LAB}/${PREFIX}/.snapshots/1"
btrfs subvolume create            "$ROOT"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/srv"
btrfs subvolume create            "/mnt-${LAB}/${PREFIX}/var"
chattr +C                         "/mnt-${LAB}/${PREFIX}/var"

cat <<HEREDOC > "/mnt-${LAB}/${PREFIX}/.snapshots/1/info.xml"
<?xml version="1.0"?>
<snapshot>
  <type>single</type>
  <num>1</num>
  <date>$(/usr/bin/date --rfc-3339=seconds)</date>
  <description>first root filesystem</description>
</snapshot>
HEREDOC

if [[ "$PREFIX" = "@" ]]; then
	btrfs subvolume set-default   "$ROOT"
fi

# quota makes btrfs slow
# btrfs quota enable                "/mnt-${LAB}"
# btrfs quota rescan -w             "/mnt-${LAB}"

mkdir  -p                         "/${ROOT}/"{.snapshots,boot,efi,home,srv,var}

umount -R                         "/mnt-${LAB}"
rmdir                             "/mnt-${LAB}"
