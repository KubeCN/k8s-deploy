#!/usr/bin/env bash

# crontab定期执行备份脚本，每6小时备份一次，（本地备份保留最近28个备份）

ENDPOINTS=
    {%- for item in groups['etcds'] -%}
    http://{{item}}:2379{% if not loop.last %},{% endif %}
    {%- endfor %}

BACKUP_DIR='/data/etcd-backups'
DATE=`date +%Y%m%d-%H%M%S`

[ ! -d $BACKUP_DIR ] && mkdir -p $BACKUP_DIR
export ETCDCTL_API=3;etcdctl --endpoints=$ENDPOINTS snapshot save $BACKUP_DIR/snapshot-$DATE\.db
cd $BACKUP_DIR;ls -lt $BACKUP_DIR|awk '{if(NR>28){print "rm -rf "$9}}'|sh
