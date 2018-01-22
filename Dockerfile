#!/usr/bin/env bash
#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
# docker build -t c7.3:dev -f Dockerfile .
# dk commit 0310424581be c7.3:php-dev

FROM centos:7.3.1611

# 开发环境基本依赖库的升级与安装
RUN set -ex \
	&& cd /etc/yum.repos.d \
	&& { \
        echo '[epel]'; \
        echo 'name=Extra Packages for Enterprise Linux 7 - $basearch'; \
        echo 'baseurl=http://mirrors.aliyun.com/epel/7/$basearch'; \
        echo '        http://mirrors.aliyuncs.com/epel/7/$basearch'; \
        echo 'failovermethod=priority'; \
        echo 'enabled=1'; \
        echo 'gpgcheck=0'; \
        echo 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7'; \
        echo; \
        echo '[epel-debuginfo]'; \
        echo 'name=Extra Packages for Enterprise Linux 7 - $basearch - Debug'; \
        echo 'baseurl=http://mirrors.aliyun.com/epel/7/$basearch/debug'; \
        echo '        http://mirrors.aliyuncs.com/epel/7/$basearch/debug'; \
        echo 'failovermethod=priority'; \
        echo 'enabled=0'; \
        echo 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7'; \
        echo 'gpgcheck=0'; \
        echo; \
        echo '[epel-source]'; \
        echo 'name=Extra Packages for Enterprise Linux 7 - $basearch - Source'; \
        echo 'baseurl=http://mirrors.aliyun.com/epel/7/SRPMS'; \
        echo '        http://mirrors.aliyuncs.com/epel/7/SRPMS'; \
        echo 'failovermethod=priority'; \
        echo 'enabled=0'; \
        echo 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7'; \
        echo 'gpgcheck=0'; \
    } | tee aliyun.repo \
    && yum -y update && yum install -y gcc make autoconf dpkg-dev file re2c glibc-headers gcc-c++ \
       libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libedit libedit-devel\
       libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 \
       bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel \
       krb5-libs krb5-devel libidn libidn-devel openssl openssl-devel openldap \
       openldap-devel pcre pcre-devel bison automake ncurses ncurses-devel gmp-devel\
       icu libicu libicu-devel libtool-ltdl libtool-ltdl-devel wget ca-certificates \
       libmcrypt libmcrypt-devel \
    && rm -fr /var/cache/yum

# php 的安装
ENV PHP_VERSION="7.1.13"
ENV PHP_URL="http://cn2.php.net/distributions/php-7.1.13.tar.bz2"
RUN set -xe \
    && mkdir -p /home/src \
	&& cd /home/src \
	&& wget -O php.tar.bz2 "$PHP_URL" \
    && tar -xvf php.tar.bz2 \
    && cd php-"$PHP_VERSION" && ./configure --prefix=/usr/local/php \
    --enable-opcache --enable-fpm --with-mysqli=mysqlnd --enable-mysqlnd --with-libedit\
    --with-pdo-mysql=mysqlnd --with-gd --with-freetype-dir --with-jpeg-dir \
    --with-gettext --enable-bcmath --with-png-dir --with-zlib --with-libxml-dir \
    --enable-xml --with-curl --enable-mbregex --enable-mbstring --with-mcrypt --with-openssl \
    --with-mhash --with-xmlrpc --enable-zip --enable-soap --enable-sockets --enable-ftp \
    --enable-simplexml --enable-json --enable-exif --enable-dom --enable-intl --enable-pcntl \
    --with-gmp --with-pear --enable-redis-igbinary=yes \
    && make && make install

# 安装imagemagick
ENV IMG_MAG_VERSION="6.9.9-33"
ENV IMG_MAG_URL="ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.9.9-33.tar.gz"
ENV LIB_MEM_VERSION="1.0.18"
ENV LIB_MEM_URL="https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz"
RUN set -xe \
    && cd /home/src \
    && wget -O ImageMagick.tar.gz "${IMG_MAG_URL}"\
    && tar -zxvf ImageMagick.tar.gz \
    && cd ImageMagick-"$IMG_MAG_VERSION" && ./configure && make && make install \
    && wget -O libmemcached.tar.gz "${LIB_MEM_URL}" \
    && tar -zxvf libmemcached.tar.gz \
    && cd libmemcached-"$LIB_MEM_VERSION" && ./configure && make && make install

# 安装PHP库
RUN set -xe \
    && /usr/local/php/bin/pecl install mongodb \
    && /usr/local/php/bin/pecl install redis \    
    && /usr/local/php/bin/pecl install igbinary \
    && /usr/local/php/bin/pecl install msgpack \
    && /usr/local/php/bin/pecl install imagick \
    && /usr/local/php/bin/pecl install memcached \
    && /usr/local/php/bin/pecl install grpc \
    && /usr/local/php/bin/pecl install protobuf \
    && { \
        echo 'date.timezone=PRC'; \
        echo 'extension=mongodb.so'; \
        echo 'extension=redis.so'; \
        echo 'extension=igbinary.so'; \
        echo 'extension=msgpack.so'; \
        echo 'extension=imagick.so'; \
        echo 'extension=memcached.so'; \
        echo 'extension=grpc.so'; \        
        echo ';extension=protobuf.so'; \
        echo ';extension=opcache.so'; \
    } | tee /usr/local/php/lib/php.ini

# nginx的安装
ENV NGINX_VERSION="1.12.0"
ENV NGINX_URL="http://nginx.org/download/nginx-1.12.0.tar.gz"
RUN set -xe; \
    mkdir -p /home/src; \
	cd /home/src; \
	wget -O nginx.tar.gz "$NGINX_URL"; \
    tar -zxvf nginx.tar.gz; \
    cd nginx-"$NGINX_VERSION" && ./configure --with-stream && make && make install

# golang的安装
ENV GO_VERSION="1.9.2"
ENV GO_URL="https://dl.google.com/go/go1.9.2.linux-amd64.tar.gz"
RUN set -xe \
	&& cd /home/src \
	&& wget -O go.tar.gz "$GO_URL" \
    && tar -zxvf go.tar.gz -C /usr/local/ \
    && { \
       echo '#!/bin/bash'; \
       echo ''; \
       echo '# GoPATH'; \
       echo 'export GOPATH=/workspace/gopath'; \
       echo 'PATH=$PATH:$HOME/bin:/usr/local/php/bin/:/usr/local/go/bin:$GOPATH/bin'; \
       echo ''; \
       echo 'export PATH'; \
       echo '# alias'; \
       echo "alias l='ls -artl'"; \
       echo ''; \
   } | tee /etc/profile.d/gopath.sh

# node的安装
ENV NODE_VERSION="8.9.4"
ENV NODE_URL="https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz"
RUN set -xe; \
	cd /home; \
	wget -O node.tar.xz "$NODE_URL"; \
    tar -Jxvf node.tar.xz; \
    cp node-v"${NODE_VERSION}"-linux-x64/bin/node /usr/local/bin/node; \
    ln -s /home/node-v"${NODE_VERSION}"-linux-x64/bin/npm /usr/bin/;

# node相关库
RUN set -xe; \
    npm install pm2 -g; \
    npm install -g bower && { echo '{"allow_root":true}'; } | tee /root/.bowerrc; \
    curl -o- -L https://yarnpkg.com/install.sh | bash;

# bash语言环境的配置
# 清理安装文件
RUN set -xe \
    && { \
        echo "LANG=en_US.UTF-8"; \
        echo "LC_ALL=en_US.UTF-8"; \
    } | tee /etc/environment \
    && source /etc/environment \
    && localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && { \
        echo '#!/bin/bash'; \
        echo '/usr/local/nginx/sbin/nginx'; \
        echo '/usr/local/php/sbin/php-fpm'; \
    } | tee /home/start_service.sh \
    && chmod +x /home/start_service.sh \
    && rm -fr /home/src

EXPOSE 80
STOPSIGNAL SIGTERM
#CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
#CMD ["/usr/local/php/sbin/php-fpm"]
CMD ["/home/start_service.sh"]