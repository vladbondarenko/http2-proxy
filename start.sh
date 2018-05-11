#!/bin/bash

perl -pi -e "s/proxy_pass.+$/proxy_pass $PROTO:\/\/$ORIGIN:$PORT;/g" /etc/nginx/nginx.conf
supervisord -c /etc/supervisord.conf -n