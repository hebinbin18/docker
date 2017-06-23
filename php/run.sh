#!/usr/bin/env bash
WorkSpace="/Users/hebin/workspace"

docker run --name php \
           -v $PWD/conf:/usr/local/php/etc \
           -v $PWD/logs:/usr/local/php/logs \
           -v $WorkSpace:/workspace \
           -d c7.3:php
docker ps
