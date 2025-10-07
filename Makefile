all : up

up :
	@docker compose -f ./srcs/docker-compose.yml up -d

down :
	@docker compose -f ./srcs/docker-compose.yml down

stop :
	@docker compose -f ./srcs/docker-compose.yml stop

start :
	@docker compose -f ./srcs/docker-compose.yml start

status :
	@docker ps

rebuild :
	@docker compose -f ./srcs/docker-compose.yml build --no-cache

rebuild-up :
	@docker compose -f ./srcs/docker-compose.yml up -d --build --force-recreate

logs :
	@docker compose -f ./srcs/docker-compose.yml logs -f

clean :
	@docker compose -f ./srcs/docker-compose.yml down --volumes --rmi all

fclean : clean
	@docker system prune -af --volumes
	@rm -rf /home/theaux/Inception/data/wordpress/*
	@rm -rf /home/theaux/Inception/data/mariadb/*

re : fclean all

.PHONY: all up down stop start status rebuild rebuild-up logs clean fclean re
