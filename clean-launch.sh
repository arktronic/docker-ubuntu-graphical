#!/bin/bash

rm -rf /var/run/sudo/* /tmp/* /var/tmp/*
rm -f /run/* 2>/dev/null

if [ ! -d "/etc/dropbear" ]; then
  mkdir /etc/dropbear
  /usr/bin/dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
fi

if [ ! -f "/etc/xrdp/rsakeys.ini" ]; then
  /usr/bin/xrdp-keygen xrdp auto 2048
  pushd /etc/xrdp &>/dev/null
  rm -f cert.pem key.pem
  openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=XX/ST=XX/L=XX/O=XX/CN=$(hostname)" -keyout key.pem -out cert.pem
fi

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
