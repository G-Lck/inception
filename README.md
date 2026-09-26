*This project has been created as part of the 42 curriculum by glucken.*

# Inception

## Description

Inception is an infrastructure project focused on deploying a small web stack with Docker.
The goal is to understand how to assemble multiple services in separate containers, make them communicate with each other, and keep important data persistent.

The project includes the following services:

- a `mariadb` service for the database,
- a `wordpress` service for the web application,
- an `nginx` service for the HTTPS reverse proxy,
- an `adminer` service for database administration,
- a `static` service for a separate static website.

The project files are located in `srcs/`, with a `docker-compose.yml` file at the root of that directory and one subdirectory per service containing its `Dockerfile`, configuration, and initialization scripts.

### Technical choices

The project uses Docker to isolate each service in its own container. This makes responsibilities clear, keeps the environment reproducible, and makes the infrastructure easy to redeploy.

Secrets are stored in dedicated files instead of being written directly into the environment. The database and WordPress files are kept through persistent volumes so the data remains available after containers stop or are rebuilt.

### Required comparisons

#### Virtual Machines vs Docker

A virtual machine runs a full operating system on top of a hypervisor. Docker is lighter because containers share the host kernel while still keeping a good level of isolation. For this project, Docker is a better fit because it allows multiple services to be started quickly without unnecessary overhead.

#### Secrets vs Environment Variables

Environment variables are convenient for simple values, but they are less suitable for sensitive data because they can be exposed more easily. Secrets are better for storing passwords or sensitive credentials because they are managed separately and mounted only where needed.

#### Docker Network vs Host Network

A dedicated Docker network allows containers to communicate with each other in an isolated way, with stable service names. Host network mode exposes the container directly on the host machine’s network, which reduces isolation and makes port control harder. In this project, a dedicated Docker network is the better choice.

#### Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker and are well suited for persistent data. Bind mounts point to a specific path on the host machine and provide more direct control over the files. In this project, the MariaDB and WordPress data are stored persistently through storage linked to the host `data/` directory.

## Instructions

### Prerequisites

- Docker
- Docker Compose v2
- `make`

### Installation

Before running the project, make sure the secret files exist in `secrets/`:

- `db_password.txt`
- `db_root_password.txt`
- `wp_queen_password.txt`
- `wp_user_password.txt`

Also make sure the `srcs/.env` file exists and contains the correct variables for your environment.

### Build and run

From the root of the project:

- `make` or `make up` builds the images if needed and starts the containers.
- `make build` builds the images without starting the services.
- `make down` stops the containers.
- `make clean` stops the containers and removes the images.
- `make fclean` removes the containers, images, and volumes.
- `make re` performs a full cleanup and starts the project again.

### Accessing the project

The WordPress site is accessible over HTTPS through the domain defined in `srcs/.env`.
Adminer is available through the `/adminer/` path on the same domain.

If the browser shows a certificate warning, that is expected because the certificate is self-signed.

## Resources

Useful resources used for this project:

- Docker reference and general documentation: https://docs.docker.com/reference
- Docker getting started guide: https://docs.docker.com/get-started
- PID 1 and signal handling in containers: https://denibertovic.com/posts/containers-and-signal-handling-why-you-need-to-care-about-pid-1/
- Zombie processes: https://en.wikipedia.org/wiki/Zombie_process
- Using Nginx with PHP-FPM: https://leyaa.ai/codefly/learn/nginx/qna/how-to-use-nginx-with-php-fpm
- Creating a MariaDB user and granting privileges: https://phoenixnap.com/kb/how-to-create-mariadb-user-grant-privileges
- TLS handshake videos by Computerphile: https://www.youtube.com/@Computerphile

### AI usage

AI was used to:

- rewrite Readme and user_doc and dev_doc
- answer questions and be like a teacher
- some debugging and vm setup