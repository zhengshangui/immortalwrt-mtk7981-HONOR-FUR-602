#!/bin/bash
set -e -o pipefail

# 修复CI环境git弹窗账号询问报错128
git config --global core.askPass ""
git config --global credential.helper ""
git config --global --unset http.proxy
git config --global --unset https.proxy

# ghproxy加速镜像地址
# GHPROXY="https://mirror.ghproxy.com/"
GHPROXY=""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OPENWRT_DIR="${OPENWRT_DIR:-$(pwd)}"

cd "${OPENWRT_DIR}"

UPDATE_PACKAGE() {
	local pkg_name="$1"
	local pkg_repo="$2"
	local pkg_branch="$3"
	local pkg_dir="$4"

	rm -rf "package/${pkg_name}"
	# 拼接ghproxy镜像前缀
	git clone --depth 1 --branch "${pkg_branch}" "${GHPROXY}https://github.com/${pkg_repo}.git" "package/${pkg_name}"
	if [ -n "${pkg_dir}" ]; then
		mv "package/${pkg_name}/${pkg_dir}"/* "package/${pkg_name}/"
	fi
	rm -rf "package/${pkg_name}/.git"
	echo "fetched ${pkg_name}"
}

# ==========第三方插件拉取列表==========
# OpenAppFilter
UPDATE_PACKAGE "luci-app-appfilter" "openwrt-develop/OpenAppFilter" "main" ""

# MosDNS
UPDATE_PACKAGE "luci-app-mosdns" "sbwml/luci-app-mosdns" "v5" ""

# netspeedtest 测速
UPDATE_PACKAGE "luci-app-netspeedtest" "sirpdboy/luci-app-netspeedtest" "main" ""

# openlist2
UPDATE_PACKAGE "luci-app-openlist2" "sirpdboy/openlist2" "main" ""

# partexp
UPDATE_PACKAGE "luci-app-partexp" "sirpdboy/luci-app-partexp" "main" ""

# quickfile
UPDATE_PACKAGE "luci-app-quickfile" "sirpdboy/luci-app-quickfile" "main" ""

# mwan3helper
UPDATE_PACKAGE "luci-app-mwan3helper" "sirpdboy/luci-app-mwan3helper" "main" ""

echo "===== all plugins fetched done ====="
