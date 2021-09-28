#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic S9xxx STB
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate

# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Uniform name for network
# sed -i "1i sed -i 's/ifname/device/g' /etc/config/network" package/base-files/files/etc/rc.local
#
# ------------------------------- Main source ends -------------------------------


# ------------------------------- Lienol started -------------------------------
# Add firewall rules
zzz_iptables_row=$(sed -n '/iptables/=' package/default-settings/files/zzz-default-settings | head -n 1)
zzz_iptables_tcp=$(sed -n ${zzz_iptables_row}p  package/default-settings/files/zzz-default-settings | sed 's/udp/tcp/g')
sed -i "${zzz_iptables_row}a ${zzz_iptables_tcp}" package/default-settings/files/zzz-default-settings
sed -i 's/# iptables/iptables/g' package/default-settings/files/zzz-default-settings

# Set default language and time zone
sed -i 's/luci.main.lang=en_us/luci.main.lang=auto/g' package/default-settings/files/zzz-default-settings
sed -i 's/zonename=Asia\/Shanghai/zonename=Asia\/Jakarta/g' package/default-settings/files/zzz-default-settings
#sed -i 's/timezone=CST-8/timezone=CST-9/g' package/default-settings/files/zzz-default-settings

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini} 2>/dev/null
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Modify some code adaptation
# sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile

# Add luci-theme
# svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-theme-bootstrap-mod package/luci-theme-bootstrap-mod
#
# ------------------------------- Lienol ends -------------------------------


# ------------------------------- Other started -------------------------------
#
# Add luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/trunk package/openwrt-passwall
rm -rf package/openwrt-passwall/{kcptun,xray-core} 2>/dev/null

# Add luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/openwrt-openclash
pushd package/openwrt-openclash/tools/po2lmo && make && sudo make install 2>/dev/null && popd

# Add luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/{luci-app-ssr-plus,shadowsocksr-libev} package/openwrt-ssrplus
rm -rf package/openwrt-ssrplus/luci-app-ssr-plus/po/zh_Hans 2>/dev/null

# ------------------------------- Other ends -------------------------------
