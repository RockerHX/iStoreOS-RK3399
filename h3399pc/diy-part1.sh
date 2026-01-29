#!/bin/bash
#===============================================
# Description: DIY script part 1
# File name: diy-part1.sh
# Author: RockerHX
#===============================================

# 修改版本为编译日期,数字类型
date_version=$(date +"%Y%m")
echo $date_version > version

# 为iStoreOS固件版本加上编译作者
author="RockerHX"
sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='%D %V ${date_version} by ${author}'/g" package/base-files/files/etc/openwrt_release
sed -i "s/OPENWRT_RELEASE.*/OPENWRT_RELEASE=\"%D %V ${date_version} by ${author}\"/g" package/base-files/files/usr/lib/os-release
