#!/bin/bash

# update ubus git HEAD
#cp -f $GITHUB_WORKSPACE/configfiles/ubus_Makefile package/system/ubus/Makefile

# 近期istoreos网站文件服务器不稳定，临时增加一个自定义下载网址
sed -i "s/push @mirrors, 'https:\/\/mirror2.openwrt.org\/sources';/&\\npush @mirrors, 'https:\/\/github.com\/xiaomeng9597\/files\/releases\/download\/iStoreosFile';/g" scripts/download.pl

# Lucky
rm -rf package/lucky
git clone --depth=1 https://github.com/gdy666/luci-app-lucky.git package/lucky

# OpenClash
rm -rf package/OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/OpenClash