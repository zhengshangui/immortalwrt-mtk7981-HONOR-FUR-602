# ===================== 此处粘贴你原来全部的 diy‑part1.sh 原有代码 =====================
# 例如feeds修改、软件包开关、config修改等全部原有逻辑放在下面
#!/bin/bash
set -e
# binutils 2.42 musl 修复，保留2.42版本
cat >> toolchain/binutils/Makefile <<'EOM'
EXTRA_CFLAGS += -D_LARGEFILE64_SOURCE
EOM
# 下面保留你原来diy-360T7-hanwckf-1.sh全部原有代码



#!/bin/bash
#
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

