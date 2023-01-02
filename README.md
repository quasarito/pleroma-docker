# Deploy Pleroma with Docker Compose
Deploy a personal self-hosted Pleroma instance that participates in the
fediverse but does not allow new users to register.

Adapted from https://git.pleroma.social/pleroma/pleroma-docker-compose.

## Quick start in 5 steps
### Step 1: Clone
```
$ git clone https://github.com/quasarito/pleroma-compose.git
```

### Step 2: Configure
Modify the following environment settings in `pleroma-compose.yml` file:
```
services:
  pleroma:
    environment:
  ...
      DB_PASS: '##REPLACE-ME##'
  ...
      INSTANCE_NAME: My Pleroma
      ADMIN_EMAIL: pleroma+admin@example.com
      NOTIFY_EMAIL: pleroma+admin@example.com
      DOMAIN: social.example.com
  ...
  pleroma-db:
    environment:
      POSTGRES_PASSWORD: '##REPLACE-ME##'
  ...
```
Note:
- `INSTANCE_NAME` is the site name that appears in the upper-right corner.
- `DOMAIN` is the fully-qualified domain name of the server.
- `DB_PASS` & `POSTGRES_PASSWORD` must be the same value, obviously.

### Step 3: Customize
- Copy the image you want to use for your site background to
`static/static/background.jpg`. If you use a different filename, then you
will need to edit the `background` property in the `config.exs` file.
- Copy the image you want to use for the logo that appears at the centre top
of the site to `static/static/logo.png`. If you use a different filename,
then you will need to edit the `logo` property in the `config.exs` file.
- Copy the image you want to use for the browser tab icon to
`static/favicon.png`. The filename cannot be changed.

### Step 4: Deploy
```
$ docker compose -f pleroma-compose.yml up -d
```

### Step 5: Create admin user
```
$ docker compose -f pleroma-compose.yml exec pleroma sh

# You are now in the pleroma container shell
$$ /opt/pleroma/bin/pleroma_ctl user new userid someone@example.com --admin
```
Note:
- `userid` must not be prefixed with '`@`'.
- Repeat the command without the parameter `--admin` to create a normal user
account.

When the command finishes, a URL will be output to set the user's account
password. Copy-paste the URL into a browser and set a secure password.
You can login with the newly created account.

## Other info
- The Postgres database is not accessible from the host computer. Uncomment
the `ports` section under the `pleroma-db` service of the
`pleroma-compose.yml` file to be able to connect to the database from the
host.
- The Pleroma docker image with tag `stable` is used for deployment. It can
be changed to `latest` if you want the cutting edge version. Update the
`image` property for the `pleroma` service of the `pleroma-compose.yml`
file.

### Reverse proxy with nginx
See [README-nginx.md](README-nginx.md)
