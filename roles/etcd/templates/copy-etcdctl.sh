#!/usr/bin/env bash

docker stop copy-etcdctl
docker rm --force copy-etcdctl

docker run -d \
    --name='copy-etcdctl' --hostname='copy-etcdctl' \
    quay.io/coreos/etcd:v{{ etcd_version }}

docker cp copy-etcdctl:/usr/local/bin/etcdctl /usr/local/bin/etcdctl

docker stop copy-etcdctl
docker rm --force copy-etcdctl
