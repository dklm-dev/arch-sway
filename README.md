# arch-sway

# ----------------------------------
# Arch GNU/Linux Installation Script
# ----------------------------------

# rfkill.
rfkill unblock wifi
rfkill list

# iwctl.
iwctl station wlan0 scan
iwctl station wlan0 get-networks
iwctl station wlan0 connect [network-name]

# check the connection.
ping -c 5 archlinux.org

# fdisk.
fdisk /dev/nvme1n1

d - delete all partitions
g - create new GPT table
n - create new partitions
t - define partition format

1 - partition is EFI (+512M)
2 - partition is Linux Filesystem (All disk space)

# formatting the partitions.
mkfs.fat -F32 /dev/nvme1n1p1
mkfs.ext4 /dev/nvme1n1p2

# mounting the root partition.
mount /dev/nvme1n1p2 /mnt
mkdir -p ~/boot/efi
mount /dev/nvme1n1p1 /mnt/boot/efi

# install the base system
pacstrap /mnt base linux linux-firmware vi vim nano sudo networkmanager

# fstab generation
genfstab -U /mnt >> /mnt/etc/fstab

# chroot into the new system
arch-chroot /mnt

# set the time zone
ln -sf /usr/share/zoneinfo/Europe/Kyiv /etc/localtime
hwclock --systohc

# localization
nano /etc/locale.gen
uncomment: en_US.UTF-8 UTF-8
locale-gen
nano /etc/locale.conf
LANG=en_US.UTF-8

# hostname
echo "hostname" > /etc/hostname
nano /etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.1.1 hostname.localdomain    hostname

# set root password
passwd

# install grub efibootmgr
pacman -S grub efibootmgr

# install GRUB bootloader
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# umount
exit
umount -R /mnt
poweroff
