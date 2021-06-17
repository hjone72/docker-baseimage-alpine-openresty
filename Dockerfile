FROM ghcr.io/linuxserver/baseimage-alpine:3.14

# install packages
RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache \
    apache2-utils \
    git \
    libressl3.3-libssl \
    logrotate \
    nano \
    nginx \
    openssl \
    php8 \
    php8-fileinfo \
    php8-fpm \
    php8-json \
    php8-mbstring \
    php8-openssl \
    php8-session \
    php8-simplexml \
    php8-xml \
    php8-xmlwriter \
    php8-zlib && \
  echo "**** configure nginx ****" && \
  echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> \
    /etc/nginx/fastcgi_params && \
  rm -f /etc/nginx/http.d/default.conf && \
  echo "**** fix logrotate ****" && \
  sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
  sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
    /etc/periodic/daily/logrotate

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
