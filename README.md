# http2-proxy

HTTP/2 proxy using docker.

This proxy serves http website using QUIC/39 protocol, compresses html,css,js using brotli and compresses jpg/png using Webp format and caching responses with Varnish.

Still on active development. Not for production use.

# how to use

docker build -t http2 .

docker run --name http2 -d -p 443:443 -p 80:80 --hostname http2.internal http2
