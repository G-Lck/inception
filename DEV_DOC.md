# DEV_DOC

This document explains how to set up, run, and maintain the project from a developer point of view.

## Prerequisites

Install the following tools before working on the project:

- Docker
- Docker Compose v2
- `make`

The project is designed to run on Linux and uses Docker containers only.

## Initial setup

The configuration is mainly driven by `srcs/.env` and the secret files under `secrets/`.

Before starting the stack, make sure the secret files exist:

- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/wp_queen_password.txt`
- `secrets/wp_user_password.txt`

The Makefile creates the host data directories automatically when needed.

## Build and launch

Use the Makefile from the repository root:

- `make` or `make up` creates the data directories and starts the stack with `docker compose up -d --build`.
- `make build` builds the images only.
- `make down` stops the containers.
- `make clean` stops the containers and removes the images.
- `make fclean` removes the containers, images, and volumes.
- `make re` performs a full cleanup and starts everything again.

The project uses this Compose file:

- `srcs/docker-compose.yml`

## Container and volume management

Useful commands during development:

- `docker compose -f srcs/docker-compose.yml ps` to check the services.
- `docker compose -f srcs/docker-compose.yml logs -f` to follow logs.
- `docker compose -f srcs/docker-compose.yml down -v` to stop the stack and remove volumes.
- `docker volume ls` to list Docker volumes.
- `docker volume inspect <volume>` to inspect where a volume points.

The project defines two persistent volumes in Compose:

- `mariadb_data`
- `wordpress_data`

## Data persistence

The database and WordPress files are stored on the host under the directory defined by `DATA_PATH`:

- `/home/glucken/data/mariadb`
- `/home/glucken/data/wordpress`

These directories are bind-mounted through Docker volumes, so the data survives container rebuilds and restarts.

The data is created the first time the stack starts. It remains on disk until you remove it manually or run `make fclean` or `docker compose down -v`.

## Service layout

The stack is composed of:

- `mariadb` for the database backend.
- `wordpress` for the PHP application.
- `nginx` as the HTTPS reverse proxy.
- `adminer` for database administration.
- `static` for the static site.

Nginx listens on port `443` and routes requests to WordPress, Adminer, and the static site.
