# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tbabou <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/05 16:07:29 by tbabou            #+#    #+#              #
#    Updated: 2025/07/05 16:09:07 by tbabou           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#Using Debian as a base for it
#Dockerfile of MariaDB
FROM debian:oldstable

RUN apt update && apt upgrade -y
RUN apt install -y mariadb-server

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/create_database.sh /tmp/create_database.sh

RUN chmod +x /tmp/create_database.sh

EXPOSE 3306

CMD ["/tmp/create_database.sh"]
