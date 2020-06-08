#!/usr/bin/env bash

# for kubectl
export KUBERNETES_MASTER='{{ kube_apiserver_vip }}:{{ kube_apiserver_vip_port }}'
export KUBECONFIG='/etc/kubernetes/kubeconfig'

# for calicoctl
export ETCD_ENDPOINTS=
    {%- for item in groups['etcds'] -%}
    http://{{item}}:2379{% if not loop.last %},{% endif %}
    {%- endfor %}
