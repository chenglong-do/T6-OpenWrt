#!/bin/bash

# {{ Add luci-app-diskman
(cd friendlywrt && {
    mkdir -p package/luci-app-diskman
    wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/applications/luci-app-diskman/Makefile.old -O package/luci-app-diskman/Makefile
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk=y
CONFIG_PACKAGE_luci-i18n-diskman-zh-cn=y
CONFIG_PACKAGE_smartmontools=y
EOL
# }}

# {{ Add luci-theme-argon
(cd friendlywrt/package && {
    [ -d luci-theme-argon ] && rm -rf luci-theme-argon
    git clone https://github.com/jerrykuku/luci-theme-argon.git --depth 1 -b master
})
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> configs/rockchip/01-nanopi
sed -i -e 's/function init_theme/function old_init_theme/g' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
cat > /tmp/appendtext.txt <<EOL
function init_theme() {
    if uci get luci.themes.Argon >/dev/null 2>&1; then
        uci set luci.main.mediaurlbase="/luci-static/argon"
        uci commit luci
    fi
}
EOL
sed -i -e '/boardname=/r /tmp/appendtext.txt' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
# }}

add_or_update_config() {
    local config_item="$1"
    local config_file="${2:-configs/rockchip/01-nanopi}"

    # 检查文件是否存在
    if [ ! -f "$config_file" ]; then
        echo "错误：配置文件 $config_file 不存在"
        return 1
    fi

    # 提取配置项名称（等号前的部分）
    local config_name="${config_item%%=*}"

    if grep -q "^${config_name}=" "$config_file"; then
        # 配置项已存在，修改其值
        sed -i "s|^${config_name}=.*|${config_item}|" "$config_file"
    else
        # 配置项不存在，添加新配置
        echo "$config_item" >> "$config_file"
    fi
}

# {{ Add luci-app-lucky
(cd friendlywrt/package && {
    [ -d luci-app-lucky ] && rm -rf luci-app-lucky
    git clone https://github.com/gdy666/luci-app-lucky.git --depth 1
})
add_or_update_config "CONFIG_PACKAGE_luci-compat=y"
add_or_update_config "CONFIG_PACKAGE_luci-lua-runtime=y"
add_or_update_config "CONFIG_PACKAGE_luci-base=y"
add_or_update_config "CONFIG_PACKAGE_luci-app-lucky=y"
# }}

# {{ Add luci-app-openclash
(cd friendlywrt/package && {
    [ -d OpenClash ] && rm -rf OpenClash
    git clone https://github.com/vernesong/OpenClash.git --depth 1
})
add_or_update_config "CONFIG_PACKAGE_bash=y"
add_or_update_config "CONFIG_PACKAGE_curl=y"
add_or_update_config "CONFIG_PACKAGE_ruby=y"
add_or_update_config "CONFIG_PACKAGE_ruby-yaml=y"
add_or_update_config "CONFIG_PACKAGE_unzip=y"
add_or_update_config "CONFIG_PACKAGE_luci-app-openclash=y"
# }}

add_or_update_config "CONFIG_PACKAGE_luci-app-ttyd=y"
add_or_update_config "CONFIG_PACKAGE_luci-app-upnp=y"
add_or_update_config "CONFIG_PACKAGE_luci-app-vlmcsd=n"
