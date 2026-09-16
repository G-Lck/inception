##### VARIABLES #####

include srcs/.env
export

DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml
DATA_DIRS = $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress

##### RULES #####

all:
	mkdir -p $(DATA_DIRS)
	$(DOCKER_COMPOSE) up -d --build

build:
	mkdir -p $(DATA_DIRS)
	$(DOCKER_COMPOSE) build

up:
	mkdir -p $(DATA_DIRS)
	$(DOCKER_COMPOSE) up -d --build

down:
	$(DOCKER_COMPOSE) down

clean:
	$(DOCKER_COMPOSE) down --rmi all

fclean:
	make clean
	$(DOCKER_COMPOSE) down -v

re:
	make fclean
	make up

.PHONY: all build up down clean fclean re