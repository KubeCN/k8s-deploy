#!/usr/bin/env bash

cat >> /root/.bashrc <<EOF

# kuberctl
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
EOF
