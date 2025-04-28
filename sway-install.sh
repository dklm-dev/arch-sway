#!/bin/bash

echo "[+] Updating package list..."
sudo pacman -Syu --noconfirm

echo "[+] Installing Sway..."
sudo pacman -S sway swaybg swayidle swaylock waybar --noconfirm

echo "[+] Installing Kitty terminal..."
sudo pacman -S kitty --noconfirm

echo "[+] Installing Ly DM"
sudo pacman -S base-devel 
git clone https://aur.archlinux.org/yay.git
cd ~/yay
sudo makepkg -si

echo "[+] Verifying the installation..."
sudo pacman -Q yay

echo "[+] Creating Sway configuration file..."
if [ ! -f ~/.config/sway/config ]; then
    mkdir -p ~/.config/sway
    cp /etc/sway/config ~/.config/sway/
fi

echo "[+] Installation complete!"

sudo systemctl enable ly
sudo systemctl start ly
