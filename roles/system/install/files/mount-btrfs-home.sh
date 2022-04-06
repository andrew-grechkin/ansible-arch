#!/bin/sh

set -e

LAB=${1:-home}
PREFIX=${2:-@}

mount  -L "${LAB}" -o "subvol=${PREFIX}"             /mnt/home
mount  -L "${LAB}" -o "subvol=${PREFIX}/.snapshots"  /mnt/home/.snapshots
