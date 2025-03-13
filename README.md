<h1 align="center">NanoPC T6-OpenWrt</h1>
<p align="center">
<img src="https://forthebadge.com/images/badges/built-with-love.svg">
<p>
<p align="center">
<img src="https://github.com/chenglong-do/T6-OpenWrt/actions/workflows/Immortalwrt-snapshot.yml/badge.svg">
<p>

<h3 align="center">请勿用于商业用途!!!</h1>

## 当前已知问题:

- 无
  
## 说明

* ImmortalWrt master branch-SNAPSHOT / ImmortalWrt Release
* Linux-kernel: 6.6.x 
* Fork自 msylgj ,个人根据**完全私人**口味进行了一定修改,建议去源库了解更多
    - [msylgj](https://github.com/msylgj/R2S-R4S-OpenWrt)
* ipv4: 192.168.10.1
* username: root
* password: 空 / password
* 原汁原味非杂交! 感谢Immortalwrt/R2S Club/R4S Club/天灵/GC/QC等诸多大佬的努力!
* 添加Flow Offload+Full Cone Nat
* 支持scp和sftp
* 无usb-wifi支持
* 原生OP内置升级可用,固件重置可用
* 2.4-1.8(T6)

## 插件清单

- 仅供参考，不同设备和分支插件略有区别，具体查看SEED/config
- app:arpbind
- app:autoreboot
- app:cpufreq
- app:daed
- app:frps
- app:ramfree
- app:lucky
- app:ttyd
- app:uhttpd
- app:upnp
- app:vlmcsd
- app:wol
- app:zerotier
- theme:argon
- theme:bootstrap

## 升级方法

* 原生OP内置升级,可选保留配置
* reset按钮可用(使用squashfs格式固件)
  
## 固件烧写（SD to eMMC）

1. 下载最新 Releases 固件并通过 SD 卡启动
2. 使用 Xftp 等工具上传一份固件到 /tmp 目录，或通过终端 wget 在线下载固件到 /tmp 目录
3. 使用内建命令写入固件到 eMMC 存储（请根据实际文件名称与路径）
4. 脚本来自 sbwml 大佬
   
```sh
emmc-install /tmp/xxx-squashfs-sysupgrade.img.gz
```

## 特别感谢（排名不分先后）

- [msylgj](https://github.com/msylgj/R2S-R4S-OpenWrt)
- [sbwml](https://github.com/sbwml/r4s_build_script)
- [immortalwrt](https://github.com/immortalwrt/immortalwrt)
- [CTCGFW](https://github.com/immortalwrt) 
- [coolsnowwolf](https://github.com/coolsnowwolf)
- [QiuSimons](https://github.com/QiuSimons) 
- [Quintus](https://github.com/quintus-lab)
- [mj22226](https://github.com/mj22226) 
