#!/bin/bash

perl -pi -e "s/proxy_pass.+$/proxy_pass $PROTO:\/\/$ORIGIN:$PORT;/g" /etc/nginx/nginx.conf
perl -pi -e "s/\*:/$DOMAIN:/g" /etc/caddy/caddy.conf
if [ ! `ls -la /etc/ssl/*.pem|wc -l` -gt "0" ];then
perl -pi -e "s/tls { load \/etc\/ssl }/tls self_signed/g" /etc/caddy/caddy.conf
fi
supervisord -c /etc/supervisord.conf -n