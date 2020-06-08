#!/usr/bin/env bash

cd `dirname $0`
HN=$(hostname)

openssl genrsa -out kubelet-client.key 2048
openssl req -new -key kubelet-client.key -subj "/O=system:masters/CN=kube-administrator" -out kubelet-client.csr
openssl x509 -req -in kubelet-client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kubelet-client.crt -days 3650
