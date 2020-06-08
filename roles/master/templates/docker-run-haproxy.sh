#!/usr/bin/env bash

docker stop haproxy 2> /dev/null | true
docker rm --force haproxy 2> /dev/null | true

docker run -d \
    --name='haproxy' \
    --pid='host' --network='host' \
    --restart='always' \
    --volume='/etc/haproxy:/usr/local/etc/haproxy:rw' \
    --privileged \
    docker.io/haproxy:{{ haproxy_version }}
