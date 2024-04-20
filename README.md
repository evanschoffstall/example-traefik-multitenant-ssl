# Example: Cloud Native Traefik Serving Multi Tenant HTTPS

This repository offers a practical example of deploying multi-tenant services like pgAdmin and Traefik dashboards through SSL using Traefik. 

To the best of my knowledge, at the time of writing, there are no existing examples specifically addressing pgAdmin integration with Traefik over SSL, and only a limited number of examples exist that demonstrate the use of SSL with Traefik.

> :warning: **Security Warning:** Administrative dashboards are are not best to serve publicly over the open internet even with SSL and good passwords.

> What's better for security are secure tunnels like Cloudfare that securely access private network resources authenticated on a whitelisted and regulated client to client basis and even temporary ip whitelisting using port knocking as part of a larger comprehensive security strategy.

## Building the Example

### Requirements
```bash
bash
openssl
docker
docker-compose
```

### Build
You can build and run the project by running the provided script:

```bash
./build.example.sh
```

This will also already generate a `.crt` and `.key` for localhost that gets copied, pointed to and served by Traefik.

This example is for development purposes and not production, as there are several security considerations to address.

## Repurposing to Your Project

### :warning: Security: Use Secrets Management

<!-- TODO: Use Docker Swarm? -->

#### Challenge:

This docker-compose example uses environmental variables to inform key login information et al, often referred to as "secrets".

This example hardcodes secrets in a `.example.env` file for the purpose of demonstrative purposes only 

For security, use secrets management. Secrets should never be hard coded, nor in plain text `.env` files stored on your machine or host.

> :no_entry_sign: Further, the `.example.env` contains *example* secrets only, and should never ever be reused in your own development or production deployment.

The same for the `.crt` and `.key`, which should be secured using secrets management.


#### Solution:

For Docker, use docker secrets with good security and secret management practices.

SaaS pipelines can securely host, encrypt and inject environmental variables.


### SSL Certificate
For Traefik to serve over HTTPS, you need to generate or provide a certificate (`.crt`) and key (`.key`). 

You can also set up and use a certificate provider like Cloudflare.

<!-- TODO: This example does not use docker secrets to secure  -->

> :warning: **Security Warning:** `.crt` and `.key` should be kept secret using Docker secrets or otherwise.

After generating or providing these files securely, deploy them and update the `dynamic.yaml` file to point to their locations if changed.

<!-- TODO: This example does not yet contain automatic certification using Let's Encrypt -->


### Pgadmin ownership

> :warning: **Security Warning:** this is really only for development purposes. If you need to do backups it's best to access the fs securely and as needed.

If you decide to mount a pgAdmin directory to your host, like in the example, pgAdmin requires write access to it to run properly, hence the ownership change:

```bash
sudo chown -R 5050:5050 ./data/pgadmin
```

## Todo

- Perhaps an example that uses improved secret management than compared to using .env
- Perhaps an example for using Let's Encrypt
- Perhaps integrate fail2ban
