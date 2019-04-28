FROM ubuntu:18.04

ENV TERM xterm
ENV DEBIAN_FRONTEND="teletype" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

RUN echo "#!/bin/bash\n set -e \n export LC_ALL=C \n export DEBIAN_FRONTEND=noninteractive \n apt-get update" >> /tmp/install.sh
RUN echo "rm /etc/dpkg/dpkg.cfg.d/excludes # this file disables manpages" >> /tmp/install.sh
RUN echo "apt-get install -y --no-install-recommends man-db manpages" >> /tmp/install.sh
RUN echo "apt-get install -y --no-install-recommends supervisor apt-utils dialog apt-transport-https ca-certificates software-properties-common language-pack-en busybox-syslogd sudo dropbear-bin cron logrotate lxde-core lxde-icon-theme xrdp xorgxrdp firefox lxterminal tzdata less nano" >> /tmp/install.sh
RUN echo "apt-get autoclean \n apt-get autoremove" >> /tmp/install.sh
RUN echo "update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8" >> /tmp/install.sh
RUN echo "mkdir /etc/dropbear && dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key" >> /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

RUN useradd -m -g users -G sudo -p $(openssl passwd -1 admin) -s /bin/bash admin

RUN echo "#!/bin/bash\nrm -rf /var/run/sudo/* /tmp/* /var/tmp/*\nrm -f /run/* 2>/dev/null\nexit 0" > /etc/init.d/dockerized-image-cleanup.sh
RUN chmod +x /etc/init.d/dockerized-image-cleanup.sh

RUN echo "[supervisord]\nnodaemon=true\nuser=root\n" > /etc/supervisor/supervisord.conf
RUN echo "[program:cleanup]\ncommand=/etc/init.d/dockerized-image-cleanup.sh\npriority=1\nstartsecs=0\nstdout_logfile=NONE\nstderr_logfile=NONE" >> /etc/supervisor/supervisord.conf
RUN echo "[program:cron]\ncommand=/usr/sbin/cron -f\nautorestart=true\nstartsecs=5\nstdout_logfile=NONE\nstderr_logfile=NONE" >> /etc/supervisor/supervisord.conf
RUN echo "[program:syslogd]\ncommand=/sbin/syslogd -n -O -\nautorestart=true\nstartsecs=5\nstdout_logfile=/dev/stdout\nstdout_logfile_maxbytes=0\nstderr_logfile=NONE" >> /etc/supervisor/supervisord.conf
RUN echo "[program:dropbear]\ncommand=/usr/sbin/dropbear -F\nautorestart=true\nstartsecs=5\nstdout_logfile=NONE\nstderr_logfile=NONE" >> /etc/supervisor/supervisord.conf
RUN echo "[program:xrdp]\ncommand=/usr/sbin/xrdp -n\nautorestart=true\nstartsecs=5\nstdout_logfile=NONE\nstderr_logfile=NONE" >> /etc/supervisor/supervisord.conf
RUN echo "[program:xrdp-sesman]\ncommand=/usr/sbin/xrdp-sesman -n\nautorestart=true\nstartsecs=5\nstdout_logfile=NONE\nstderr_logfile=NONE" >> /etc/supervisor/supervisord.conf

EXPOSE 22/tcp
EXPOSE 3389/tcp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
