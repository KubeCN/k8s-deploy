Table of Contents
=================

* [Introduction](#introduction)
* [Installation](#installation)
    * [0. Regenerate CA certs (Optional)](#0-regenerate-ca-certs-optional)
    * [1. Check connectivity](#1-check-connectivity)
    * [2. Init host](#2-init-host)
    * [3. Install docker (Required)](#3-install-docker-required)
    * [4. Deploy etcd (Required)](#4-deploy-etcd-required)
    * [5. Deploy VIP &amp; load balancer for kube-apiserver (Optional if all-in-one)](#5-deploy-vip--load-balancer-for-kube-apiserver-optional-if-all-in-one)
    * [6. Install Kubernetes basic components (Required)](#6-install-kubernetes-basic-components-required)
    * [7. Install calico &amp; kubedns (Required)](#7-install-calico--kubedns-required)
    * [8. Install other addons (Optional)](#8-install-other-addons-optional)
    * [9. Install ingress (Optional)](#9-install-ingress-optional)

# Introduction

This repo is used to deploy product-grade high availability Kubernetes cluster, as well as all-in-one cluster.

kube-deploy has experienced long time validation in our internal clusters, to help more people
to deploy their Kubernetes, we decide to make it open source.

So, please have a try! if have any issue, please let us know.

# Installation

At the begining, we should install Ansible(ver2.0+) in our deploy workstation.
Then follow us to deploy the Kubernetes cluster.

## 0. Regenerate CA certs (Optional)

Note here, if you want to create your CA certs to instead of the default one in this repo, please regenerate it as following steps.

```bash
$ cd roles/common/files/pki

# notice: need install cfssl
# https://kubernetes.io/docs/concepts/cluster-administration/certificates/#cfssl
$ /usr/bin/bash generate-ca.sh
```

## 1. Check connectivity

Please check your deploy workstation would ssh to the remote Host, maybe need `--sudo`

```bash
$ ansible --inventory='hosts/kube.ini' nodes -m ping
```

## 2. Init host

- 1. Upgrade kernel to elrepo-lt (Recommend)

    ```bash
    # centos
    # upgrade kernel to elrepo-lt for docker cgroup driver systemd
    ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='nodes' --tags='upgrade-kernel'
    ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='nodes' --tags='reboot'
    # upgrade system package
    ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='nodes' --tags='upgrade-pkg'

    # ubuntu
    # ubuntu does not need to upgrade kernel
    ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='nodes' --tags='upgrade-pkg'
    ```

- 2. Install dependency tools and requirements

    ```bash
    # install some commonly used software packages, etc.
    ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='nodes' --tags='dep'
    ```

## 3. Install docker (Required)

```bash
ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='nodes' --tags='docker'
```

## 4. Deploy etcd (Required)

```bash
# deploy etcd with docker
ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='etcds' --tags='etcd'
```

## 5. Deploy VIP & load balancer for kube-apiserver (Optional if all-in-one)

**NOTE:** PLEASE IGNORE THIS STEP, IF YOU WANT TO DEPLOY AN ALL-IN-ONE KUBERNETES CLUSTER.

```bash
# use keepalived to provide kube-apiserver vip and use haproxy to provide kube-apiserver load balancer
ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='vips' --tags='vip'
```

## 6. Install Kubernetes basic components (Required)

```bash
# up kubernetes master node and worker node
ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='nodes' --tags='kube'
```

## 7. Install calico & kubedns (Required)

```bash
# deploy calico
ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='masters' --tags='calico'

# deploy kube-dns
ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='masters' --tags='dns'
```

## 8. Install other addons (Optional)

```bash
# deploy metric-server for HPA
ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='masters' --tags='metric-server'
```

## 9. Install ingress (Optional)

```bash
# no need to execute on single master node architecture
ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='ingress_nginxs_l7' --tags='ingress'

# no need to execute on single master node architecture
ansible-playbook kube.yaml --inventory='hosts/kube.ini' --limit='ingress_nginxs_l4' --tags='ingress'
```