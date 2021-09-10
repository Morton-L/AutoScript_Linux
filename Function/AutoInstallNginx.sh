#!/bin/bash

curl -Oks https://raw.githubusercontent.com/Morton-L/HeadScript_Linux/main/loader.sh
source loader.sh error

# 编译安装Nginx
function AutoInstallNginx(){

	configure="--with-http_ssl_module --with-http_v2_module"
	green " =================================================="
	green " 请输入安装配置项,如无额外配置可留空 "
	green " 默认安装配置项 :"
	yellow " $configure"
	green " =================================================="
	read -p " 请输入安装配置项,如无额外配置可留空 :" configureE
	
	configure="${configure} ${configureE}"
	
	green " =================================================="
	green " 安装配置项为 :"
	yellow " $configure"
	green " =================================================="
	sleep 4s
	
	green " =================================================="
	green " Nginx安装准备..."
	green " =================================================="
	sleep 2s
	yum install -y pcre-devel zlib-devel perl gcc wget net-tools tar
	
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 依赖组件安装失败...请检查网络连接"
		Error
	fi
	
	green " =================================================="
	green " 检测OpenSSL版本"
	green " =================================================="
	OpenSSLVersion=$(expr substr "$(/usr/local/bin/openssl version)" 9 6)
	if [ -z $OpenSSLVersion ]; then
		red " =================================================="
        echo " 未在本机检测到OpenSSL"
		red " =================================================="
		InstallOpenSSL
    fi
	OpenSSLVersionNUM=$(echo $OpenSSLVersion | tr -cd "[0-9]" )		
	if [[ "111" > "$OpenSSLVersionNUM" ]]; then
        green " =================================================="
		green " OpenSSL需要更新"
		green " =================================================="
		InstallOpenSSL
    fi
	cd /usr/local
	green " =================================================="
	green " 开始下载Nginx源码..."
	green " =================================================="
	wget https://nginx.org/download/nginx-1.21.1.tar.gz
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 下载失败...请检查网络连接"
		Error
	fi
	tar -xvzf nginx-1.21.1.tar.gz
	cd /usr/local/nginx-1.21.1
	./configure $configure
	green " =================================================="
	green " 开始编译并安装Nginx..."
	green " =================================================="
	make
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 编译失败...请查看日志"
		Error
	fi
	make install
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 安装失败...请查看日志"
		Error
	fi
	green " =================================================="
	green " Nginx安装完成"
	green " =================================================="
	cat > "/lib/systemd/system/nginx.service" <<-EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
	green " =================================================="
	green " 正在处理Nginx事项..."
	green " =================================================="
	sed -i 's/\#pid        logs\/nginx.pid;/pid        \/run\/nginx.pid;/g' /usr/local/nginx/conf/nginx.conf
	systemctl daemon-reload
	ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
	ln -s /usr/local/nginx/conf/ /etc/nginx
	green " =================================================="
	green " 启动Nginx..."
	green " =================================================="
	systemctl start nginx.service
	green " 验证安装..."
	netstat -anp | grep nginx &> /dev/null
	if [ $? -ne 0 ]; then
        ErrorInfo=" Nginx启动失败..."
		Error
    fi
	green " PASS"
	green " =================================================="
	green " 将Nginx加入自启动项"
	green " =================================================="
	systemctl enable nginx.service
	green " =================================================="
	green " 安装完成!"
	green " =================================================="
	FirewalldConfig
}

function InstallOpenSSL(){
	url1=https://raw.githubusercontent.com/Morton-L/AutoScript_Linux/main
	url2=https://tools.topstalk.com/shellscript/AutoScript_Linux
	curl -Oks $url1/Function/AutoInstallOpenSSL.sh
	if [ $? -ne 0 ]; then
            curl -Oks $url2/Function/AutoInstallOpenSSL.sh
            [ $? -ne 0 ] && error
	fi
	source AutoInstallOpenSSL.sh
	AutoInstallOpenSSL
}

#调整防火墙
function FirewalldConfig(){
	green " =================================================="
	green " 调整防火墙规则..."
	green " =================================================="
	firewall-cmd --permanent --add-service=http
	firewall-cmd --permanent --add-service=https
	firewall-cmd --reload
}
