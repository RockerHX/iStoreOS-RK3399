#!/bin/bash
# 步骤5: 验证 U-Boot 签名
# 增加详细 Hex dump 输出

set -e

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

echo "=========================================="
log "🚀 步骤5: 验证 U-Boot 签名"
echo "=========================================="

if [ ! -f "sdcard.img" ]; then
    log "❌ 错误: 未找到 sdcard.img"
    exit 1
fi

log "🔍 读取镜像头部签名数据..."

# 读取扇区64 (32KB偏移) 的前 16 字节，方便调试
# seek=64 blocks * 512 = 32768 bytes
HEX_DUMP=$(dd if=sdcard.img bs=1 skip=32768 count=16 2>/dev/null | xxd -g 1) # -g 1 for single byte groups

log "📋 扇区64 头部数据 (Hex):"
echo "$HEX_DUMP" | sed 's/^/   /'

# 提取前4字节作为签名
SIGNATURE=$(echo "$HEX_DUMP" | head -n 1 | awk '{print $2$3$4$5}')

log "🔑 提取签名: 0x$SIGNATURE"

# 验证签名
# Rockchip 签名通常是 'RKNS' (52 4b 4e 53) 或 'RK33' (52 4b 33 33)
if [[ "$SIGNATURE" == "524b4e53" ]]; then
    log "✅ 签名匹配: RKNS (RK New Style)"
elif [[ "$SIGNATURE" == "524b3333" ]]; then
    log "✅ 签名匹配: RK33 (RK33 Style)"
else
    log "❌ 签名校验失败!"
    log "   期望: 524b4e53 (RKNS) 或 524b3333 (RK33)"
    log "   实际: $SIGNATURE"
    echo ""
    log "❓ 这意味着 Bootloader 可能未正确写入，或者源文件有问题。"
    read -p "   是否强制继续? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    log "⚠️  用户强制继续..."
fi

echo "=========================================="
