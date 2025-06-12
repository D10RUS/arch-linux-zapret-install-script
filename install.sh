#!/bin/sh
if [ "$1" != "-f" ]; then
    set -e
fi

if [ "$(id -u)" != 0 ]; then
    echo "You don't have root privileges! (sudo ./install.sh)"
    exit 1
fi

pacman -S --needed --noconfirm git libnetfilter_queue dnscrypt-proxy

DIR=$PWD
cd /opt
git clone https://github.com/bol-van/zapret.git
cd "$DIR"
cp ./zapret-hosts-user.txt /opt/zapret/ipset/
cp ./config /opt/zapret/
cd /opt/zapret
yes "" | ./install_prereq.sh
yes "" | ./install_easy.sh

systemctl enable --now dnscrypt-proxy.service
systemctl enable --now systemd-resolved.service

cd "$DIR"
cp ./dnscrypt-proxy.toml /etc/dnscrypt-proxy/
cp ./resolv.conf /etc/resolv.conf
chattr +i /etc/resolv.conf

echo -e "\033[32mSUCCESSFUL/УСПЕШНО\033[0m"
