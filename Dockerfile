FROM ubuntu:18.04

ENV TERM xterm
ENV DEBIAN_FRONTEND="teletype" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

COPY ./install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

RUN useradd -m -g users -G sudo -p $(openssl passwd -1 admin) -s /bin/bash admin

COPY ./clean-launch.sh /usr/bin/clean-launch.sh
RUN chmod +x /usr/bin/clean-launch.sh

COPY ./supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 22/tcp
EXPOSE 3389/tcp

CMD ["/usr/bin/clean-launch.sh"]
