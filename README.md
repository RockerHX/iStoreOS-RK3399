![iStoreOS Logo](https://github.com/Lemon1151/iStoreOS-RK3399/raw/RK3399-dev/istoreos.png)
## iStore OS 固件 

[![iStore使用文档](https://img.shields.io/badge/使用文档-iStore%20OS-brightgreen?style=flat-square)](https://doc.linkease.com/zh/guide/istoreos) 

## 仓库介绍
**iStoreOS** 是入门级的路由系统，也是入门级的 NAS 系统， 基于原版 OpenWRT，在 ARS2 上经过长期迭代，最终开放适配到多个硬件平台。 

更多信息请参阅https://github.com/istoreos

> [!TIP]
> 此仓库为 **RK3399设备构建iStoreOS，后续更新添加设备中；非官方构建，不保证完全无BUG；如遇无法启动，请接ttl查看输出日志。需要定制的自行fork本仓库后，修改配置.config** 。

> **如果某些设备WiFi不可用，请去[仓库](https://github.com/armbian/firmware)找对应的无线网卡驱动，复制到对应目录替换**。

## RK3399-dev

| ----           | 支持设备                                                                                                              |
| -------------- | ----------------------------------------------------------------------------------------------------------------------|
| RK3399-dev     | am40,dg3399,dlfr100,fine3399,fmx1-pro,fnet-3399,h3399pc,king3399,mpc1903,sv901-eaio,tn3399,tpm312,tvi3315a,xiaobao-nas,zysj   |


## 默认配置

- 用户名: `root`
- 密  码: `password`
- 如果设备只有一个网口，则此网口就是 `LAN` ；如果设备有两个网口，则一个是 `WAN`，一个是`LAN`。



## 鸣谢

- [istoreos](https://github.com/istoreos/istoreos)
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [xiaomeng9597](https://github.com/xiaomeng9597)
- [cm9vdA](https://github.com/cm9vdA/build-linux)
- [GitHub Actions](https://github.com/features/actions)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [Lean&#39;s OpenWrt](https://github.com/coolsnowwolf/lede)
- [csexton/debugger-action](https://github.com/csexton/debugger-action)
- [Cowtransfer](https://cowtransfer.com)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release)
- [ActionsRML/delete-workflow-runs](https://github.com/ActionsRML/delete-workflow-runs)
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases)


##  免责声明
- 本固件仅供学习研究，严禁用于任何商业用途
- 使用本固件产生的所有后果均由使用者自行承担
- 固件可能存在bug，开发者不提供任何形式的技术支持
- 请严格遵守国家网络安全法律法规，合法使用
