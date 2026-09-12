#!/bin/bash
set -e -o pipefail

DTS_SRC="../mt7981b-honor-fur-602.dts"
DTS_DST="target/linux/mediatek/dts/mt7981b-honor-fur-602.dts"
FILOGIC_MK="target/linux/mediatek/image/filogic.mk"
NETWORK_FILE="target/linux/mediatek/filogic/base-files/etc/board.d/02_network"

# 复制设备树文件，增加文件存在判断容错
if [ -f "$DTS_SRC" ]; then
	cp -f "$DTS_SRC" "$DTS_DST"
	echo "[diy‑part2] installed dts: $DTS_DST"
else
	echo "[diy‑part2] WARNING: mt7981b-honor-fur-602.dts 文件缺失！"
fi

# 向 filogic.mk 添加设备条目，避免重复写入
if ! grep -q "honor_fur602" "$FILOGIC_MK"; then
cat >> "$FILOGIC_MK" <<EOF
define Device/honor_fur602
  DEVICE_VENDOR := Honor
  DEVICE_MODEL := FUR‑602
  DEVICE_DTS := mt7981b-honor-fur-602
  DEVICE_DTS_DIR := ../dts
  DEVICE_PACKAGES := kmod-mt_wifi mtwifi-cfg
  SUPPORTED_DEVICES := honor,fur‑602
endef
TARGET_DEVICES += honor_fur602
EOF
	echo "[diy‑part2] added device entry to filogic.mk"
fi

# 02_network网口映射，不存在才追加
if ! grep -q "honor,fur‑602" "$NETWORK_FILE"; then
sed -i '/mediatek,filogic)/a\
\t\thonor,fur‑602)\
\t\t\tlan_mac=\$(macaddr_2_sub_e 1)\
\t\t\twan_mac=\$(macaddr_2_sub_e 2)\
\t\t\tucidef_set_interfaces_lan_wan "eth0" "eth1"\
\t\t\t;;' "$NETWORK_FILE"
	echo "[diy‑part2] added network board.d config"
fi

# .config 屏蔽datconf 、conninfra，解决24.10编译报错
sed -i '/CONFIG_PACKAGE_datconf/d' .config
echo "# CONFIG_PACKAGE_datconf is not set" >> .config

sed -i '/CONFIG_PACKAGE_conninfra/d' .config
echo "# CONFIG_PACKAGE_conninfra is not set" >> .config

echo "[diy‑part2.sh] All patches finished"
