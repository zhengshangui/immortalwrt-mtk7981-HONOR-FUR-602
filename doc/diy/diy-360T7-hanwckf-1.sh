#!/bin/bash
set -e
# binutils 2.42 musl 修复，保留2.42版本
cat >> toolchain/binutils/Makefile <<'EOM'
EXTRA_CFLAGS += -D_LARGEFILE64_SOURCE
EOM

# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 添加第三方软件包
#git clone https://github.com/kenzok8/openwrt-packages.git package/openwrt-packages
#git clone https://github.com/kenzok8/small-package package/small-package
#git clone https://github.com/Zxilly/UA2F package/UA2F

# ========== 执行feeds更新 ==========
./scripts/feeds update -a

# ========= 修复 rd05a1 循环依赖：仅文件存在时执行 =========
if [ -f feeds/mt_wifi/package/rd05a1/Kconfig ]; then
    sed -i '/depends on PACKAGE_rd05a1/d' feeds/mt_wifi/package/rd05a1/Kconfig
fi

# ========= feeds安装 =========
./scripts/feeds install -a
