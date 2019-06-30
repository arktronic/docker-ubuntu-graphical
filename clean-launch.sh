#!/bin/bash

rm -rf /var/run/sudo/* /tmp/* /var/tmp/*
rm -f /run/* 2>/dev/null

if [ ! -d "/etc/dropbear" ]; then
  mkdir /etc/dropbear
  /usr/bin/dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
fi

if [ ! -f "/etc/xrdp/rsakeys.ini" ]; then
  /usr/bin/xrdp-keygen xrdp auto 2048
fi

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
