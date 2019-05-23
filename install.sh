#!/bin/bash

echo "[*] Install dependencies could take.."
# banner plus install
wget https://raw.githubusercontent.com/hdm/scan-tools/master/nse/banner-plus.nse
cp banner-plus.nse /usr/share/nmap/scripts/

# Vulners install
wget https://raw.githubusercontent.com/vulnersCom/nmap-vulners/master/vulners.nse

# vulscan install
git clone https://github.com/scipag/vulscan
ln -s `pwd`/vulscan /usr/share/nmap/scripts/vulscan