FROM ubuntu:20.04 AS xrdp-pulse-builder
WORKDIR /root
ENV DEBIAN_FRONTEND="noninteractive"
RUN sed -i '/^#\sdeb-src /s/^#//' "/etc/apt/sources.list"
RUN apt update \
 && apt install -y --no-install-recommends build-essential dpkg-dev libpulse-dev git pulseaudio
RUN apt build-dep -y pulseaudio \
 && apt source pulseaudio
RUN cd pulseaudio-* \
 && ./configure
RUN git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git xrdp-module \
 && cd xrdp-module \
 && ./bootstrap \
 && ./configure PULSE_DIR=$(cd /root/pulseaudio-* && pwd) \
 && make \
 && make install \
 && cp $(pkg-config --variable=modlibexecdir libpulse)/module-xrdp-* /root/

# ---------------

FROM ubuntu:20.04

ENV TERM xterm
ENV DEBIAN_FRONTEND="teletype" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

# this file disables manpages, so remove it:
RUN rm /etc/dpkg/dpkg.cfg.d/excludes

RUN DEBIAN_FRONTEND=noninteractive apt update \
 && apt install -y --no-install-recommends apt-utils locales \
 && locale-gen en_US.UTF-8 \
 && apt install -y --no-install-recommends man-db manpages
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends lxde-core lxde-icon-theme firefox lxterminal
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends supervisor apt-utils dialog apt-transport-https ca-certificates software-properties-common language-pack-en busybox-syslogd sudo dropbear-bin cron logrotate less nano
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends xrdp xorgxrdp pulseaudio pavumeter dbus-x11
RUN apt-get autoclean && apt-get autoremove

RUN update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

# this file should be generated in a container instance, not the image:
RUN rm /etc/xrdp/rsakeys.ini

RUN useradd -m -g users -G sudo -p $(openssl passwd -1 admin) -s /bin/bash admin

COPY --from=xrdp-pulse-builder /root/module-xrdp-sink.so /var/lib/xrdp-pulseaudio-installer/
COPY --from=xrdp-pulse-builder /root/module-xrdp-source.so /var/lib/xrdp-pulseaudio-installer/

COPY ./clean-launch.sh /usr/bin/clean-launch.sh
RUN chmod +x /usr/bin/clean-launch.sh

COPY ./supervisord.conf /etc/supervisor/supervisord.conf

RUN mkdir -p /var/run/dbus \
 && echo "autospawn = no" >> /etc/pulse/client.conf \
 && echo "[Desktop Entry]\nType=Application\nExec=pulseaudio --daemonize" > /etc/xdg/autostart/pulseaudio-xrdp.desktop \
 && mv /usr/bin/lxpolkit /usr/bin/lxpolkit.disabled

EXPOSE 22/tcp
EXPOSE 3389/tcp

CMD ["/usr/bin/clean-launch.sh"]
