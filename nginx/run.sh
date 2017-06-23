#!/usr/bin/env bash
WorkSpace="/Users/hebin/workspace"

docker run -p 80: --name nginx \
           -v $PWD/conf/nginx.conf:/usr/local/nginx/conf/nginx.conf \
           -v $PWD/conf/server:/usr/local/nginx/conf/server \
           -v $PWD/logs:/usr/local/nginx/logs \
           -v $WorkSpace:/workspace \
           -d c7.3:nginx

docker ps
