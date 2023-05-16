# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.18

# install packages
RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache \
    apache2-utils \
    git \
    logrotate \
    nano \
    nginx \
    openssl \
    php82 \
    php82-fileinfo \
    php82-fpm \
    php82-json \
    php82-mbstring \
    php82-openssl \
    php82-session \
    php82-simplexml \
    php82-xml \
    php82-xmlwriter \
    php82-zlib && \
  echo "**** configure nginx ****" && \
  echo 'fastcgi_param  HTTP_PROXY         ""; # https://httpoxy.org/' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  PATH_INFO          $fastcgi_path_info; # http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_split_path_info' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name; # https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/#connecting-nginx-to-php-fpm' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  SERVER_NAME        $host; # Send HTTP_HOST as SERVER_NAME. If HTTP_HOST is blank, send the value of server_name from nginx (default is `_`)' >> \
    /etc/nginx/fastcgi_params && \
  rm -f /etc/nginx/conf.d/stream.conf && \
  rm -f /etc/nginx/http.d/default.conf && \
  echo "**** configure php ****" && \
  sed -i "s#;error_log = log/php82/error.log.*#error_log = /config/log/php/error.log#g" \
    /etc/php82/php-fpm.conf && \
  sed -i "s#user = nobody.*#user = abc#g" \
    /etc/php82/php-fpm.d/www.conf && \
  sed -i "s#group = nobody.*#group = abc#g" \
    /etc/php82/php-fpm.d/www.conf && \
  echo "**** fix logrotate ****" && \
  sed -i "s#/var/log/messages {}.*# #g" \
    /etc/logrotate.conf && \
  sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
    /etc/periodic/daily/logrotate

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
