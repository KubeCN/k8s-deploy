#!/usr/bin/env bash

sudo netstat -anp | grep -v 6443 | grep 0.0.0.0:{{ kube_apiserver_vip_port }} | grep LISTEN > /dev/null 2>&1
