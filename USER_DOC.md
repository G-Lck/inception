# USER_DOC

This project runs a small web stack for WordPress.

## Services provided

The stack contains five services:

- `mariadb`: the persistent database used by WordPress.
- `wordpress`: the PHP application that serves the site.
- `nginx`: the HTTPS reverse proxy used to expose the site.
- `adminer`: the database administration interface.
- `static`: a small static website served separately from WordPress.

## Start and stop the project

Use the Makefile from the repository root:

- `make` or `make up` starts the project and builds the images if needed.
- `make build` builds the images without starting the containers.
- `make down` stops the containers.
- `make clean` stops the containers and removes the images.
- `make fclean` removes the containers, images, and volumes.
- `make re` fully cleans the project and starts it again.

## Access the website and admin panel

The WordPress site is available through HTTPS on the domain defined in `srcs/.env`:

- Main website: `https://glucken.42.ch`
- Adminer: `https://glucken.42.ch/adminer/`

The browser may warn about the certificate if it is self-signed. In that case, accept the warning to continue.

## Credentials and secrets

Credentials are stored in the `secrets/` directory at the root of the repository.

The project uses these files:

- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/wp_queen_password.txt`
- `secrets/wp_user_password.txt`

If you need to change a password, update the matching file and restart the stack.

## Check that everything is running

Useful checks:

- `docker ps` shows the running containers.
- `docker compose -f srcs/docker-compose.yml ps` shows the project services.
- `docker compose -f srcs/docker-compose.yml logs` shows service logs.
- `docker volume ls` shows the persistent volumes.

The project is healthy when all expected containers are up and the website opens correctly in a browser.
