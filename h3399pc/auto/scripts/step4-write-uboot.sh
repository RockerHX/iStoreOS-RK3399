#!/bin/bash
# 步骤4: 写入 U-Boot
# 增加详细日志和参数回显

set -e

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

echo "=========================================="
log "🚀 步骤4: 写入 bootloader (U-Boot)"
echo "=========================================="

# 检查必需文件
if [ ! -f "sdcard.img" ]; then
    log "❌ 错误: 未找到 sdcard.img"
    log "💡 请先运行: ./step3-create-sdcard.sh"
    exit 1
fi

if [ ! -f "idbloader.img" ] || [ ! -f "u-boot.itb" ]; then
    log "❌ 错误: 缺少 idbloader.img 或 u-boot.itb"
    exit 1
fi

IDB_SIZE=$(stat -f%z idbloader.img)
UBOOT_SIZE=$(stat -f%z u-boot.itb)

log "📋 准备写入文件:"
log "   - idbloader.img: $IDB_SIZE 字节"
log "   - u-boot.itb:    $UBOOT_SIZE 字节"
echo "------------------------------------------"

log "🔥 正在写入 idbloader.img..."
log "   Command: dd if=idbloader.img of=sdcard.img bs=512 seek=64 conv=notrunc"
# 捕获并显示 dd 输出
dd if=idbloader.img of=sdcard.img bs=512 seek=64 conv=notrunc 2>&1 | awk '{print "   [dd] " $0}'

echo "------------------------------------------"

log "🔥 正在写入 u-boot.itb..."
log "   Command: dd if=u-boot.itb of=sdcard.img bs=512 seek=16384 conv=notrunc"
dd if=u-boot.itb of=sdcard.img bs=512 seek=16384 conv=notrunc 2>&1 | awk '{print "   [dd] " $0}'

echo "------------------------------------------"
log "✅ 写入流程结束"
echo "=========================================="
