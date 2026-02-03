#!/bin/bash
# 步骤7: 生成校验和
# 增加详细日志

set -e

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

echo "=========================================="
log "🚀 步骤7: 生成 SHA256 校验和"
echo "=========================================="

FILE="sdcard.img.gz"

if [ ! -f "$FILE" ]; then
    log "❌ 错误: 未找到 $FILE"
    exit 1
fi

log "🔐 计算 SHA256 (这可能需要几秒钟)..."
# 计算并保存
shasum -a 256 "$FILE" | tee "$FILE.sha256"

# 读取并显示
CHECKSUM=$(cat "$FILE.sha256" | awk '{print $1}')
log "✅ 校验和已生成"
log "   File: $FILE"
log "   SHA256: $CHECKSUM"
echo "=========================================="
