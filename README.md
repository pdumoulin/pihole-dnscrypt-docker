# pihole-dnscrypt-docker

### Host Setup

Configuring for Ubuntu Server 26.04

1. Create a override configuration drop-in file to instruct systemd-resolved to stop listening on port 53.

```bash
sudo mkdir -p /etc/systemd/resolved.conf.d
echo -e "[Resolve]\nDNSStubListener=no" | sudo tee /etc/systemd/resolved.conf.d/disable-stub.conf
```

2. The default symbolic link (/etc/resolv.conf) points to a local loopback IP address (127.0.0.53) that you just turned off, you must re-link it directly to the real runtime file

```bash
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

3. Apply the configuration immediately by restarting the daemon

```bash
sudo systemctl restart systemd-resolved
```

4. Verify port 53 is free

```bash
sudo ss -luntp | grep ':53 '
```

### Application Startup

1. Setup admin console password

```bash
echo FTLCONF_webserver_api_password='your_secure_password_here' > .env.secret
```

2. Start services

```bash
docker compose up -d pihole
```

### Verification

1. run healthcheck script

```bash
./health.sh
```

2. dns queries resolve from another host on same network

```bash
dig @192.168.50.17 google.com
```

3. [admin portal](http://192.168.50.17:8080/admin/login) loads and can login
