# Setup xrdp
This file contains instructions on how to setup xrdp so you can RDP into your remote Kali-pi.

## Install Dependencies
```
apt-get update
apt-get install xrdp tigervnc-standalone-server -y
```

## Edit  xrdp.ini
`nano /etc/xrdp/xrdp.ini`

Change:

```
  autorun=sesman-any
  max_bpp=16
```

Scroll down to `[sesman-any]` and change
`  ip=127.0.0.1`

Save and exit

## Start Services
```
service xrdp start
service xrdp-sesman start
```

## Start at Boot
```
update-rc.d xrdp enable
systemctl enable xrdp-sesman.service
```

## Logging in
When you log in you will be greated with a login screen:

***Change the Session type to `sesman-any`***

Login using your credentials - Likely as root on a Kali machine...

**Be sure to logout instead of just clicking the `X`.**

Logging out shuts down the VNC server that is feeding the RDP session. Failing to do that can cause login errors later on.
