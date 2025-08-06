#!/bin/bash
clear

### 基础部分 ###
# 使用 O2 级别的优化
sed -i 's/Os/O2/g' include/target.mk
# 更新 Feeds
./scripts/feeds update -a
./scripts/feeds install -a

### 必要的 Patches ###
# 替换原有的 luci-app-daed 和 daed 使用kixdaed
git clone -b master --depth 1 https://github.com/QiuSimons/luci-app-daed.git kixdaed
rm -rf feeds/luci/applications/luci-app-daed
rm -rf feeds/packages/net/daed
cp -rf kixdaed/luci-app-daed feeds/luci/applications/luci-app-daed
cp -rf kixdaed/daed feeds/packages/net/daed
rm -rf kixdaed

### 获取额外的 LuCI 应用、主题 ###
# Nikki with SmartGroup
git clone -b main --depth 1 https://github.com/msylgj/OpenWrt-nikki.git nikki
cp -rf nikki/luci-app-nikki feeds/luci/applications/luci-app-nikki
cp -rf nikki/nikki feeds/packages/net/nikki
ln -sf ../../../feeds/luci/applications/luci-app-nikki ./package/feeds/luci/luci-app-nikki
ln -sf ../../../feeds/packages/net/nikki ./package/feeds/packages/nikki
rm -rf nikki
# MOD Argon
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b randomPic --depth 1 https://github.com/msylgj/luci-theme-argon.git feeds/luci/themes/luci-theme-argon
# geodata
rm -rf feeds/packages/net/v2ray-geodata
git clone -b main --depth 1 https://github.com/JohnsonRan/packages_net_v2ray-geodata.git feeds/packages/net/v2ray-geodata
# 更换 Nodejs 版本
rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt feeds/packages/lang/node
# Lucky
rm -rf package/lucky
git clone  https://github.com/gdy666/luci-app-lucky.git package/lucky

# emmc install
if [ ! -d "package/base-files/files/usr/bin" ]; then
    mkdir package/base-files/files/usr/bin
fi
cp -f ../SCRIPTS/emmc-install.sh package/base-files/files/usr/bin/emmc-install.sh

# 定制化配置
sed -i "s/%D %V %C/Built by OPENWRT($(date +%Y.%m.%d))@%D %V %C/g" package/base-files/files/usr/lib/os-release
sed -i "/%D/a\ Built by OPENWRT($(date +%Y.%m.%d))" package/base-files/files/etc/banner
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/1608/1800/g' package/emortal/cpufreq/files/cpufreq.uci
sed -i 's/2016/2208/g' package/emortal/cpufreq/files/cpufreq.uci
sed -i 's/1512/1608/g' package/emortal/cpufreq/files/cpufreq.uci
# 生成默认配置及缓存
rm -rf .config

# 清理可能因patch存在的冲突文件
find ./ -name *.orig | xargs rm -rf
find ./ -name *.rej | xargs rm -rf

exit 0
