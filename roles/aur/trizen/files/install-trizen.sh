#!/bin/sh -e

rm -rf /tmp/trizen && git clone https://aur.archlinux.org/trizen.git /tmp/trizen && cd /tmp/trizen || exit
makepkg -si --noconfirm
