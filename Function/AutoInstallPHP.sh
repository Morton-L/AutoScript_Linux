#!/bin/bash

# 编译安装PHP
function AutoInstallPHP(){
	green " =================================================="
	green " PHP安装准备..."
	green " =================================================="
	sleep 2s
	yum install -y wget gcc libxml2-devel sqlite-devel make
	
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 依赖组件安装失败...请检查网络连接"
		Error
	fi
	cd /usr/local
	green " =================================================="
	green " 开始下载PHP源码..."
	green " =================================================="
	wget --no-check-certificate https://www.php.net/distributions/php-8.0.8.tar.gz
	# 判断执行结果
	if [ $? -ne 0 ]; then
		ErrorInfo=" 下载失败...请检查网络连接"
		Error
	fi
	tar zxvf php-8.0.8.tar.gz
	cd php-8.0.8
	./configure --enable-fpm
	green " =================================================="
	green " 开始编译并安装PHP..."
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
	green " PHP安装完成"
	green " =================================================="
	cat > "/lib/systemd/system/php-fpm.service" <<-EOF
[Unit]
Description=php-fpm
After=network.target
[Service]
Type=forking
ExecStart=/usr/local/sbin/php-fpm
ExecStop=/bin/pkill -9 php-fpm
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
	green " =================================================="
	green " 正在处理PHP事项..."
	green " =================================================="
	cp php.ini-development /usr/local/php/php.ini
	cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf
	cp sapi/fpm/php-fpm /usr/local/bin
	cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf
	sed -i 's/\;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/php.ini
	sed -i 's/include\=NONE\/etc\/php-fpm\.d\/\*\.conf/include\=\/usr\/local\/etc\/php\-fpm\.d\/\*\.conf/g' /usr/local/etc/php-fpm.conf
	systemctl start php-fpm.service
	green " 验证安装..."
	netstat -anp | grep php-fpm &> /dev/null
	if [ $? -ne 0 ]; then
        ErrorInfo=" PHP启动失败..."
		Error
    fi
	green " PASS"
	green " =================================================="
	green " 将PHP加入自启动项"
	green " =================================================="
	systemctl enable php-fpm.service
	green " =================================================="
	green " 安装完成!"
	green " =================================================="
}

