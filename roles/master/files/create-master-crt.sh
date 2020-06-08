#!/usr/bin/env bash

cd `dirname $0`
HN=$(hostname)

echo "generate apiserver key & cert"
cp ca.key apiserver.key
openssl req -new -key apiserver.key -subj "/CN=kube-administrator" -config pki-master.cnf -out apiserver.csr
openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -extensions v3_req -extfile pki-master.cnf -out apiserver.crt

# create apiserver.pem to set haproxy work with https
cat apiserver.crt apiserver.key | tee apiserver.pem
