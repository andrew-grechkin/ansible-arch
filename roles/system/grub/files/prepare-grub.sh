#!/bin/bash

rm -f  /boot/*.png
rm -rf /boot/EFI/BOOT
rm -rf /boot/EFI/tools

grub-install --removable --efi-directory=/boot --force

grub-mkconfig -o /boot/grub/grub.cfg
