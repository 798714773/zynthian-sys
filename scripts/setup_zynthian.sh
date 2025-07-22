#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Standalone Setup Script
# 
# Setup zynthian from scratch in a completely fresh minibian-jessie image.
# No need for nothing else. Only run the script twice, following the next
# instructions:
#
# 1. Run first time: sh ./setup_zynthian.sh
# 2. Reboot: It should reboot automaticly after step 1
# 3. Run second time: screen -t setup -L sh ./setup_zynthian.sh
# 4. Take a good beer, sit down and relax ... ;-)
# 
# Copyright (C) 2015-2024 Fernando Moyano <jofemodo@zynthian.org>
#
#******************************************************************************
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
# 
#******************************************************************************
cd /boot
echo -n "zyn:" > userconf.txt
echo 'opensynth' | openssl passwd -6 -stdin >> userconf.txt
touch ssh

cd

# 注释掉前三行
sed -i -e '1 s/^deb/#deb/' -e '2 s/^deb/#deb/' -e '3 s/^deb/#deb/' /etc/apt/sources.list

# 修改成清华源
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list

echo "deb https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/ bookworm main" >> /etc/apt/sources.list.d/raspi.list

# multimedia
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-multimedia/ bookworm main non-free" >> /etc/apt/sources.list
wget https://mirrors.tuna.tsinghua.edu.cn/debian-multimedia/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb
dpkg -i deb-multimedia-keyring_2024.9.1_all.deb

# pip3换源
mkdir -p ~/.pip
cat > ~/.pip/pip.conf << EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
timeout = 600
EOF

echo `date` >  ~/.wiggled

if [ ! -d "zynthian-sys" ]; then
	apt-get update
	apt-get -y install git screen cmake python3-alsaaudio libqt6svg6-dev
	git clone -b oram https://github.com/798714773/zynthian-sys.git
fi
cd zynthian-sys/scripts
./setup_system_raspioslite_64bit_bookworm.sh
cd
rm -rf zynthian-sys


