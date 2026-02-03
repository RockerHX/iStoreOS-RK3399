#!/bin/bash
# 步骤6: 压缩镜像
# 增加详细日志

set -e

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

echo "=========================================="
log "🚀 步骤6: 压缩最终镜像"
echo "=========================================="

if [ ! -f "sdcard.img" ]; then
    log "❌ 错误: 未找到 sdcard.img"
    exit 1
fi

# 如果已存在，询问是否覆盖
if [ -f "sdcard.img.gz" ]; then
    log "⚠️  发现已有 sdcard.img.gz"
    read -p "   是否覆盖? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "⏭️  跳过压缩"
        echo "=========================================="
        exit 0
    fi
fi

SIZE_BEFORE=$(stat -f%z sdcard.img)
log "📦 开始压缩 (gzip)..."
log "   - 原始大小: $(($SIZE_BEFORE / 1024 / 1024)) MB"

# 使用 gzip 压缩
# -n: 不保存原文件名为和时间戳，确保生成的 gz 文件 hash 一致（Reproducible Build）
gzip -n -f sdcard.img

if [ ! -f "sdcard.img.gz" ]; then
    log "❌ 压缩失败"
    exit 1
fi

SIZE_AFTER=$(stat -f%z sdcard.img.gz)
RATIO=$(awk "BEGIN {printf \"%.2f\", $SIZE_AFTER * 100 / $SIZE_BEFORE}")

log "✅ 压缩完成"
log "   - 结果文件: sdcard.img.gz"
log "   - 压缩后大小: $(($SIZE_AFTER / 1024 / 1024)) MB"
log "   - 压缩率: $RATIO%"
echo "=========================================="
