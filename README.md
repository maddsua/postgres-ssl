## WHY?

Because almost every time I needed postgres I also used it over a public network which demands securing your damn connections.

Until now I've used the railway/postgres-ssl image, which is okay. The annoying part with it is that it's tailored to run well-enough on railway, which I am not even using anymore.

A bigger issue, however, is that it has a tendency to get killed by podman every time you request to stop it, as they seem to have forgotten to handle signals in their wrapper script.

And I am not sure that you can fix their image without completely rewriting the thing. So yeah, here it is, my custom image. Enjoy!

**Some important notes**

Default PG_DATA location is `/var/lib/postgresql/data`. Don't forget to mount that to a persistent volume.

Generated SSL certificates live at `/var/lib/postgresql/ssl`. If your clients are picky in regargs to certificate consistency you'd need to make this a persistent volume as well.

Or just mount the whole fucking `/var/lib/postgresql` to kill both birds with one stone.

## Deploying

Grab current user and host name and use them as db-and-user names. Of course you can paste custom values here or edit the kube template itself.

```sh
export POSTGRES_USER_VAL=$(whoami)
export POSTGRES_DB_VAL=$(cat /etc/hostname)
```

Generate a new secure-ish password:

```sh
export POSTGRES_PASSWORD_VAL=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
```

### With podman

Paste secrets into the template and execute play kube command:

```sh
cat kube-spec.yml | envsubst '$POSTGRES_USER_VAL $POSTGRES_PASSWORD_VAL $POSTGRES_DB_VAL' | podman play kube --replace -
```

### With docker compose

Generate deploy-ready compose file:

```sh
cat docker-compose.yml | envsubst '$POSTGRES_USER_VAL $POSTGRES_PASSWORD_VAL $POSTGRES_DB_VAL' > /tmp/postgres-docker-compose.yml
```

Run compose file:

```sh
docker compose up -f /tmp/postgres-docker-compose.yml
```
