#!/bin/sh

set -e

LAB=${1:-root}
PREFIX=${2:-@}

mount  -L "${LAB}" -o "subvol=${PREFIX}/.snapshots/init/snapshot"       /mnt
mount  -L "${LAB}" -o "subvol=${PREFIX}/.snapshots"                     /mnt/.snapshots
mount  -L "${LAB}" -o "subvol=${PREFIX}/srv"                            /mnt/srv
mount  -L "${LAB}" -o "subvol=${PREFIX}/var"                            /mnt/var
