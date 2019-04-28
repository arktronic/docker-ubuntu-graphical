# docker-ubuntu-graphical
Ubuntu-based container with Firefox, SSH server, and RDP support

This container uses a minimal GUI environment based on LXDE on top of Ubuntu, with some niceties thrown in. `supervisord` is used as PID 1 to control startup processes and reap the dead ones. A syslog daemon logs everything to Docker's logs. Cron is installed as well.

To access remotely, either SSH or RDP into the container. The username and password, by default, are both `admin`.
