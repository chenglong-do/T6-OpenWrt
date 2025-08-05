#!/bin/bash
clear

### 基础部分 ###
# 添加nikki(mihomo) feed
echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> "feeds.conf.default"
# 更新 Feeds
./scripts/feeds update -a
./scripts/feeds install -a

### 必要的 Patches ###


### 获取额外的 LuCI 应用、主题 ###
# Lucky
rm -rf package/lucky
git clone --depth=1 https://github.com/gdy666/luci-app-lucky.git package/lucky

# add luci-app-OpenClash
rm -rf package/OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash package/OpenClash

# emmc install
if [ ! -d "package/base-files/files/usr/bin" ]; then
    mkdir package/base-files/files/usr/bin
fi
cp -f ../SCRIPTS/emmc-install.sh package/base-files/files/usr/bin/emmc-install.sh

# 定制化配置
sed -i "s/%D %V %C/Built by OPENWRT($(date +%Y.%m.%d))@%D %V %C/g" package/base-files/files/usr/lib/os-release
sed -i "/%D/a\ Built by OPENWRT($(date +%Y.%m.%d))" package/base-files/files/etc/banner
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 生成默认配置及缓存
rm -rf .config

# 清理可能因patch存在的冲突文件
find ./ -name *.orig | xargs rm -rf
find ./ -name *.rej | xargs rm -rf

exit 0
