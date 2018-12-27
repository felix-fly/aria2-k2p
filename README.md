# aria2-k2p

本文为在k2p路由器使用padavan(N56U/改华硕)固件手工安装配置aria2及weiui的简单流程，其他型号路由器理论上类似，可以参考。

hanwckf/rt-n56u库里本身是包含aria2工具的，但是不知道是什么原因k2p的固件并未包含，自己修改了配置文件编译后还是没有。于是就准备来个手动挡的，所以有了下文。

ps：文末有福利哦～～

## 重要提示：

手动安装aria2，需要自行编译路由器固件，增大storage分区的大小，可以先fork一下[https://github.com/hanwckf/rt-n56u](https://github.com/hanwckf/rt-n56u)，然后根据自己的需要修改配置文件，目前使用的是自编译的K2P_DRV，如果有需要可以在我的repositories里找[rt-n56u](https://github.com/felix-fly/rt-n56u)。

需要修改2个文件，目前将storage分区大小调整为7mb，为以后可以安装更多软件，修改时注意进制及单位：

* trunk/configs/boards/K2P/kernel-3.4.x.config [修改记录](https://github.com/felix-fly/rt-n56u/commit/afc67c1d64d895adca1851c8251da17bcec17f27)
* trunk/user/scripts/mtd_storage.sh [修改记录](https://github.com/felix-fly/rt-n56u/commit/57f7c7f3ac824f35ddd6733a30c8ac1435cb49e8)

由于k2p本身并没有usb接口，不支持挂载硬盘，所以aria2下载需要额外的网络文件存储服务，本文用的是nfs，由局域网中另外一台设备提供。编译固件时需要修改内核编译参数，启用nfs：

```
# trunk/configs/boards/K2P/kernel-3.4.x.config

CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
```

```
# configs/templates/K2P_DRV.config

CONFIG_FIRMWARE_INCLUDE_NFSC=y
```

## 获取最新版本的aria2及webui

* [aria2](https://aria2.github.io/)

* [webui-aria2](https://github.com/ziahamza/webui-aria2)

aria2c目前是从rt-n56u代码库里提取出来的，本身大概3mb，用upx压缩了下然后只有1mb多点，webui原始大小约2mb，于是又fork了一下，移除了其它语言，只保留中文，同时将js和css进一步压缩，目前大小约0.7mb，路由上就是寸土寸金，能省一点就是赚一点。

*aria2官方release并不包含mips平台的二进制版本，以后有需要再把自己编译这块补上。*

## web服务

路由固件本身就包含一个web服务，开始的时候是直接将aria2挂到www目录下的，可以正常工作。但是使用aria2的时候需要先登录路由器管理页面，感觉有些麻烦，尝试去修改httpd的配置文件，发现并没有使用配置文件，不好自定义。所以用了另外的方式，在81端口再启一个httpd服务专门给aria2使用。

## 上传软件

上传所有文件到/etc/storage/aria2下

```
mkdir /etc/storage/aria2
cd /etc/storage/aria2
# 上传aria2相关文件到该目录下
chmod +x aria2c aria2.sh
```

aria2.sh脚本文件中===NFS_PATH===需要替换为你的nfs路径。

## 设置v2ray开机自动启动

**高级设置 -> 自定义设置 -> 脚本 -> 在防火墙规则启动后执行:**

```
# 增加一行
/etc/storage/aria2/aria2.sh
```

## 保存软件及配置

padavan系统文件系统是构建在内存中的，重启后软件及配置会丢失，所以操作完成后，需要将aria2及配置写入闪存。

**高级设置 -> 系统管理 -> 配置管理 -> 保存内部存储到闪存: 提交**

由于aria2及webui程序比较大，提交保存操作需要一定的时间，点过提交后请耐心等待1分钟，以确保写入成功。

如果一切顺利，重启路由器后打开 [http://my.router:81/index.html](http://my.router:81/index.html) 就会看到它了。Good luck!

k2p默认情况下是没有usb不能挂硬盘的，这时需要在webui中修改下载文件保存路径：

```
/mnt/Download
```

## 更新记录

2018-12-27
* 改用开启另外一个httpd提供web服务

2018-12-25
* 初版 & 优化了webui的体积

## 福利发放中，点击领取

不方便编译固件的小伙伴可以领取k2p纯净版padavan固件一枚，开启了nfs客户端支持，固件为自用，并不提供技术支持哦。

固件在这里 [https://github.com/felix-fly/rt-n56u/releases](https://github.com/felix-fly/rt-n56u/releases)
