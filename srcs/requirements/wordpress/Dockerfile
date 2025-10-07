FROM debian:oldstable

RUN apt update && apt upgrade -y
RUN apt install -y php php-fpm php-mysql wget curl mariadb-client

# Create WordPress user and directories
RUN groupadd -r www-data && useradd -r -g www-data www-data || true
RUN mkdir -p /var/www/html /var/run/php

COPY tools/install-wordpress.sh /tmp/install-wordpress.sh
COPY conf/wp-config.php /tmp/wp-config.php
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod +x /tmp/install-wordpress.sh

EXPOSE 9000

CMD ["/tmp/install-wordpress.sh"]
