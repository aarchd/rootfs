#!/bin/bash

set -euo pipefail

pacman-key --init
pacman-key --populate archlinuxarm
pacman-key --recv-key 6290731A5B773E16 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 6290731A5B773E16

pacman -U 'https://aarchd.who53.me/repo/aarchd-keyring-1.0-1-any.pkg.tar.zst' --noconfirm
pacman -U 'https://aarchd.who53.me/repo/aarchd-mirrorlist-1.0-1-any.pkg.tar.zst' --noconfirm

echo "[aarchd]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/aarchd-mirrorlist" >> /etc/pacman.conf

# set SigLevel to default
sed -i "s/^[[:space:]]*SigLevel[[:space:]]*=.*$/SigLevel = Required DatabaseOptional/" "/etc/pacman.conf"

pacman -Syyu --noconfirm
