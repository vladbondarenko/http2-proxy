# http2-proxy

HTTP/2 proxy using docker.

This proxy serves http website using QUIC/39 protocol, compresses html,css,js using brotli and compresses jpg/png using Webp format and caching responses with Varnish.

Still on active development. Not for production use.

# how to use

docker build -t http2 .

PROTO should be http or https
ORIGIN should be ip address or domain name of origin

docker run --name http2 -d -p 443:443 -p 80:80 --env PROTO=PROTOCOL_OF_ORIGIN --env ORIGIN=IP_ADDRESS_OF_ORIGIN --env PORT=PORT_OF_ORIGIN --hostname http2.internal http2
