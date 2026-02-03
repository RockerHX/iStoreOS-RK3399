#!/bin/bash
# 步骤2: 解压系统镜像
# 增加详细日志

set -e

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

echo "=========================================="
log "🚀 步骤2: 解压系统镜像"
echo "=========================================="

# 查找镜像文件
SYSUPGRADE_GZ=$(ls istoreos-*-squashfs-sysupgrade.img.gz 2>/dev/null | head -1)
SYSUPGRADE_IMG=$(ls istoreos-*-squashfs-sysupgrade.img 2>/dev/null | head -1)

# 如果已经解压，跳过
if [ -n "$SYSUPGRADE_IMG" ]; then
    SIZE=$(stat -f%z "$SYSUPGRADE_IMG")
    log "ℹ️  检测到已解压文件: $SYSUPGRADE_IMG"
    log "   - 大小: $SIZE 字节 ($(($SIZE / 1024 / 1024)) MB)"
    log "⏭️  跳过解压步骤"
    echo "=========================================="
    exit 0
fi

# 检查 .gz 文件
if [ -z "$SYSUPGRADE_GZ" ]; then
    log "❌ 错误: 当前目录未找到 .img.gz 或 .img 文件"
    exit 1
fi

log "📦 开始解压: $SYSUPGRADE_GZ"
log "   - 正在执行 gunzip..."

# 使用 gunzip -k 保留原文件
# 捕获输出以便出错时显示
if gunzip -k -f "$SYSUPGRADE_GZ" 2>&1 | grep -v "trailing garbage"; then
     : # 成功时不做额外操作
else
    # 允许 trailing garbage 警告，但其他错误应该报错
    # 上面的 grep -v 已经过滤了常见的 innocent warning
    # 如果 pipe 返回非零 (grep 没匹配到会返回1，但 gunzip 成功返回0... 管道中 exit code 有点复杂)
    # 简单处理：再次检查文件是否存在
    true
fi

# 验证解压结果
SYSUPGRADE_IMG="${SYSUPGRADE_GZ%.gz}"
if [ ! -f "$SYSUPGRADE_IMG" ]; then
    log "❌ 解压失败: 未生成 $SYSUPGRADE_IMG"
    exit 1
fi

SIZE=$(stat -f%z "$SYSUPGRADE_IMG")
log "✅ 解压成功"
log "   - 文件: $SYSUPGRADE_IMG"
log "   - 大小: $SIZE 字节 ($(($SIZE / 1024 / 1024)) MB)"
echo "=========================================="
