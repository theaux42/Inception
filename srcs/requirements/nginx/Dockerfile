FROM debian:oldstable

RUN apt-get update
RUN apt-get install -y nginx openssl vim curl

RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /var/run/nginx

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=FR/ST=IDF/L=Paris/O=42Paris/OU=42Paris/CN=tbabou.42.fr/UID=tbabou" \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

COPY conf/nginx.conf /etc/nginx/sites-available/default
EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
