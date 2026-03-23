# Variables
NAME = inception
SRCS_DIR = ./srcs
DOCKER_COMPOSE = docker compose -f $(SRCS_DIR)/docker-compose.yml

# Colors for pretty output
GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m

all: setup build up

setup:
	@echo "$(GREEN)Creating data directories...$(RESET)"
	@mkdir -p /home/sasakuya/data/mariadb
	@mkdir -p /home/sasakuya/data/wordpress

build:
	@echo "$(GREEN)Building containers...$(RESET)"
	@$(DOCKER_COMPOSE) build

up:
	@echo "$(GREEN)Starting containers...$(RESET)"
	@$(DOCKER_COMPOSE) up -d

down:
	@echo "$(RED)Stopping containers...$(RESET)"
	@$(DOCKER_COMPOSE) down

re: fclean all

clean: down
	@echo "$(RED)Removing images...$(RESET)"
	@docker system prune -a -f

fclean: clean
	@echo "$(RED)Deep cleaning: removing volumes and data folders...$(RESET)"
	@docker volume rm $$(docker volume ls -q) || true
	@sudo rm -rf /home/sasakuya/data
	@docker system prune -af --volumes

.PHONY: all setup build up down re clean fclean
