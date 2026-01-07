#! /usr/bin/env bash

sfdisk --delete /dev/nvme0n1
swapoff /mnt/.swapfile
umount /mnt/boot
umount /mnt
