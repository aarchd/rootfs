#!/bin/bash

set -euo pipefail

pacman-key --init
pacman-key --populate archlinuxarm
pacman-key --recv-key 570F4CC81244C788 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 570F4CC81244C788

curl -LO https://aarchd.github.io/repo/aarchd-keyring-1.0-1-any.pkg.tar.zst
pacman -U aarchd-keyring-1.0-1-any.pkg.tar.zst --noconfirm
curl -LO https://aarchd.github.io/repo/aarchd-mirrorlist-1.0-1-any.pkg.tar.zst
pacman -U aarchd-mirrorlist-1.0-1-any.pkg.tar.zst --noconfirm

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

pacman -Syyu --noconfirm

find "/etc" -type f -name '*.pacnew' | while read -r pacnew; do
  orig="${pacnew%.pacnew}"
  echo "Replacing $orig with $pacnew"
  mv -f "$pacnew" "$orig"
done
sed -i "s/^[[:space:]]*\(CheckSpace\)/# \1/" "/etc/pacman.conf"
