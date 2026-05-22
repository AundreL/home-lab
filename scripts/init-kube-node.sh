#! /usr/bin/env bash

# exit immediately if a command exits with a non-zero status
set -e

# target disk
echo -e "\e[1;32mpartition setup\e[0m"

DISK="/dev/sda"
PART_BOOT="${DISK}1"
PART_ROOT="${DISK}2"

sgdisk --zap-all /dev/sda
blockdev --rereadpt /dev/sda

echo -e "\e[1;34msetp 1: partitioning ${DISK} via sfdisk...\e[0m"

# create gpt label and partitions non-interactively
sfdisk --force --wipe=always --no-reread "$DISK" <<EOF
label:gpt

# Partition 1: Boot/EFI (500MB)
, 500M, U, *

# Partition 2: Root/Data (Rest of the disk)
,,L
EOF

# force kernel wait and register the new partition table
blockdev --rereadpt /dev/sda
udevadm settle

echo -e "\e[1;32mstep 2: formatting filesystems...\e[0m"
# format efi boot partition as fat32
mkfs.fat -F 32 "$PART_BOOT" -n NIXBOOT

udevadm trigger --action=change /dev/sda1
udevadm settle

# format root partition as ext4
mkfs.ext4 -F "$PART_ROOT" -L NIXROOT

udevadm trigger --action=change /dev/sda2
udevadm settle
echo -e "\e[1;32mstep 3: mounting filesystems for NixOS installation...\e[0m"

lsblk -fl
# mount the root partition to /mnt
mount /dev/disk/by-label/NIXROOT /mnt

# mount the efi partition
mkdir /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

lsblk -fl

echo -e "\e[1;34mstep 4: creating 8GB swap file for compilation stability...\e[0m"
# instantly allocate 8gb space on the target filesystem

fallocate -l 8G /mnt/swapfile

# secure the file (critical: swap files must be 600)
chmod 600 /mnt/swapfile

# label and format the swap space
mkswap -L NIXSWAP /mnt/swapfile
swapon /mnt/swapfile

echo -e "\e[1;32mstep 5: starting NixOS installation...\e[0m"
cd /mnt
# run the installation using your target flake
nixos-install --impure --flake /etc/iso-utils/flakes#kube-node

echo -e "\e[1;34mDisk preparation and installation process complete!\e[0m"
