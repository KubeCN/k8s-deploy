#!/usr/bin/env bash

docker rm -f haproxy | true > /dev/null 2>&1

docker run -d \
    --publish={{ ingress_vip }}:{{ ingress_vip_port_s }}:{{ ingress_vip_port_s }} \
    --name=haproxy \
    --pid=host --net=host \
    --restart=always \
    --volume=/etc/haproxy:/usr/local/etc/haproxy:rw \
    --privileged \
    haproxy:{{ haproxy_version }}  >> /var/log/haproxy.log 2>&1
