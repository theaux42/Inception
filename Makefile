all : up

up :
	@mkdir -p ./data/mariadb
	@mkdir -p ./data/wordpress
	@docker compose -f ./srcs/docker-compose.yml up -d

stop :
	@docker compose -f ./srcs/docker-compose.yml down

status :
	@docker ps

logs :
	@docker compose -f ./srcs/docker-compose.yml logs -f

clean :
	@docker compose -f ./srcs/docker-compose.yml down --volumes --rmi all

fclean : clean
	@docker system prune -af --volumes
	@sudo rm -rf ~/Inception/data

re : fclean all

.PHONY: all up stop status logs clean fclean re
