#!/bin/bash
set -e

# 设备树源文件（仓库根目录）
DTS_SRC="../mt7981b-honor-fur-602.dts"
DTS_DST="target/linux/mediatek/dts/mt7981b-honor-fur-602.dts"
FILOGIC_MK="target/linux/mediatek/image/filogic.mk"

# 复制设备树
cp -f "${DTS_SRC}" "${DTS_DST}"
echo "[diy] copied dts -> ${DTS_DST}"

# filogic.mk注册设备dtb
if ! grep -q "mt7981b-honor-fur-602.dtb" "${FILOGIC_MK}";then
echo 'define Device/honor_fur-602
  DEVICE_VENDOR := Honor
  DEVICE_MODEL := FUR-602
  DEVICE_ALT0_VENDOR := RuiJie
  DEVICE_ALT0_MODEL := SR503
  DEVICE_DTS := mt7981b-honor-fur-602
  DEVICE_PACKAGES := kmod-mt7981-firmware mt7981-eeprom
endef
TARGET_DEVICES += honor_fur-602' >> "${FILOGIC_MK}"
echo "[diy] append filogic.mk device entry"
fi

# uci‑defaults：修改web页面显示型号，不修改主机名
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99_fake_model <<'EOF'
#!/bin/sh
# 仅修改网页概览页面型号展示，hostname保持honor‑fur‑602不变
[ -f /etc/board.json ] && sed -i 's/"model":{"name":"Honor FUR‑602"/"model":{"name":"RuiJie SR503"/g' /etc/board.json
exit 0
EOF
chmod +x files/etc/uci-defaults/99_fake_model
echo "[diy] uci-defaults fake model done"
