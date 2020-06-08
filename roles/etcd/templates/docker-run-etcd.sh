#!/usr/bin/env bash

docker stop etcd 2> /dev/null | true
docker rm --force etcd 2> /dev/null | true

docker run -d \
    --name='etcd' --name='etcd' \
    --network='host' \
    --restart='always' \
    --volume='/data/etcd:/data/etcd' --volume='/etc/localtime:/etc/localtime' \
    quay.io/coreos/etcd:v{{ etcd_version }} /usr/local/bin/etcd \
    -name {{ ansible_default_ipv4.address }} \
    -advertise-client-urls http://{{ ansible_default_ipv4.address }}:2379,http://{{ ansible_default_ipv4.address }}:4001 \
    -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
    -initial-advertise-peer-urls http://{{ ansible_default_ipv4.address }}:2380 \
    -listen-peer-urls http://0.0.0.0:2380 \
    -initial-cluster {% for item in groups['etcds'] %}{{ item }}=http://{{ item }}:2380{% if not loop.last %},{% endif %}{% endfor %} \
    -initial-cluster-state new \
    -data-dir /data/etcd \
