# Configure nginx reverse proxy for Pleroma

Setup a reverse proxy with nginx to Pleroma, and configure SSL with
[Let's Encrypt](https://letsencrypt.org/).

Adapted from [Pleroma documentation](https://docs.pleroma.social/backend/installation/otp_en/#copy-pleroma-nginx-configuration-to-the-nginx-folder).

### Pre-requisites
- Installed and running nginx instance.
- A registered domain name pointing to a publically addressable host.

These instructions are based on an Ubuntu 22.04 installation, but should
work on any Debian-based Linux distribution.

## Setup SSL certificate with Let's Encrypt

First, lets create an SSL certificate for the domain on the host where 
Pleroma will be accessible.

Add temporary nginx configuration to be able obtain an SSL certificate by 
creating a file at `/etc/nginx/sites-available/pleroma.conf` with the 
following content:
```
server {
  listen 80;
  listen [::]:80;

  server_name example.com;

  root /var/www/html;
  index index.html;
  location / {
    try_files $uri $uri/ =404;
  }
}
```

Enable the configuration by creating a symlink in `/etc/nginx/sites-enabled`:
```
$ cd /etc/nginx/sites-enabled
$ sudo ln -s /etc/nginx/sites-available/pleroma.conf
```

Install `certbot` and obtain certificate from [instructions for your operating system](https://certbot.eff.org/).

After completing those instruction, you should have an `https` accessible
site at your domain.

## Setup reverse proxy in nginx

Download and copy the contents of the [Pleroma nginx configuration file](https://git.pleroma.social/pleroma/pleroma/-/raw/develop/installation/pleroma.nginx)
to `/etc/nginx/sites-available/pleroma.conf` (overwriting the same file
created previously).

Edit the file, replacing all occurrences of `example.tld` with your domain.
```
server {
    server_name    example.tld;
    ...
    ssl_trusted_certificate   /etc/letsencrypt/live/example.tld/chain.pem;
    ssl_certificate           /etc/letsencrypt/live/example.tld/fullchain.pem;
    ssl_certificate_key       /etc/letsencrypt/live/example.tld/privkey.pem;
}
```
Note:
- There are 2 occurrences of `server_name example.tld;` that need to be
replaced.
- Make sure the `certbot`-created certificate files are located at the
locations given for your domain.

Restart nginx
```
$ sudo systemctl restart nginx
```