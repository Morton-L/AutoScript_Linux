#!/bin/bash

curl -Oks https://raw.githubusercontent.com/Morton-L/HeadScript_Linux/main/loader.sh
source loader.sh error

function AutoInstallNodejs(){
	green " =================================================="
	green " Node.js安装准备..."
	green " =================================================="
	sleep 2s
	yum install -y tar
	wget https://nodejs.org/dist/v14.17.5/node-v14.17.5-linux-x64.tar.xz
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 依赖组件安装失败...请检查网络连接"
		Error
	fi
	sudo mkdir -p /usr/local/lib
	sudo tar -xJvf node-v14.17.5-linux-x64.tar.xz -C /usr/local/lib
	mv /usr/local/lib/node-v14.17.5-linux-x64 /usr/local/lib/nodejs 
	ln -s /usr/local/lib/nodejs/bin/node /usr/bin/node
	ln -s /usr/local/lib/nodejs/bin/npm /usr/bin/npm
	ln -s /usr/local/lib/nodejs/bin/npx /usr/bin/npx
	green " =================================================="
	green " 验证安装..."
	green " =================================================="
	green " =================================================="
	green " Node版本信息:"
	node -v
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 安装失败...请查看日志"
		Error
	fi
	green " =================================================="
	npm version
	green " npm版本信息:"
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 安装失败...请查看日志"
		Error
	fi
	green " =================================================="
	green " npx版本信息:"
	npx -v
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 安装失败...请查看日志"
		Error
	fi
	green " =================================================="
}