#!/bin/bash
clear

### 基础部分 ###
# 使用 O2 级别的优化
sed -i 's/Os/O2/g' include/target.mk
# 添加nikki(mihomo) feed
echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> "feeds.conf.default"
# 更新 Feeds
./scripts/feeds update -a
./scripts/feeds install -a

### 必要的 Patches ###
# MOD dae dns
sed -i '/webrender ; \\/i\        pushd $(PKG_BUILD_DIR)\/dae-core ; \\' feeds/packages/net/daed/Makefile
sed -i '/webrender ; \\/i\        wget -qO - https://github.com/QiuSimons/luci-app-daed/raw/master/patchset/kix-feat_lockless_concurrency_udp_dns.patch | patch -p1 ; \\' feeds/packages/net/daed/Makefile
sed -i '/webrender ; \\/i\        popd ; \\' feeds/packages/net/daed/Makefile

### 获取额外的 LuCI 应用、主题 ###
# MOD Argon
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b randomPic --depth 1 https://github.com/msylgj/luci-theme-argon.git feeds/luci/themes/luci-theme-argon
# WeChatPush
rm -rf feeds/luci/applications/luci-app-wechatpush
git clone -b master --depth 1 https://github.com/tty228/luci-app-wechatpush.git feeds/luci/applications/luci-app-wechatpush
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
