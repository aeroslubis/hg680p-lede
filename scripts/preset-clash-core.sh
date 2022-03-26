#!/bin/bash
#=================================================
# File name: preset-clash-core.sh
# Usage: <preset-clash-core.sh $platform> | example: <preset-clash-core.sh armv8>
# System Required: Linux
# Version: 3.0
# Lisence: MIT
# Author: SuLingGG, Helmi Amirudin
# Blog: https://helmiau.com
# Description: This script will install clash core kernel from Dreamacro or Meta or Vernesong
#=================================================
# Select core	: Remove # symbol from first word of wget line
# Unselect core	: Add # symbol at first word from wget line
#=================================================

# Initial recognition
COREDIR="$(pwd)/amlogic-s9xxx/common-files/files/etc/openclash/core"
APIGIT="https://api.github.com/repos"
mkdir -p $COREDIR

# TEST debug
# curl -sL https://api.github.com/repos/Dreamacro/clash/releases | grep /clash-linux-armv8 | awk -F '"' '{print $4}' | awk 'NR==1 {print; exit}'

# Vernesong Core has:
# - original core
# - tun premium core
# - tun game core
clash_url=$(curl -sL $APIGIT/vernesong/OpenClash/releases/tags/Clash | grep /clash-linux-$1 | awk -F '"' '{print $4}')
clash_tun_url=$(curl -sL $APIGIT/vernesong/OpenClash/releases/tags/TUN-Premium | grep /clash-linux-$1 | awk -F '"' '{print $4}')
clash_game_url=$(curl -sL $APIGIT/vernesong/OpenClash/releases/tags/TUN | grep /clash-linux-$1 | awk -F '"' '{print $4}')
wget -qO- $clash_url | tar xOvz > $COREDIR/clash
wget -qO- $clash_tun_url | gunzip -c > $COREDIR/clash_tun
wget -qO- $clash_game_url | tar xOvz > $COREDIR/clash_game

# Dreamacro Core has:
# - original core
# - tun premium core
# Please use tun game core from Meta or Vernesong core
clash_dreamacro=$(curl -sL $APIGIT/Dreamacro/clash/releases | grep /clash-linux-$1 | awk -F '"' '{print $4}' | sed -n '1p')
clash_tun_dreamacro=$(curl -sL $APIGIT/Dreamacro/clash/releases/tags/premium | grep /clash-linux-$1 | awk -F '"' '{print $4}')
wget -qO- $clash_dreamacro | gunzip -c > $COREDIR/clash_dreamacro
wget -qO- $clash_tun_dreamacro | gunzip -c > $COREDIR/clash_tun_dreamacro

# Clash Meta Core has:
# - tun premium core
# Please use original and tun game core from Dreamacro or Vernesong core
# Docs: https://github.com/MetaCubeX/Clash.Meta/tree/Dev
clash_tun_meta=$(curl -sL $APIGIT/MetaCubeX/Clash.Meta/releases | grep /Clash.Meta-linux-$1 | awk -F '"' '{print $4}' | sed -n '1p')
wget -qO- $clash_tun_meta | gunzip -c > $COREDIR/clash_tun_meta

chmod +x $COREDIR/clash*

# Offline images sources
YACD="$(pwd)/amlogic-s9xxx/common-files/files/www/luci-static/resources/openclash"
mkdir -p $YACD
wget -qO $YACD/Wiki.svg https://img.shields.io/badge/Wiki--lightgrey?logo=GitBook&style=social
wget -qO $YACD/Tutorials.svg https://img.shields.io/badge/Tutorials--lightgrey?logo=Wikipedia&style=social
wget -qO $YACD/Star.svg https://img.shields.io/badge/Star--lightgrey?logo=github&style=social
wget -qO $YACD/Telegram.svg https://img.shields.io/badge/Telegram--lightgrey?logo=Telegram&style=social
wget -qO $YACD/Sponsor.svg https://img.shields.io/badge/Sponsor--lightgrey?logo=ko-fi&style=social
