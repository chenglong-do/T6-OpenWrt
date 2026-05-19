#!/bin/bash
clear

### 基础部分 ###

# 更新 Feeds
./scripts/feeds update -a
./scripts/feeds install -a

### 获取额外的 LuCI 应用、主题 ###
# Nikki
git clone -b main --depth 1 https://github.com/nikkinikki-org/OpenWrt-nikki.git nikki
cp -rf nikki/luci-app-nikki feeds/luci/applications/luci-app-nikki
cp -rf nikki/nikki feeds/packages/net/nikki
ln -sf ../../../feeds/luci/applications/luci-app-nikki ./package/feeds/luci/luci-app-nikki
ln -sf ../../../feeds/packages/net/nikki ./package/feeds/packages/nikki
rm -rf nikki

# Lucky
rm -rf package/lucky
git clone  https://github.com/gdy666/luci-app-lucky.git package/lucky

# emmc install
if [ ! -d "package/base-files/files/usr/bin" ]; then
    mkdir package/base-files/files/usr/bin
fi
cp -f ../scripts/emmc-install.sh package/base-files/files/usr/bin/emmc-install.sh

# 定制化配置
sed -i 's/1608/1800/g' package/emortal/cpufreq/files/cpufreq.uci
sed -i 's/2016/2208/g' package/emortal/cpufreq/files/cpufreq.uci
sed -i 's/1512/1608/g' package/emortal/cpufreq/files/cpufreq.uci
# 生成默认配置及缓存
rm -rf .config

# 清理可能因patch存在的冲突文件
find ./ -name *.orig | xargs rm -rf
find ./ -name *.rej | xargs rm -rf

exit 0
