#!/bin/bash
# H3399PC 完整 TF 卡镜像制作脚本 (Interactive)
# 支持全自动、单步、多步执行

set -e

# 步骤定义
# 步骤定义
STEPS=(
    "scripts/step1-check-files.sh|检查必要文件"
    "scripts/step2-extract-image.sh|解压系统镜像"
    "scripts/step3-create-sdcard.sh|创建基础镜像 (sdcard.img)"
    "scripts/step4-write-uboot.sh|写入 U-Boot (Bootloader)"
    "scripts/step5-verify-signature.sh|验证 U-Boot 签名"
    "scripts/step6-compress.sh|压缩最终镜像"
    "scripts/step7-generate-checksum.sh|生成 SHA256 校验和"
)

# 获取脚本所在目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# 赋予执行权限
for entry in "${STEPS[@]}"; do
    script="${entry%%|*}"
    if [ ! -x "$script" ]; then
        chmod +x "$script"
    fi
done

show_menu() {
    clear
    echo "=========================================="
    echo "🚀 H3399PC 镜像制作工具箱"
    echo "=========================================="
    echo ""
    
    local i=1
    for entry in "${STEPS[@]}"; do
        desc="${entry#*|}"
        printf "  %d. %s\n" "$i" "$desc"
        i=$((i + 1))
    done
    
    echo ""
    echo "------------------------------------------"
    echo "  a. 执行所有步骤 (1-7)"
    echo "  q. 退出"
    echo "------------------------------------------"
    echo ""
}

run_step() {
    local index=$1
    # 数组索引从0开始，显示从1开始
    local array_index=$((index - 1))
    
    if [ $array_index -lt 0 ] || [ $array_index -ge ${#STEPS[@]} ]; then
        echo "❌ 无效步骤编号: $index"
        return
    fi
    
    local entry="${STEPS[$array_index]}"
    local script="${entry%%|*}"
    local desc="${entry#*|}"
    
    echo ""
    echo ">>> 开始执行: $desc ($script)"
    
    if ./$script; then
        echo ">>> ✅ 执行成功"
    else
        echo ">>> ❌ 执行失败"
        # 失败是否中断整个流程？
        # 如果是单步执行，不影响。如果是批量，可能需要停止。
        return 1
    fi
}

run_all() {
    echo ""
    echo "🚀 开始全流程自动执行..."
    for ((i=1; i<=${#STEPS[@]}; i++)); do
        if ! run_step $i; then
            echo "⛔️ 流程中断于步骤 $i"
            exit 1
        fi
        echo ""
    done
    echo "=========================================="
    echo "🎉 所有步骤执行完毕！"
    echo "=========================================="
}

# 主循环
while true; do
    show_menu
    read -p "请输入选项 (例如 'a' 或 '1' 或 '1 3 5'): " choice
    
    if [[ "$choice" == "q" || "$choice" == "quit" || "$choice" == "exit" ]]; then
        echo "再见 👋"
        exit 0
    elif [[ "$choice" == "a" || "$choice" == "all" ]]; then
        run_all
        read -p "按回车键返回菜单..."
    else
        # 处理数字列表输入 (例如 "1 2 5")
        # 将输入转换为数组
        read -r -a choices <<< "$choice"
        
        valid_input=true
        # 验证所有输入是否为数字
        for item in "${choices[@]}"; do
             if ! [[ "$item" =~ ^[0-9]+$ ]]; then
                 valid_input=false
                 break
             fi
        done
        
        if [ "$valid_input" = true ]; then
            echo ""
            echo "📋 计划执行步骤: ${choices[*]}"
            for step_num in "${choices[@]}"; do
                if ! run_step "$step_num"; then
                    echo "⛔️ 批量执行中断"
                    break
                fi
                echo ""
            done
            read -p "按回车键返回菜单..."
        else
            echo ""
            echo "❌ 无效输入，请输入数字选项"
            sleep 1
        fi
    fi
done
