echo "partition setup"

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

echo "file system setup"

mkfs.fat -F 32 /dev/nvme0n1p1
fatlabel /dev/nvme0n1p1 NIXBOOT
mkfs.ext4 /dev/nvme0n1p2 -L NIXROOT

echo "mounting file systems"
mount /dev/disk/by-label/NIXROOT /mnt

mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

echo "swap setup"

dd if=/dev/zero of=/mnt/.swapfile bs=1024 count=2097152
chmod 600 /mnt/.swapfile
mkswap /mnt/.swapfile
swapon /mnt/.swapfile
