#!/bin/bash
# 步骤1: 检查文件完整性
# 增加详细日志和校验

set -e

# 日志函数
log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

echo "=========================================="
log "🚀 步骤1: 检查文件完整性"
echo "=========================================="

MISSING=0

# 1. 检查 idbloader.img
if [ ! -f "idbloader.img" ]; then
    log "❌ 缺少文件: idbloader.img"
    MISSING=1
else
    SIZE=$(stat -f%z idbloader.img)
    SHA=$(shasum -a 256 idbloader.img | awk '{print $1}')
    log "✅ 发现 idbloader.img"
    log "   - 大小: $SIZE 字节 ($(($SIZE / 1024)) KB)"
    log "   - SHA256: $SHA"
fi

echo "------------------------------------------"

# 2. 检查 u-boot.itb
if [ ! -f "u-boot.itb" ]; then
    log "❌ 缺少文件: u-boot.itb"
    MISSING=1
else
    SIZE=$(stat -f%z u-boot.itb)
    SHA=$(shasum -a 256 u-boot.itb | awk '{print $1}')
    log "✅ 发现 u-boot.itb"
    log "   - 大小: $SIZE 字节 ($(($SIZE / 1024 / 1024)) MB)"
    log "   - SHA256: $SHA"
fi

echo "------------------------------------------"

# 3. 检查系统镜像
SYSUPGRADE_GZ=$(ls istoreos-*-squashfs-sysupgrade.img.gz 2>/dev/null | head -1)
SYSUPGRADE_IMG=$(ls istoreos-*-squashfs-sysupgrade.img 2>/dev/null | head -1)

if [ -z "$SYSUPGRADE_GZ" ] && [ -z "$SYSUPGRADE_IMG" ]; then
    log "❌ 缺少文件: istoreos-*-squashfs-sysupgrade.img[.gz]"
    MISSING=1
elif [ -n "$SYSUPGRADE_IMG" ]; then
    SIZE=$(stat -f%z "$SYSUPGRADE_IMG")
    log "✅ 发现已解压镜像: $SYSUPGRADE_IMG"
    log "   - 大小: $SIZE 字节 ($(($SIZE / 1024 / 1024)) MB)"
elif [ -n "$SYSUPGRADE_GZ" ]; then
    SIZE=$(stat -f%z "$SYSUPGRADE_GZ")
    log "✅ 发现压缩镜像: $SYSUPGRADE_GZ"
    log "   - 大小: $SIZE 字节 ($(($SIZE / 1024 / 1024)) MB)"
fi

echo "=========================================="

if [ $MISSING -eq 1 ]; then
    log "⚠️  错误: 缺少必要文件，请确保以下文件存在:"
    echo "   1. idbloader.img"
    echo "   2. u-boot.itb"
    echo "   3. istoreos-*-sysupgrade.img.gz"
    exit 1
fi

log "✅ 所有文件检查通过"
echo ""
