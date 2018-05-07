vcl 4.0;

import geoip2;
import std;
import cookie;
import directors;
import header;
import saintmode;
import tcp;
import var;
import vsthrottle;
import xkey;
# Default backend definition. Set this to point to your content server.
backend default {
    .host = "127.0.0.1";
    .port = "70";
}

backend brotli {
    .host = "127.0.0.1";
    .port = "71";
}

backend webp {
    .host = "127.0.0.1";
    .port = "72";
}

sub vcl_init {
    new country = geoip2.geoip2("/etc/varnish/GeoLite2-Country.mmdb");
}

sub vcl_hash {
  hash_data(req.url);
  if(req.http.X-brotli == "true") {
      hash_data(req.url+"brotli");
      set req.http.X-HTTP2-key = req.url+"brotli";
  }
  if(req.http.X-webp == "true") {
      hash_data(req.url+"webp");
      set req.http.X-HTTP2-key = req.url+"webp";
  }

  return (lookup);
}

sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.
    #std.syslog(180,"Ip: "+client.ip+"|Country: "+country.lookup("country/names/en", client.ip));
    set req.backend_hint = default;
    if(req.http.Accept-Encoding ~ "br" && req.url !~ "(?i)\.(jpg|png|gif|svg|gz|mp3|mov|avi|mpg|mp4|swf|wmf)") {
            set req.http.X-brotli = "true";
            set req.backend_hint = brotli;
    }
    if(req.http.Accept ~ "webp" && req.url ~ "(?i)\.(jpg|png)"){
            set req.http.X-webp = "true";
            set req.backend_hint = webp;
    }
return(hash);
}

sub vcl_backend_fetch {
    if(bereq.http.X-brotli == "true") {
        set bereq.http.Accept-Encoding = "br";
        unset bereq.http.X-brotli;
    }
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.

    if (beresp.status == 200){
     set beresp.ttl = 3600s;
    } else {
     set beresp.ttl = 0s;
    }
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
 if (req.http.X-brotli == "true"){
   set resp.http.Content-Encoding="br";
 }
 if (req.url ~ "(?i)\.css"){
   set resp.http.Content-Type="text/css";
 }
 if (req.url ~ "(?i)\.js"){
   set resp.http.Content-Type="application/javascript";
 }
}
