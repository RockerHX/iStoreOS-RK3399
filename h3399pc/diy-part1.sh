#!/bin/bash
#===============================================
# Description: DIY script part 1
# File name: diy-part1.sh
# Author: RockerHX
#===============================================

# 修改版本为编译日期+时间,便于一天多次编译时区分版本
# 格式: YYYYMM-HHMM (例如: 202602-1425)
date_version=$(date +"%Y%m-%H%M")
echo $date_version > version

# 为iStoreOS固件版本加上编译作者和时间戳
# 显示格式: 202602-1425 by RockerHX
author="RockerHX"
sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='%D %V ${date_version} by ${author}'/g" package/base-files/files/etc/openwrt_release
sed -i "s/OPENWRT_RELEASE.*/OPENWRT_RELEASE=\"%D %V ${date_version} by ${author}\"/g" package/base-files/files/usr/lib/os-release
