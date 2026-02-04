
# ShareVDI H3399PC (X9) 硬件规格文档

> [!NOTE]
> 本文档经过 `android7.dts` (原厂固件) 验证，包含精确的 GPIO 定义。


## 设备概述

**ShareVDI H3399PC** (产品型号: **X9**) 是一款基于 Rockchip RK3399 处理器的工业级双网口软路由/网关主板/数字标牌播放器，适用于家庭/小型办公室网络环境、工业自动化、边缘计算等场景。

> **型号说明**：
> - **X9**：出口版型号，通常**无串口 (COM)** 接口。
> - **主板型号**：h339pc_v1.1
> - **原型板**：基于 **Firefly-RK3399** 开源设计改动（将原版 LPDDR 换成 DDR3 降低成本）
> - **备注**：本文档主要基于 X9 实机整理，G9 (国内版) 可能存在差异 (如 COM 口)，暂未验证。

---

## 核心硬件规格

### 处理器

| 项目 | 规格 |
|-----|------|
| **SoC** | Rockchip RK3399 |
| **CPU 架构** | ARM big.LITTLE |
| **大核** | 2x Cortex-A72 @ 1.8GHz |
| **小核** | 4x Cortex-A53 @ 1.4GHz |
| **GPU** | Mali-T860 MP4 |
| **NPU** | 无 |

---

## 内存与存储

### 内存

| 项目 | 规格 |
|-----|------|
| **类型** | **DDR3-1600** |
| **标准频率** | 800MHz (DDR3-1600 规格) |
| **实际运行频率** | 856MHz ⚠️ **轻微超频** |
| **容量** | 4GB (4 x 1GB 颗粒) |
| **通道** | 双通道 |
| **芯片丝印** | ZXZY PE025-125 x 4 |
| **出厂时间** | 2023年上半年批次 |

> ⚠️ **超频警告**: 系统运行在 856MHz，高于 DDR3-1600 标准频率 (800MHz)。这可能导致不稳定，建议在 U-Boot 或内核中限制最高频率为 800MHz。

### 存储

| 类型 | 接口 | 规格 |
|-----|------|------|
| **eMMC** | eMMC 5.1 HS400 | 64GB (板载) - 江波龙 (Longsys) ISOCOM 品牌 |
| **芯片丝印** | - | ISOCOM MEMDNN064G |
| **TF 卡** | SDIO 3.0 | 1x MicroSD 卡槽，支持存储扩展 |

---

## 网络硬件

### 双千兆以太网

| 网口 | 芯片型号 | 接口类型 | 系统识别 | OpenWrt 角色 | 说明 |
|-----|---------|---------|---------|-------------|------|
| **网口1** | RTL8211E | RGMII (RK3399 gmac) | eth0 | LAN | 板载千兆PHY，连接PC/交换机 |
| **网口2** | RTL8111F | PCIe x1 | eth1 | WAN | PCIe千兆网卡，连接上级路由器/光猫 |

**LAN 口数量**：2个千兆以太网口

**详细说明：**
- **网口1 (eth0/LAN)**：
  - 芯片：Realtek RTL8211E Gigabit PHY
  - 标识：RTL8211E L8DK9E1 GL35B
  - 接口：RGMII，连接到 RK3399 内置 gmac 控制器
  - 驱动：Linux 内核自带 `stmmac` + `rtl8211e`
  
- **网口2 (eth1/WAN)**：
  - 芯片：Realtek RTL8111F PCIe Gigabit Ethernet
  - 标识：RTL8111F J7H3831 GK34
  - 接口：PCIe Gen1 x1
  - 驱动：`r8168` (兼容 RTL8168 系列)

### 无线网络

| 项目 | 规格 |
|-----|------|
| **WiFi/蓝牙芯片** | **AP6356S** (Broadcom BCM4356) |
| **WiFi 规格** | 2x2 MIMO 802.11ac, 双频 2.4G/5G |
| **蓝牙规格** | Bluetooth 4.1 |
| **天线接口** | SMA 外置天线 x1 |
| **控制引脚** | WiFi Reset (GPIO0_B2), WiFi Wake (GPIO0_A3), BT Reset (GPIO0_B1), BT Wake (GPIO0_A4) |

> **注意**：原厂 Android 固件中配置了 `wireless-wlan` 节点 (ap6356s)，OpenWrt 需相应固件支持。

---

## 视频与显示

### GPU

| 项目 | 规格 |
|-----|------|
| **GPU** | Mali-T860 MP4 |

### 视频编解码能力

| 功能 | 规格 |
|-----|------|
| **4K 解码** | 支持 4K VP9 和 4K 10位 H.265/H.264 视频解码，最高 60fps |
| **1080P 解码** | 支持多格式：WMV、MPEG-1/2/4、VP8 |
| **1080P 编码** | 支持 H.264、VP8 格式 |
| **后期处理** | 反交错、去噪、边缘/细节/色彩优化 |

### 显示接口

| 接口 | 数量 | 最大分辨率 | 刷新率 | 备注 |
|-----|------|-----------|--------|------|
| **HDMI - 1 (Main Screen)** | 1 | 1920×1080 | 60Hz | **DSI 转 HDMI** (LT8912), 对应 DTS `dsi@ff968000` |
| **HDMI - 2 (Sub Screen)** | 1 | 4096×2160 (4K) | 60Hz | **原生 HDMI 2.0** (RK3399), 对应 DTS `hdmi@ff940000` |

**总计**：2个 HDMI 接口 (支持双屏异显，后置面板标示为 Main/Sub)

---

## USB 接口

| 接口 | 数量 | 规格 |
|-----|------|------|
| **USB 3.0** | 2 | Type-A |
| **USB 2.0** | 4 | Type-A |

**总计**：6个 USB 接口

---

## 串口与工业接口

### RS232

| 项目 | 规格 |
|-----|------|
| **数量** | 2 |
| **说明** | 标准 RS232 串口 |

### RS485

| 项目 | 规格 |
|-----|------|
| **数量** | 2 (可扩展) |
| **说明** | 支持外置 RS485 转换模块 |

> **注意**：**X9** 机身通常无预留 COM 口开孔。
> 适用于数字标牌、工业控制等场景

---

## 音频

| 接口/功能 | 规格 |
|----------|------|
| **音频接口** | AUX 3.5mm 耳机输出/麦克风输入 |
| **支持特性** | 立体声输出、麦克风输入 |

---

## 扩展与外设

## 扩展与外设

### 扩展卡槽

| 插槽 | 规格 | 占用情况 | 备注 |
|-----|------|---------|------|
| **PCIe 2.0** | x1 (x4物理插槽) | **已占用**：RTL8111F 千兆网卡 | 供电: GPIO4_D5, 复位: GPIO4_D3 |
| **TF 卡槽** | 1x | 支持存储扩展 | 系统供电 (无独立GPIO控制) |

### SIM 卡

| 项目 | 规格 |
|-----|------|
| **SIM 卡槽** | 不支持 |

### 其他功能

| 功能 | 规格 | GPIO 定义 (DTS) |
|-----|------|-----------------|
| **RTC (实时时钟)** | 支持 | `rk808` PMIC 集成 |
| **看门狗** | 支持 | `snps,dw-wdt` |
| **红外遥控** | 支持 | `pwm3a` (GPIO0_A6) |

---

## 底层硬件定义 (DTS 深度验证)

以下数据直接提取自原厂 `android7.dts` 文件，包含原始 Hex 数值以便核对。

### 内存配置 (DDR)

| 项目 | 规格 | DTS 原始定义 (部分) | 备注 |
|-----|------|--------------------|------|
| **容量** | 4GB (实际可用约 3.8GB) | `reg = <0x0 0x200000 ... 0x0 0xede00000>` | 内存映射包含保留区域 |
| **类型** | **DDR3-1600** | `ddr3_speed_bin = <0x15>` (21 = DDR3-1600) | 标准频率 800MHz |
| **实际频率** | **856MHz** ⚠️ 超频 | `opp-856000000` | 高于标准 800MHz |
| **可用频率** | 416MHz, 856MHz | DTS `operating-points-v2` | 两档频率 |
| **芯片** | ZXZY PE0255-125 x 4 | 实物丝印 + 系统信息验证 | 4 x 1GB 颗粒 |
| **驱动强度** | 40Ω (DDR3 标准) | `ddr3_drv = <0x28>` | DDR3 典型配置 |
| **节点** | /memory, /dmc | `device_type = "memory"` | DMC 动态频率调节 |

> ⚠️ **超频风险**: 固件沿用 Firefly 原版配置，针对 LPDDR3/4 优化。实际硬件使用 DDR3-1600，在 856MHz 运行属于超频，可能导致系统不稳定。
>
> **深度技术解析**: 关于 DDR3 初始化、U-Boot 兼容性、DDR 参数配置等详细技术问题，请参考 **[RK3399 U-Boot 与 DDR 初始化技术深度解析](RK3399_UBOOT_DDR_ANALYSIS.md)**

### GPIO / 供电控制映射表

> **说明**：`phandle` 映射：`0xd2`=&gpio0, `0x36`=&gpio1, `0x19`=&gpio3, `0x89`=&gpio4

| 硬件功能 | 描述 | GPIO 编号 | 原厂 DTS 原始数据 (Hex) | 有效电平 | 备注 |
|---------|------|----------|------------------------|---------|------|
| **WAN 网卡复位** | RTL8111F Reset | **GPIO4_D3** | `ep-gpios = <0x89 0x1b 0x00>` | High | 0x1b = 27 (D3) |
| **LAN 网卡复位** | RTL8211E Reset | **GPIO3_B7** | `snps,reset-gpio = <0x19 0x0f 0x01>` | Low | 0x0f = 15 (B7) |
| **PCIe 3.3V 电源** | PCIe Slot Power | **GPIO4_D5** | Pinctrl: `<0x04 0x1d ...>` | High | 0x1d = 29 (D5) |
| **USB Hub 5V 电源** | USB Hub VCC | **GPIO4_D6** | Pinctrl: `<0x04 0x1e ...>` | High | 0x1e = 30 (D6) |
| **电源指示灯** | Work LED (Red) | **GPIO0_B4** | `gpios = <0xd2 0x0c 0x00>` | High | 0x0c = 12 (B4) |
| **用户指示灯** | User LED (Blue) | **GPIO0_B5** | `gpios = <0xd2 0x0d 0x00>` | High | 0x0d = 13 (B5) |
| **电源按键** | Power Button | **GPIO0_A5** | `gpios = <0xd2 0x05 0x01>` | Low | 0x05 = 5 (A5) |
| **红外接收** | IR Receiver | **GPIO0_A6** | `pwm3a` | 固件未默认启用 |

### I2C 总线设备表

| 总线 | 地址 | 芯片/设备 | 功能描述 | 备注 |
|------|------|----------|----------|------|
| **I2C0** | 0x1b | **RK808** | PMIC 电源管理芯片 | - |
| **I2C0** | 0x40 | **SYR827** | CPU (Big) 核心供电 | - |
| **I2C0** | 0x41 | **SYR828** | GPU 核心供电 | - |
| **I2C1** | 0x11 | **ES8316** | 音频 Codec | 耳机/麦克风 |
| **I2C2** | 0x00 | **LT8912** | DSI 转 HDMI 桥接 | 主HDMI输出(HDMI-1) |

### 按键与 LED 定义
| 功能 | GPIO / 类型 | 原始 DTS 定义 | 备注 |
|-----|------------|--------------|------|
| **Power Key** | **GPIO0_A5** | `linux,code = <116>` (KEY_POWER) | 低电平有效 |
| **Recovery** | **ADC Key** | `linux,code = <113>` (KEY_MUTE/F12) | 通道 1, 值 0x04 |
| **Work LED** | **GPIO0_B4** | `label = "work"` | 高电平点亮 |
| **User LED** | **GPIO0_B5** | `label = "diy"` | 高电平点亮 |


### 引脚配置说明

基于实际硬件验证和 h339pc 成功配置：
- **GPIO0_B4** (引脚 12)：工作指示灯 (Work LED)
- **GPIO0_B5** (引脚 13)：用户指示灯 (DIY LED)
- **GPIO4_D6** (引脚 30)：USB Hub 电源控制


---

## 可扩展硬件支持 (Android / 未来开发参考)

以下配置信息从原厂固件提取并验证，**当前 iStoreOS 固件由用户要求默认禁用**，仅供未来适配 Android 或高级功能时参考。

<details>
<summary><b>1. 双 HDMI 支持 (DSI -> LT8912)</b></summary>

若需启用第二个 HDMI 接口，需移植 `lontium-lt8912` 驱动并在 DTS 中添加：

```dts
// 根节点添加连接器
hdmi2: connector-hdmi2 {
    compatible = "hdmi-connector";
    label = "HDMI2";
    type = "a";
    port {
        hdmi2_con: endpoint {
            remote-endpoint = <&lt8912_out>;
        };
    };
};

// I2C2 节点下挂载桥接芯片
&i2c2 {
    status = "okay";
    lt8912: bridge@48 {
        compatible = "lontium,lt8912b";
        reg = <0x48>;
        reset-gpios = <&gpio2 RK_PA2 GPIO_ACTIVE_LOW>;
        ports {
            #address-cells = <1>;
            #size-cells = <0>;
            port@0 {
                reg = <0>;
                lt8912_in: endpoint { remote-endpoint = <&mipi_dsi1_out>; };
            };
            port@1 {
                reg = <1>;
                lt8912_out: endpoint { remote-endpoint = <&hdmi2_con>; };
            };
        };
    };
};

// 启用 DSI1 控制器
&mipi_dsi1 {
    status = "okay";
    ports {
        mipi_dsi1_out: port@1 {
            reg = <1>;
            remote-endpoint = <&lt8912_in>;
        };
    };
};
```
</details>

<details>
<summary><b>2. 无线与蓝牙 (AP6356S)</b></summary>

无线模块供电与 `sdio0` 绑定，若需优化休眠唤醒：

```dts
&sdio0 {
    // 在节点内部添加 Broadcom 无线定义
    brcmf: wifi@1 {
        compatible = "brcm,bcm4329-fmac";
        reg = <1>;
        interrupt-parent = <&gpio0>;
        interrupts = <RK_PA3 IRQ_TYPE_LEVEL_HIGH>; // OOB 中断
        interrupt-names = "host-wake";
    };
};
```
</details>

<details>
<summary><b>3. 红外遥控 (IR)</b></summary>

由 `pwm3a` 引脚控制，尽管物理板可能未焊接接收头：

```dts
ir-receiver {
    compatible = "gpio-ir-receiver";
    gpios = <&gpio0 RK_PA6 GPIO_ACTIVE_LOW>;
    pinctrl-0 = <&pwm3a_pin>;
    pinctrl-names = "default";
};
```
</details>

---

## 电源

| 项目 | 规格 |
|-----|------|
| **输入电压** | DC 12V |
| **电流** | 2A |
| **功率** | 最大 24W |
| **供电接口** | DC 电源插座 |
| **标配适配器** | 12V 2A 电源适配器 |

---

## LED 指示灯与按键

### 指示灯

| LED | 颜色 | 功能 |
|-----|------|------|
| **工作指示灯** | 红色 | 系统工作状态 (Work LED - GPIO0_B4) |
| **用户指示灯** | 蓝色 | 用户自定义 (DIY LED - GPIO0_B5) |

### 按键

| 按键 | 功能 |
|-----|------|
| **Power Button** | 电源按键 (唤醒/休眠) |

---

## 物理参数

### 尺寸与重量

| 项目 | 规格 |
|-----|------|
| **物理尺寸** | 121.5 mm × 121.5 mm × 36 mm |
| **包装尺寸** | 250 mm × 190 mm × 60 mm |
| **净重** | 0.56 kg |
| **毛重** | 1.1 kg |

### 安装方式

- 桌面放置（标配脚垫 x4）
- 壁挂/背挂安装（标配背挂支架 x1 + 螺丝包）

---

## 环境指标

| 项目 | 规格 |
|-----|------|
| **工作温度** | -10°C ~ 40°C |
| **存储温度** | 0°C ~ 40°C |
| **工作/存储湿度** | 0 ~ 85% RH (无冷凝) |
| **散热方式** | 被动散热 (金属外壳散热) |

---

## 认证与标准

| 认证 | 状态 |
|-----|------|
| **CCC** | 已认证 |
| **CE** | 已认证 |
| **ISO** | 已认证 |

---

## 操作系统支持

### 官方支持

| 系统 | 版本 | 状态 |
|-----|------|------|
| **Android** | 7.1, 10.0 | ✅ 官方支持 |
| **Ubuntu** | 18.04 | ✅ 官方支持 |
| **UOS (统信)** | - | ✅ 官方支持 |

### 第三方支持

| 系统 | 状态 |
|-----|------|
| **iStoreOS (OpenWrt)** | ✅ 完全支持 (本项目) |
| **Armbian** | ✅ 社区支持 |
| **Debian** | ✅ 社区支持 |

---

## 网络配置（iStoreOS）

### 默认网络设置

| 项目 | 配置 |
|-----|------|
| **网络模式** | 双网口路由器模式 |
| **WAN 口** | eth1 (RTL8111F PCIe 网卡) |
| **LAN 口** | eth0 (RTL8211E gmac 网口) |
| **LAN IP** | 192.168.100.1 |
| **DHCP 服务器** | 已启用 (LAN口) |
| **管理账号** | root |
| **默认密码** | password |

### 网口识别

```
┌─────────────────────────────────┐
│      ShareVDI H3399PC X9        │
│                                 │
│  [网口1] ← eth0 / LAN           │
│  RTL8211E                       │
│  192.168.100.1                  │
│                                 │
│  [网口2] ← eth1 / WAN           │
│  RTL8111F                       │
│  自动获取 IP                     │
│                                 │
└─────────────────────────────────┘
```

---

## 驱动支持（OpenWrt/iStoreOS）

### 必需内核模块

| 模块 | 用途 |
|-----|------|
| `kmod-r8168` | RTL8111F PCIe 网卡驱动 |
| `kmod-usb3` | USB 3.0 支持 |
| `stmmac` | RK3399 gmac 控制器驱动 (内核自带) |

### 可选模块

| 模块 | 用途 |
|-----|------|
| `kmod-sound-core` | 音频支持 |
| `kmod-drm-rockchip` | HDMI 显示支持 |
| `kmod-brcmfmac` | WiFi 驱动 (如有板载 WiFi 模块) |
| `kmod-usb-serial` | USB 转串口驱动 |

---

## 标配装箱清单

| 配件 | 数量 | 说明 |
|-----|------|------|
| **主机** | 1 | H3399PC X9 主板 |
| **电源适配器** | 1 | DC 12V 2A |
| **WiFi 天线** | 1 | SMA 接口 (如配备 WiFi 模块) |
| **背挂支架** | 1 | 壁挂安装用 |
| **配件螺丝包** | 1 | 安装配件 |
| **脚垫** | 4 | 桌面放置用 |
| **说明书** | 1 | 通用款 |
| **合格证** | 1 | 通用款 |

---

## 应用场景

### ✅ 适用场景

- 🏠 **家庭软路由** - 双网口 WAN+LAN 配置，替代传统路由器
- 🏢 **小型办公室网关** - 支持多用户、VPN、防火墙
- 🔒 **旁路由透明代理** - 科学上网、广告过滤
- 📦 **NAS 存储服务器** - 64GB eMMC + TF 卡扩展 + USB 外接存储
- 🎮 **游戏加速器** - 低延迟网络优化
- 🌐 **边缘计算网关** - 工业物联网数据采集与转发
- 🏭 **工业自动化** - RS232/RS485 串口通信
- 📺 **数字标牌/广告机** - 双 HDMI 输出，4K 视频解码
- 🖥️ **迷你 PC / HTPC** - Android/Ubuntu 系统

### ⚠️ 不适用场景

- ❌ 高并发企业级路由 (CPU 性能有限，适合 < 100 用户)
- ❌ 大型 NAS 存储 (只有 2 个千兆网口，无硬盘位)
- ❌ 高性能计算 (RK3399 为嵌入式处理器)

---

## 产品对比

### 与同类产品对比

| 特性 | H3399PC X9 | 软路由 X86 | 树莓派 4B |
|-----|-----------|-----------|-----------|
| **处理器** | RK3399 (6核) | x86 (4核+) | BCM2711 (4核) |
| **网口** | 2x 千兆 | 2-4x 千兆 | 1x 千兆 |
| **内存** | 4GB LPDDR4 | 4-16GB DDR4 | 2-8GB LPDDR4 |
| **存储** | 64GB eMMC | 128GB+ SSD | MicroSD |
| **功耗** | 5-15W | 15-35W | 3-7W |
| **串口** | 无 (X9) | 少/无 | GPIO UART |
| **价格** | 中等 | 较高 | 较低 |
| **工业级** | ✅ | ✅ | ❌ |

---

## 技术特色

### 优势

- ✅ **双千兆网口** - 真正的 WAN+LAN 路由器配置
- ✅ **工业级可靠性** - -10°C ~ 40°C 工作温度，金属外壳散热
- ✅ **丰富扩展接口** - 6x USB, 2x HDMI, RS232/RS485
- ✅ **大容量存储** - 64GB eMMC + TF 卡扩展
- ✅ **4K 视频** - 支持 4K@30Hz 输出和硬件解码
- ✅ **低功耗** - 典型功耗 5-15W
- ✅ **多系统支持** - Android, Linux, OpenWrt

### 局限性

- ⚠️ **CPU 性能** - 中等性能，不适合高负载应用
- ⚠️ **WiFi 可选** - 板载 WiFi 可能需要额外配置
- ⚠️ **无 SIM 卡槽** - 不支持 4G/5G 移动网络 (需 USB 适配器)

---

## 相关链接

- [iStoreOS 官方文档](https://doc.linkease.com/zh/guide/istoreos)
- [RK3399 处理器规格](https://www.rock-chips.com/a/en/products/RK33_Series/2016/0419/758.html)
- [项目 GitHub 仓库](https://github.com/RockerHX/iStoreOS-RK3399)

---

## 版本历史

| v1.2 | 2026-02-01 | 更新产品型号为 X9，标注主板版本 h339pc_v1.1 |
| v1.1 | 2026-01-30 | 根据官方产品规格表更新详细硬件信息 |
| v1.0 | 2026-01-30 | 初始版本，基础硬件规格整理 |

---

## 免责声明

本文档基于官方产品规格表、实际测试和 DTS 配置整理。规格信息仅供参考，具体配置可能因硬件批次、订购选项不同而有所差异。使用本固件产生的所有后果由使用者自行承担。

---

**文档最后更新**：2026-02-01
**适用产品型号**：ShareVDI X9
**主板版本**：h339pc_v1.1
**硬件版本**：通用

## 内核开发高级参考 (Reverse Engineered from android7.dts)

以下数据通过对原厂 `android7.dts` 进行反向工程提取，供内核开发者和发烧友参考。

### 1. 频率与性能 (OPP Table)
- **Big Cluster (Cortex-A72)**: 最高频率 **1.8GHz** (1800MHz @ 1.25V), 对应 `opp-1800000000`。
- **Little Cluster (Cortex-A53)**: 最高频率 **1.4GHz** (1416MHz @ 1.125V), 对应 `opp-1416000000`。
- **GPU (Mali-T860)**: 默认最高 **800MHz**。
- **DDR**: LPDDR4 频率通常动态调整，最高支持 800MHz (1600Mbps)。

### 2. 热管理策略 (Thermal)
原厂固件定义的温控策略非常保守，旨在保护无风扇被动散热的机身：
- **Passive Cooling (降频线)**: **70°C** (Trip Point 0)
- **Critical Shutdown (强制关机)**: **115°C** (Soc Critical)
- **Cooling Maps**: 
    - 70°C 时，CPU 大核/小核开始逐步降频。
    - GPU 也会参与降频以降低整机功耗。

### 3. 保留内存 (Reserved Memory)
- **DRM Logo**: `0x00000000` - `0x00000000` (未具体定义，但在 u-boot 中通常保留)。
- **RGA Buffer**: 用于 2D 硬件加速，需在内核中预留足够 CMA 内存。

### 4. 时钟分配 (Clocks)
- **PCIe Clock**: 100MHz (由内部 PLL 生成)
- **Ethernet (RGMII)**: 125MHz (由 PLL 生成，非外部晶振)
- **WiFi (SDIO)**: 外部时钟输入 (通常 32.768kHz 用于休眠保持)
