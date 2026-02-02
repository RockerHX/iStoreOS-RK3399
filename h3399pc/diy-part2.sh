#!/bin/bash
#===============================================
# Description: DIY script part 2 - 添加 H3399PC 设备支持
# File name: diy-part2.sh
# Author: RockerHX
#===============================================

echo "=========================================="
echo "添加 ShareVDI H3399PC 设备支持"
echo "=========================================="

# 1. 在 armv8.mk 中添加 H3399PC 设备定义
echo "正在添加 H3399PC 设备定义到 armv8.mk..."
cat >> target/linux/rockchip/image/armv8.mk << 'EOF'

define Device/sharevdi_h3399pc
  DEVICE_VENDOR := ShareVDI
  DEVICE_MODEL := H3399PC
  SOC := rk3399
  UBOOT_DEVICE_NAME := h3399pc-rk3399
  IMAGE/sdcard.img.gz := boot-common | boot-script | rockchip-img | gzip | append-metadata
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
  DEVICE_PACKAGES := kmod-r8168 kmod-usb3 -wpad-basic-mbedtls -urngd
endef
TARGET_DEVICES += sharevdi_h3399pc
EOF

echo "✓ 设备定义已添加"

# 2. 复制 U-Boot Makefile
if [ -f "$GITHUB_WORKSPACE/h3399pc/uboot-rockchip/Makefile" ]; then
  echo "正在复制 U-Boot Makefile..."
  cp -f "$GITHUB_WORKSPACE/h3399pc/uboot-rockchip/Makefile" package/boot/uboot-rockchip/Makefile
  echo "✓ U-Boot Makefile 已复制"
fi

# 3. 复制 U-Boot patch (如果存在)
if [ -f "$GITHUB_WORKSPACE/h3399pc/uboot-rockchip/patches/987-rk3399-h3399pc-uboot.patch" ]; then
  echo "正在复制 U-Boot patch..."
  cp -f "$GITHUB_WORKSPACE/h3399pc/uboot-rockchip/patches/987-rk3399-h3399pc-uboot.patch" \
    package/boot/uboot-rockchip/patches/987-rk3399-h3399pc-uboot.patch
  echo "✓ U-Boot patch 已复制"
fi

# 4. 复制 kernel patch (添加 DTS)
if [ -f "$GITHUB_WORKSPACE/h3399pc/kernel-rockchip/patches/987-rockchip-rk3399-h3399pc-kernel.patch" ]; then
  echo "正在复制 kernel patch..."
  cp -f "$GITHUB_WORKSPACE/h3399pc/kernel-rockchip/patches/987-rockchip-rk3399-h3399pc-kernel.patch" \
    target/linux/rockchip/patches-6.6/987-rockchip-rk3399-h3399pc-kernel.patch
  echo "✓ Kernel patch 已复制"
fi

# 5. 复制网络配置
if [ -f "$GITHUB_WORKSPACE/h3399pc/kernel-rockchip/02_network" ]; then
  echo "正在复制网络配置..."
  cp -f "$GITHUB_WORKSPACE/h3399pc/kernel-rockchip/02_network" \
    target/linux/rockchip/armv8/base-files/etc/board.d/02_network
  echo "✓ 网络配置已复制"
fi

echo "=========================================="
echo "H3399PC 设备支持添加完成!"
echo "配置: 纯软路由模式 (无 WiFi/蓝牙)"
echo "=========================================="
