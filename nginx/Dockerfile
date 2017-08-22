#!/usr/bin/env bash
#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# docker build -t c7.3:nginx -f ./nginx/Dockerfile .

FROM centos:7.3.1611

# 开发环境基本依赖库的升级与安装
RUN set -ex \
	&& yum install -y gcc gcc-c++ make wget pcre-devel openssl-devel\
    && rm -fr /var/cache/yum

# bash语言环境的配置
RUN { \
        echo "LANG=en_US.UTF-8 LC_ALL="; \
    } | tee /etc/environment \
    && source /etc/environment \
    && localedef -i en_US -f UTF-8 en_US.UTF-8

# nginx的安装
ENV NGINX_VERSION="1.12.0"
ENV NGINX_URL="http://nginx.org/download/nginx-1.12.0.tar.gz"

RUN set -xe; \
    mkdir -p /home/src; \
	cd /home/src; \
	wget -O nginx.tar.gz "$NGINX_URL"; \
    tar -zxvf nginx.tar.gz; \
    cd nginx-"$NGINX_VERSION" && ./configure --add-module=nginx_tcp_proxy_module && make && make install

# 清理安装文件
RUN set -xe && rm -fr /home/src

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]