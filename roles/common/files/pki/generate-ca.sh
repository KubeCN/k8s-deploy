#!/usr/bin/env bash

# use cfssl to create ca certificate
# https://kubernetes.io/docs/concepts/cluster-administration/certificates/#cfssl

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

mv -fv ca-key.pem ca.key
mv -fv ca.pem ca.crt
