echo -e "\e[1;32mpartition setup\e[0m"

fdisk /dev/sda <<EOF
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

lsblk
mkfs.fat -F 32 /dev/sda1 -n NIXBOOT
mkfs.ext4 /dev/sda2 -L NIXROOT <<EOF
y
EOF

echo -e "\e[1;32mmounting file systems\e[0m"
mount /dev/disk/by-label/NIXROOT /mnt

mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

echo -e "\e[1;32mswap setup\e[0m"

dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152
chmod 600 /mnt/.swapfile
mkswap /mnt/.swapfile
swapon /mnt/.swapfile
