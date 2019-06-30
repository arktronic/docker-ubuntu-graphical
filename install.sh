#!/bin/bash

set -e

export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive

# this file disables manpages, so remove it:
rm /etc/dpkg/dpkg.cfg.d/excludes

apt-get update
apt-get install -y --no-install-recommends man-db manpages
apt-get install -y --no-install-recommends supervisor apt-utils dialog apt-transport-https ca-certificates software-properties-common language-pack-en busybox-syslogd sudo dropbear-bin cron logrotate lxde-core lxde-icon-theme xrdp xorgxrdp firefox lxterminal tzdata less nano
apt-get autoclean
apt-get autoremove

update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

# this file should be generated in a container instance, not the image:
rm /etc/xrdp/rsakeys.ini
