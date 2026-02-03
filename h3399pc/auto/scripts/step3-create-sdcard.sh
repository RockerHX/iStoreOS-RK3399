#!/bin/bash
# 步骤3: 创建 sdcard.img
# 增加详细日志

set -e

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

echo "=========================================="
log "🚀 步骤3: 创建工作镜像 sdcard.img"
echo "=========================================="

# 查找解压后的镜像
SYSUPGRADE_IMG=$(ls istoreos-*-squashfs-sysupgrade.img 2>/dev/null | head -1)

if [ -z "$SYSUPGRADE_IMG" ]; then
    log "❌ 错误: 未找到解压后的 .img 文件"
    log "💡 请先运行: ./step2-extract-image.sh"
    exit 1
fi

# 如果 sdcard.img 已存在，询问是否覆盖
if [ -f "sdcard.img" ]; then
    log "⚠️  发现已有 sdcard.img"
    read -p "   是否覆盖重新创建? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "⏭️  用户选择跳过，保留现有文件"
        echo "=========================================="
        exit 0
    fi
fi

SIZE_SRC=$(stat -f%z "$SYSUPGRADE_IMG")
log "💾 开始复制镜像..."
log "   - 源文件: $SYSUPGRADE_IMG ($(($SIZE_SRC / 1024 / 1024)) MB)"
log "   - 目标: sdcard.img"

cp "$SYSUPGRADE_IMG" sdcard.img

SIZE_DST=$(stat -f%z sdcard.img)
log "✅ 复制完成"
log "   - 目标大小: $SIZE_DST 字节"

if [ "$SIZE_SRC" -ne "$SIZE_DST" ]; then
    log "⚠️  警告: 文件大小不一致!"
    log "   源: $SIZE_SRC, 目标: $SIZE_DST"
fi

echo "=========================================="
