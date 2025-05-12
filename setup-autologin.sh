mkdir -p /etc/systemd/system/{console-getty,getty@tty1}.service.d

# for container
cat <<EOF > /etc/systemd/system/console-getty.service.d/autologin.conf
[Service]
ExecStart=
ExecStartPre=-/usr/bin/sed -i '/pam_loginuid.so/d' /etc/pam.d/login
ExecStart=-/sbin/agetty --autologin root --noclear --keep-baud console 115200 38400 9600 vt
EOF

# for actual tty
cat <<EOF > /etc/systemd/system/getty@tty1.service.d/autologin.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear %I \$TERM
EOF

systemctl enable getty@tty1.service
