#!/bin/bash

set -euo pipefail

pacman-key --init
pacman-key --populate archlinuxarm
pacman-key --recv-key 6290731A5B773E16 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 6290731A5B773E16

pacman -U 'https://aarchd.who53.me/repo/aarchd-keyring-1.0-1-any.pkg.tar.zst' --noconfirm
pacman -U 'https://aarchd.who53.me/repo/aarchd-mirrorlist-1.0-1-any.pkg.tar.zst' --noconfirm

if ! grep -q '^\[aarchd\]' /etc/pacman.conf; then
    if core_line=$(grep -n '^\[core\]' /etc/pacman.conf | cut -d: -f1); then
        insert_line=$((core_line - 1))
        sed -i "${insert_line}i\\
\\
[aarchd]\\
Include = /etc/pacman.d/aarchd-mirrorlist
" /etc/pacman.conf
    else
        echo "Error: Could not find [core] repo in /etc/pacman.conf" >&2
        exit 1
    fi
fi

# set SigLevel to default
sed -i "s/^[[:space:]]*SigLevel[[:space:]]*=.*$/SigLevel = Required DatabaseOptional/" "/etc/pacman.conf"
# other stuff 
sed -i '/^#Color/s/^#//' /etc/pacman.conf && sed -i '/^Color$/a ILoveCandy' /etc/pacman.conf

pacman -Syyu --noconfirm
