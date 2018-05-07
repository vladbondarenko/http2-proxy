<?php

$r=rand();
$url = "http://127.0.0.1:70".$_SERVER['REQUEST_URI'];

$options = array(
  'http'=>array(
    'method'=>"GET",
    'header'=>"Accept-language: en\r\n" .
              "Host: ".$_SERVER['HTTP_HOST']."\r\n" .
              "User-Agent: HTTP2-Proxy\r\n"
  )
);

$context = stream_context_create($options);
$file = file_get_contents($url, false, $context);
file_put_contents("/tmp/br".$r,$file);
$out = passthru("cat /tmp/br".$r." | /bin/brotli -c",$err);
unlink("/tmp/br".$r);
header("Content-Encoding: br");
echo $out;