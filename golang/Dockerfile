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

ENV GO_VERSION="1.8.3"
ENV GO_URL="https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz"

RUN set -xe \
	&& cd /home/src \
	&& wget -O go.tar.gz "$GO_URL" \
    && tar -zxvf go.tar.gz -C /usr/local/ \
    && { \
       echo '# .bash_profile'; \
       echo ''; \
       echo '# Get the aliases and functions'; \
       echo 'if [ -f ~/.bashrc ]; then'; \
       echo '        . ~/.bashrc'; \
       echo 'fi'; \
       echo ''; \
       echo '# User specific environment and startup programs'; \
       echo ''; \
       echo 'export GOPATH=/workspace/gopath'; \
       echo 'PATH=$PATH:$HOME/bin:/usr/local/go/bin:$GOPATH/bin'; \
       echo ''; \
       echo 'export PATH'; \
   } | tee ~/.bash_profile

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
        echo 'source ~/.bash_profile'; \
    } | tee /home/start_service.sh \
    && chmod +x /home/start_service.sh \
    && rm -fr /home/src

CMD ["/home/start_service.sh"]