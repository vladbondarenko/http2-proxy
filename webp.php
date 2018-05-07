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
file_put_contents("/tmp/webp".$r,$file);
$out = passthru("/bin/cwebp /tmp/webp".$r." -o /tmp/webp".$r.".webp -quiet",$err);
$out = file_get_contents("/tmp/webp".$r.".webp");
unlink("/tmp/webp".$r.".webp");
header("Content-Type: image/webp");
echo $out;