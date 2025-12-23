#! /usr/bin/env bash

echo -e "\e[1;32mpreping area\e[0m"

sfdisk --delete /dev/nvme0n1

echo -e "\e[1;32mpartition setup\e[0m"

fdisk /dev/nvme0n1 <<EOF
g
n
1
2048
+500M
t
1
n
2


w
EOF

echo -e "\e[1;32mfile system setup\e[0m"

mkfs.fat -F 32 /dev/nvme0n1p1
fatlabel /dev/nvme0n1p1 NIXBOOT
mkfs.ext4 /dev/nvme0n1p2 -L NIXROOT <<EOF
y
EOF

echo -e "\e[1;32mmounting file systems\e[0m"
mount /dev/disk/by-label/NIXROOT /mnt

mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

echo -e "\e[1;32mswap setup\e[0m"

dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152
chmod 600 /mnt/.swapfile
mkswap -L NIXSWAP /mnt/.swapfile
swapon /mnt/.swapfile

echo -e "\e[1;32starting nixos installation\e[0m"

cd /mnt
nixos-install --impure --flake  /etc/iso-utils#dev-box
