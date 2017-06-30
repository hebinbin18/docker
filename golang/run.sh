#!/usr/bin/env bash
WorkSpace="/Users/hebin/workspace"

docker run --name php-dev \
           -v $PWD/nginx/conf/nginx.conf:/usr/local/nginx/conf/nginx.conf \
           -v $PWD/nginx/conf/server:/usr/local/nginx/conf/server \
           -v $PWD/nginx/logs:/usr/local/nginx/logs \
           -v $PWD/php/conf:/usr/local/php/etc \
           -v $PWD/php/logs:/usr/local/php/logs \
           -v $WorkSpace:/workspace \
           -d c7.3:dev

#docker exec -it -v $WorkSpace:/workspace nginx bash
#docker rm -f nginx
#docker rm -f php-fpm

#docker run -p 9000:9000 --name php \
#           -v $WorkSpace:/workspace \
#           -d php:7.1.5-fpm
#
#docker run -p 80:80 --name nginx --link php:php-fpm \
#           -v $PWD/nginx/nginx.conf:/etc/nginx/nginx.conf \
#           -v $PWD/nginx/server:/etc/nginx/server \
#           -v $PWD/nginx/logs:/etc/nginx/logs \
#           -v $WorkSpace:/workspace \
#           -d nginx

#docker start nginx
#docker start php-fpm
docker ps

#sleep 2
#docker ps
#sleep 2
#docker ps