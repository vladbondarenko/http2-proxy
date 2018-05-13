# http2-proxy

HTTP/2 proxy using docker.

This proxy serves http website using QUIC/39 protocol, compresses html,css,js using brotli and compresses jpg/png using Webp format and caching responses with Varnish.

Still on active development.

# how to use

Build:

docker build -t http2 .

Set environment variables:

PROTO should be http or https
ORIGIN should be ip address or domain name of origin
PORT should be decimal port number
DOMAIN should be domain name that will be served

Put your SSL certificate files (you should concatenate all into 1 .pem file) into /etc/ssl/ dir.
If you dont have SSL certificate then self-sign certificate will be created and used.

Run container:

docker run --name http2 -d -p 443:443 -p 80:80 -v /etc/ssl:/etc/ssl --env DOMAIN=test.test.com --env PROTO=http --env ORIGIN=2.2.2.2 --env PORT=8080 --hostname http2.internal http2
