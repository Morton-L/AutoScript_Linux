# AutoScript_Linux

## About - 关于

写这套脚本的原因是因为我经常有服务器需要部署,一条一条机械化的输入命令机械化的流程很枯燥且有出错的可能性,

于是就想着写一套脚本来实现,后来觉得挺好用,但是也发现了一些问题,就是每次写脚本如果想要做到风格或者特性统一

,那就需要重复写很多代码,同样是为了统一,需要从其他脚本中拷贝代码,再去读,回忆我当时是怎么想的怎么写的,又变成

了一件头疼的事,所以便将它模块化了.

该脚本是模块化脚本的一部分,主要为相关软件的编译和安装所用

## Used - 使用

首先建议在服务器中部署Screen,否则脚本执行到一半,因为网络原因Connection closing了,那就尴尬了...

下面命令会加载EPEL源并安装Screen,新建并进入一个名为shell的会话,接下来的所有操作都会在这个会话中执行,

```bash
yum install -y epel-release && yum install -y screen && screen -S shell
```

如果中途网络连接中断了,只需要连接终端并执行`screen -r shell`即可进入会话,正在执行的命令和脚本不会因ssh连接中

断而停止.

随后安装wget下载工具(不然你怎么把脚本下载下来?curl毕竟不是专门干这个的),下载脚本并赋予可执行权限

```bash
yum install -y wget && wget --no-check-certificate https://raw.githubusercontent.com/Morton-L/AutoScript_Linux/main/Loader.sh && chmod +x Loader.sh
```

然后执行它,记得带`参数`,否则他不会做任何事,以下是示例:

```bash
./Loader.sh php
```

它会以官方的标准编译和方法,最简安装,因为我有系统洁癖,所以多余的任何事都不会去做,比如像编译和安装php,它只会以

fpm方式安装,其他任何参数都没有加

## 参数

目前支持的参数如下:

php

下载官方最新稳定版PHP8.0.8并编译和安装,只开启了fpm支持

nginx

下载官方最新稳定版Nginx1.12.1并编译和安装,只开启了SSL支持和http2支持

有些情况下,你可能不是编译安装的OpenSSL或可能是系统自带的OpenSSL,他的版本或者可执行文件位置不标准,则会自动执

行openssl参数,也就是下面的参数.

openssl

下载官方最新稳定版OpenSSL1.1.1k并编译和安装

n2p

当你使用本脚本安装Nginx和PHP,你会发现他们是两款独立的软件,如果你想实现Nginx和PHP的交互,则可以使用此参数,注意,

仅限于使用本脚本部署的Nginx和PHP,否则可能会出现问题.

nodejs

下载官方稳定版Node.js(v14.17.5)二进制文件,并部署