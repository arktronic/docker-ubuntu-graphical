# docker-ubuntu-graphical

### Ubuntu-based container with Firefox, SSH server, and RDP support

This container gives you a minimal GUI environment based on LXDE on top of Ubuntu, with some niceties thrown in. `supervisord` is used to control startup processes. A syslog daemon logs everything to Docker's logs. Cron is installed as well.

NOTE: You must use `--init` in order to have a stable running container. Otherwise, dead processes will not be reaped and you will eventually run out of resources.

To access remotely, either SSH or RDP into the container. **The username and password, by default, are both `admin`.**

Get started:

```
docker run -d -p 3389:3389 --init --shm-size=2g arktronic/ubuntu-graphical
```

### Versions

#### 1.0

Original release, based on Ubuntu 18.04. **CAUTION: uses a hard-coded RDP certificate!**

#### 2.0

- Based on Ubuntu 20.04
- Includes support for audio over RDP (somewhat buggy; help is appreciated)
- Generates new SSH host key and RDP certificate on first run
