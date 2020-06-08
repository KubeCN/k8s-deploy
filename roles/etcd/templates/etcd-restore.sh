#!/usr/bin/env bash

# notice: exec this in /data/etcd/ directory
# notice: exec this in /data/etcd/ directory
# notice: exec this in /data/etcd/ directory

# restore
[ -d {{ ansible_default_ipv4.address }}.etcd ] && rm -rf {{ ansible_default_ipv4.address }}.etcd

# TODO: the restore snapshot should be download from s3 manully at first.
# then substitue blow db, and run the script.
ETCDCTL_API=3 etcdctl snapshot restore please-use-a-same-snapshot-which-would-be-downloaded-from-s3.db \
  --name {{ ansible_default_ipv4.address }}  \
  --initial-cluster {% for item in groups['etcds'] %}{{ item }}=http://{{ item }}:2380{% if not loop.last %},{% endif %}{% endfor %} \
  --initial-advertise-peer-urls http://{{ ansible_default_ipv4.address }}:2380

# mv etcd data
mv /data/etcd/member /data/etcd/member-$(date +%Y%m%d%H%M%S) && \
mv /data/etcd/{{ ansible_default_ipv4.address }}.etcd/member /data/etcd/

# restart etcd
docker restart etcd

# check healthy
sleep 5
etcdctl cluster-health

#
rm -rf {{ ansible_default_ipv4.address }}.etcd
