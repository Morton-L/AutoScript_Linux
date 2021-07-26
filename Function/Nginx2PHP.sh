
# 对接
function NginX2PHP(){
	green " 实现交互..."
	systemctl stop nginx.service
	sed -i '/#location \~ \\.php\$ {/{x;s/^/./;/^\.\{2\}$/{x;s/.*/location \~ \\.php\$ {/;x};x;}' /usr/local/nginx/conf/nginx.conf
	sed -i 's/\#    root           html\;/    root           html\;/g' /usr/local/nginx/conf/nginx.conf
	sed -i 's/\#    fastcgi\_pass   127\.0\.0\.1\:9000\;/    fastcgi\_pass   127\.0\.0\.1\:9000\;/g' /usr/local/nginx/conf/nginx.conf
	sed -i 's/\#    fastcgi\_index  index\.php\;/    fastcgi\_index  index\.php\;/g' /usr/local/nginx/conf/nginx.conf
	sed -i 's/\#    fastcgi\_param  SCRIPT\_FILENAME  \/scripts\$fastcgi\_script\_name\;/    fastcgi\_param  SCRIPT\_FILENAME  \$document_root\$fastcgi\_script\_name\;/g' /usr/local/nginx/conf/nginx.conf
	sed -i 's/\#    include        fastcgi\_params\;/    include        fastcgi\_params\;/g' /usr/local/nginx/conf/nginx.conf
	sed -i '/    include        fastcgi\_params\;/a	}' /usr/local/nginx/conf/nginx.conf
	sleep 2s
	systemctl start nginx.service
	netstat -anp | grep nginx &> /dev/null
	if [ $? -ne 0 ]; then
        ErrorInfo=" Nginx启动失败..."
		Error
    fi
	green " PASS"
	green " =================================================="
	green " Nginx与PHP交互配置完成..."
	green " =================================================="
	echo "<?php phpinfo(); ?>" >> /usr/local/nginx/html/index.php
	green " =================================================="
	green " 请访问主机/index.php查看是否生效"
	green " =================================================="
}

