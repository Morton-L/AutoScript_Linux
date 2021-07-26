#!/bin/bash
# 使用方法:
# yum install -y wget && wget --no-check-certificate https://raw.githubusercontent.com/Morton-L/AutoScript_Linux/main/Loader.sh && chmod +x Loader.sh
# ./Loader.sh php

curl -Oks https://raw.githubusercontent.com/Morton-L/HeadScript_Linux/main/loader.sh
source loader.sh font error

# 配置网址
url1=https://raw.githubusercontent.com/Morton-L/AutoScript_Linux/main
url2=https://tools.topstalk.com/shellscript/AutoScript_Linux

# 提取变量
nginx=$(echo $* | grep -o 'nginx')
openssl=$(echo $* | grep -o 'openssl')
php=$(echo $* | grep -o 'php')
nginx2php=$(echo $* | grep -o 'nginx2php')


if [ -n "$nginx" ]; then
	curl -Oks $url1/Function/AutoInstallNginx.sh
	if [ $? -ne 0 ]; then
            curl -Oks $url2/Function/AutoInstallNginx.sh
            [ $? -ne 0 ] && error
	fi
	source AutoInstallNginx.sh
	AutoInstallNginx
fi

if [ -n "$openssl" ]; then
	curl -Oks $url1/Function/AutoInstallOpenSSL.sh
	if [ $? -ne 0 ]; then
            curl -Oks $url2/Function/AutoInstallOpenSSL.sh
            [ $? -ne 0 ] && error
	fi
	source AutoInstallOpenSSL.sh
	AutoInstallOpenSSL
fi

if [ -n "$php" ]; then
	curl -Oks $url1/Function/AutoInstallPHP.sh
	if [ $? -ne 0 ]; then
            curl -Oks $url2/Function/AutoInstallPHP.sh
            [ $? -ne 0 ] && error
	fi
	source AutoInstallPHP.sh
	AutoInstallPHP
fi

if [ -n "$nginx2php" ]; then
	curl -Oks $url1/Function/Nginx2PHP.sh
	if [ $? -ne 0 ]; then
            curl -Oks $url2/Function/Nginx2PHP.sh
            [ $? -ne 0 ] && error
	fi
	source Nginx2PHP.sh
	NginX2PHP
fi
