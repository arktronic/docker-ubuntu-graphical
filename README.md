# docker-ubuntu-graphical

### Ubuntu-based container with Firefox, SSH server, and RDP support

This container uses a minimal GUI environment based on LXDE on top of Ubuntu, with some niceties thrown in. `supervisord` is used to control startup processes. A syslog daemon logs everything to Docker's logs. Cron is installed as well.

NOTE: You must use `--init` in order to have a stable running container. Otherwise, dead processes will not be reaped and you will eventually run out of resources.

To access remotely, either SSH or RDP into the container. **The username and password, by default, are both `admin`.**

Get started:

```
docker run -d -p 3389:3389 --init --shm-size=2g arktronic/ubuntu-graphical
```
