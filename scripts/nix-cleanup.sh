#! /usr/bin/env bash

sgdisk --zap-all /dev/sda
blockdev --rereadpt /dev/sda

swapoff /mnt/.swapfile
umount /mnt/boot
umount /mnt
