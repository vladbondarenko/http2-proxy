FROM amazonlinux:2

RUN yum -y update
RUN yum -y install mc gcc telnet nc wget tar gzip git hostname systemd sudo dbus initscripts
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -P /tmp
RUN yum install -y /tmp/epel-release-latest-7.noarch.rpm
RUN yum install -y caddy supervisor nginx libwebp libwebp-tools
RUN amazon-linux-extras install php7.2
RUN cd /tmp && git clone https://github.com/vladbondarenko/varnish-5.2.1
RUN rm -rf /tmp/varnish-5.2.1/etc/init.d
RUN cp -r /tmp/varnish-5.2.1/etc/* /etc/
RUN cp -r /tmp/varnish-5.2.1/usr/* /usr/
RUN echo "127.0.0.1 http2.internal" >> /etc/hosts
RUN echo "http2.internal" > /etc/hostname
RUN ldconfig
RUN mkdir -p /usr/local/var/varnish/ && chmod 777 /usr/local/var/varnish/
COPY varnish.ini /etc/supervisord.d/
COPY caddy.ini /etc/supervisord.d/
COPY caddy.conf /etc/caddy/
COPY nginx.conf /etc/nginx/
COPY nginx.ini /etc/supervisord.d/
COPY default.vcl /etc/varnish/
COPY php.ini /etc/supervisord.d/
COPY caddy /bin/caddy
COPY brotli /bin/brotli
RUN mkdir -p /var/www
COPY brotli.php /var/www
COPY webp.php /var/www
RUN chown nginx:nginx /var/www/*
RUN ulimit -n 16384
CMD supervisord -c /etc/supervisord.conf -n
