# H3399PC TF 卡镜像制作工具

这个工具用于将 iStoreOS 固件与 Bootloader (U-Boot) 合并，制作出可以在 H3399PC 上启动的 TF 卡镜像。

## 📋 准备工作

在运行脚本之前，请确保当前目录下包含以下 **3 个必需文件**：

1.  **`idbloader.img`**
    *   第一阶段引导加载程序 (First Stage Bootloader)。
2.  **`u-boot.itb`**
    *   U-Boot 镜像文件。
3.  **`istoreos-*.img.gz`**
    *   iStoreOS 的系统升级固件包 (Sysupgrade Image)。
    *   格式应为 `istoreos-rockchip-armv8-sharevdi_h3399pc-squashfs-sysupgrade.img.gz`（也支持已解压的 `.img` 文件）。

## 🚀 使用方法

### 1. 运行主脚本
在终端中执行以下命令启动交互式菜单：

```bash
./make-complete-image.sh
```

### 2. 菜单选项
脚本提供交互式菜单，支持多种执行模式：
*   **全自动模式**：输入 `a`，自动按顺序执行所有步骤。
*   **单步执行**：输入数字（如 `1`），仅执行特定步骤。
*   **组合执行**：输入多个数字（如 `1 3 5`），按顺序执行指定步骤。

## 🛠 脚本流程说明

工具会自动依次执行 `scripts/` 目录下的步骤：

1.  **检查必要文件**：确认源文件存在。
2.  **解压系统镜像**：将 `.gz` 固件解压为原始镜像。
3.  **创建基础镜像**：复制系统镜像为 `sdcard.img`。
4.  **写入 U-Boot**：
    *   将 `idbloader.img` 写入扇区 64 (偏移 32KB)。
    *   将 `u-boot.itb` 写入扇区 16384 (偏移 8MB)。
5.  **验证签名**：检查写入后的镜像是否存在 `RKNS` 或 `RK33` 魔数签名。
6.  **压缩最终镜像**：生成 `sdcard.img.gz`（使用 `-n` 参数确保 SHA256 恒定）。
7.  **生成校验和**：生成 `sdcard.img.gz.sha256`。

## 📦 输出产物

运行完成后，通过 `diskutil` 或 Etcher 等工具将以下文件写入 TF 卡：

*   **`sdcard.img.gz`**: 最终的可启动镜像压缩包。
*   **`sdcard.img.gz.sha256`**: 镜像文件的 SHA256 校验值。
