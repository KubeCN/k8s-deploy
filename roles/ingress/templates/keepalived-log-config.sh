#!/usr/bin/env bash


# keepalived
sed -i '/KEEPALIVED_OPTIONS/ s/^/# /' /etc/sysconfig/keepalived

cat >> /etc/sysconfig/keepalived <<EOF
KEEPALIVED_OPTIONS="--dump-conf --log-detail --log-facility=6"
EOF

systemctl restart keepalived


# rsyslog
cat > /etc/rsyslog.d/keepalived.conf <<EOF
local6.*    /var/log/keepalived/keepalived.log
EOF

systemctl restart rsyslog
