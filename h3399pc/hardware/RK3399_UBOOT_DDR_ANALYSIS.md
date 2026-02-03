# RK3399 U-Boot 技术深度解析

## 问题1: RK33 vs RKNS 签名

### 签名格式演变

| 格式 | 签名值 | 使用时期 | 说明 |
|------|--------|---------|------|
| **RK30** | `524b3330` | RK3066/RK3188 | 早期格式 |
| **RK32** | `524b3332` | RK3288 | 32位 SoC |
| **RK33** | `524b3333` | RK3399 早期 | 64位 SoC 早期格式 |
| **RKNS** | `524b4e53` | RK3399 新版 | RK New Style 新格式 |

### RK3399 为什么出现两种签名？

**历史原因**:
```
2016-2017: RK3399 发布，使用 RK33 格式
2018+:    Rockchip 更新 U-Boot，引入 RKNS 格式
          - 支持更大的固件
          - 更好的安全性
          - 更灵活的分区布局
```

**兼容性**:
- ✅ **RK3399 SoC 支持两种格式**
- ✅ **BootROM 会尝试识别两种签名**
- ✅ 只要签名正确，硬件都能启动

---

## 问题2: H3399PC 能识别 RKNS 吗？

### 答案: ✅ 能！

**验证证据**:

1. **您的编译结果**: 
   - 编译生成的 U-Boot 就是 RKNS 格式
   - 签名验证显示: `524b4e53 (RKNS)`

2. **BootROM 行为**:
```c
// RK3399 BootROM 伪代码
if (signature == 0x524b3333) {  // RK33
    load_old_format();
} else if (signature == 0x524b4e53) {  // RKNS
    load_new_format();
} else {
    fail();
}
```

3. **实际案例**:
   - 大部分 RK3399 板子现在都用 RKNS
   - OpenWrt/Armbian 等主流系统都生成 RKNS 格式

**结论**: H3399PC 完全支持 RKNS 格式！

---

## 问题3: TPL/DDR 初始化详解

### 什么是 TPL？

**U-Boot 启动链**:
```
BootROM (芯片固化) 
    ↓
TPL (Tertiary Program Loader)  ← 初始化 DDR
    ↓
SPL (Secondary Program Loader) ← 初始化其他硬件
    ↓
U-Boot proper                   ← 加载 Kernel
    ↓
Linux Kernel
```

### idbloader.img 的组成

```
idbloader.img = TPL + SPL
├── TPL (RK3399 ddr init)  ← 初始化 DDR
└── SPL (U-Boot SPL)       ← 初始化存储、时钟等
```

---

## 问题4: DDR 兼容性问题 ⚠️ 关键！

### 您的发现非常重要！

**您的经验**:
```
通用 loader.bin (v1.26)  → ❌ 无法初始化 DDR/eMMC
安卓7 提取 (v1.36)      → ✅ 可以初始化 DDR/eMMC
```

**原因分析**:

#### DDR 配置差异

RK3399 支持多种 DDR 配置：

| DDR 类型 | 频率 | 容量 | 时序参数 |
|---------|------|------|---------|
| LPDDR3 | 933/1600MHz | 2/4GB | 不同厂商不同 |
| LPDDR4 | 1600/2133MHz | 2/4/6GB | 不同厂商不同 |
| DDR3 | 800/933MHz | 2/4GB | 不同厂商不同 |

**H3399PC 的具体配置需要查看硬件**:
- 可能是 LPDDR3 @ 1600MHz, 4GB
- 但厂商型号、PCB 布线、时序参数都影响初始化

#### 为什么 Android 7 的 loader 能工作？

**因为厂商专门适配了！**

```
Android 7 loader (v1.36):
├── DDR 配置: 专门针对 H3399PC 的 DDR 颗粒
├── eMMC 配置: 适配具体的 eMMC 型号
└── 时序参数: 经过测试调优的参数
```

**通用 loader (v1.26)**:
```
通用 loader:
├── DDR 配置: 通用保守参数
├── eMMC 配置: 通用配置
└── 问题: 可能不适配 H3399PC 的具体硬件
```

---

## 问题5: 编译的 U-Boot 能初始化 DDR 吗？

### 答案: ⚠️ 取决于配置！

### U-Boot 的 DDR 配置来源

**Option 1: 设备树 (Device Tree)**

```c
// arch/arm/dts/rk3399-h3399pc.dtsi
&dmc {
    center-supply = <&vdd_center>;
    status = "okay";
    
    // DDR 配置
    rockchip,ddr-type = <3>;        // LPDDR3
    rockchip,ddr-freq = <1600000000>; // 1600MHz
    rockchip,dramtype = <3>;
    // ... 更多参数
};
```

**Option 2: Defconfig**

```makefile
# configs/h3399pc-rk3399_defconfig
CONFIG_RAM_RK3399_LPDDR4=y
CONFIG_RAM_ROCKCHIP_DEBUG=y
```

**Option 3: 使用 Rockchip 的 DDR bin (推荐)**

```makefile
# U-Boot Makefile
# 使用 rkbin 仓库的预编译 DDR blob
CONFIG_TPL_ROCKCHIP_BACK_TO_BROM=y
```

### 您的情况分析

**当前编译配置**:

查看 `h3399pc/uboot-rockchip/Makefile`:
```makefile
# 可能使用通用 DDR 配置
# 不一定适配 H399PC 的具体 DDR
```

**两种解决方案**:

#### 方案A: 使用 Android 7 的 idbloader.img ✅ 推荐

```bash
# 从 Android 7 提取
dd if=MainAllLoader.bin of=idbloader.img bs=512 skip=64 count=7104

# 只替换 idbloader.img，保留编译的 u-boot.itb
# 这样 DDR 初始化用厂商的，U-Boot 用新的
```

**优点**:
- ✅ DDR 初始化 100% 可靠
- ✅ 可以使用新版 U-Boot 的其他功能
- ✅ 启动稳定

**做法**:
```bash
cd ~/Desktop/h3399pc-sdcard

# 下载最新编译的 u-boot.itb
# 使用 Android 7 提取的 idbloader.img

# 执行合并脚本
./make-sdcard-quick.sh
```

#### 方案B: 配置 U-Boot 使用正确的 DDR 参数 ⚠️ 复杂

需要知道：
1. DDR 型号 (从芯片上读)
2. DDR 频率和时序
3. 修改 U-Boot 配置

**步骤**:
```bash
# 1. 从 Android 7 提取 DDR 参数
# 2. 修改 rk3399-h3399pc.dts
# 3. 或者使用 rkbin 的 DDR blob
# 4. 重新编译 U-Boot
```

**难度**: 高，需要硬件知识

---

## 🎯 推荐方案

### 对于 H3399PC TF 卡启动

**方案: 混合使用**

```
idbloader.img: 从 Android 7 MainAllLoader.bin 提取
              ↑ 保证 DDR/eMMC 初始化成功
              
u-boot.itb:    使用编译生成的新版本
              ↑ 支持新功能、新内核
              
Kernel:        iStoreOS 最新
```

**操作步骤**:

1. **提取 Android 7 的 idbloader**:
```bash
# 从完整的 Android 7 备份镜像
dd if=android7_backup.img of=idbloader_android7.img bs=512 skip=64 count=7104
```

2. **使用混合方案**:
```bash
cd ~/Desktop/h3399pc-sdcard

# 使用 Android 7 的 idbloader
mv idbloader.img idbloader_compiled.img
cp idbloader_android7.img idbloader.img

# u-boot.itb 使用编译的
# (已下载)

# 生成 sdcard.img
./make-sdcard-quick.sh
```

3. **测试**:
- 如果成功启动 → ✅ 说明 DDR 初始化是关键
- 如果还是失败 → 检查其他问题

---

## 📊 总结

| 问题 | 答案 |
|------|------|
| RK3399 支持 RKNS 吗？ | ✅ 是，BootROM 支持 |
| 需要特定 DDR 配置吗？ | ✅ 是，不同批次可能不同 |
| 编译的 U-Boot 能用吗？ | ⚠️ u-boot.itb 可以，idbloader 可能需要用原厂的 |
| 推荐方案？ | 混合使用：原厂 idbloader + 编译的 u-boot.itb |

---

## 💡 深入理解

### 为什么 eMMC 刷写用原厂 loader 能成功？

**rkdevtool 刷写流程**:
```
1. rkdevtool 发送 Android 7 loader 到 RAM
2. loader 初始化 DDR (使用厂商参数)
3. loader 初始化 eMMC
4. rkdevtool 发送 sysupgrade.img 到 eMMC
5. 重启后，eMMC 的 idbloader 初始化 DDR
6. 加载 u-boot.itb → Kernel
```

**TF 卡启动流程**:
```
1. BootROM 读取 TF 卡偏移 64 的 idbloader
2. idbloader 初始化 DDR ← 必须正确！
3. idbloader 初始化 TF 卡
4. 加载 u-boot.itb → Kernel
```

**区别**: TF 卡完全依赖自己的 idbloader，没有外部 loader 帮助！

---

**建议**: 先用原厂 idbloader.img 测试，如果成功说明 DDR 配置是关键因素。
