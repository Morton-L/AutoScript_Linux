#!/bin/bash

curl -Oks https://raw.githubusercontent.com/Morton-L/HeadScript_Linux/main/loader.sh
source loader.sh error

# 编译安装OpenSSL
function AutoInstallOpenSSL(){
    green " =================================================="
	green " 开始安装OpenSSL"
	green " =================================================="
	sleep 6s
	yum remove -y openssl
	yum install -y wget tar perl gcc
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 依赖组件安装失败...请检查网络连接"
		Error
	fi
	cd /usr/local
	green " =================================================="
	green " 开始下载OpenSSL源码..."
	green " =================================================="
	wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1l.tar.gz
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 下载失败...请检查网络连接"
		Error
	fi
	tar -xvzf openssl-1.1.1l.tar.gz
	cd openssl-1.1.1l
	./Configure
	./config
	green " =================================================="
	green " 开始编译并安装OpenSSL..."
	green " =================================================="
	make
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 编译失败...请查看日志"
		Error
	fi
	make test
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 编译测试未通过...请重试"
		Error
	fi
	make install
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 安装失败...请查看日志"
		Error
	fi
	mv /usr/bin/openssl /usr/bin/openssl-old
	ln -s /usr/local/bin/openssl /usr/bin/openssl
	OpenSSLVersion=$(expr substr "$(/usr/local/bin/openssl version)" 9 6)
	green " =================================================="
	green " OpenSSL版本:   ${OpenSSLVersion}"
	green " =================================================="
}
