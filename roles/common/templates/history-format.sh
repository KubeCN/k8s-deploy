#!/usr/bin/env bash

# set -x
# set -ex

cat >> /etc/profile <<EOF


# history 命令条数
export HISTSIZE=5000

# history 命令文件大小
export HISTFILESIZE=5000

# 来源 ip
USER_SOURECE_IP=\$(who -u am i 2>/dev/null | awk '{print \$NF}' | sed -e 's/[()]//g')
if [[ \${USER_SOURECE_IP} == "" ]]
then
    USER_SOURECE_IP=\$(hostname)
fi

# 设置 history 格式
export HISTTIMEFORMAT="%Y-%m-%d-%H%M%S \${USER_SOURECE_IP} \$(whoami)    "
EOF

source /etc/profile
