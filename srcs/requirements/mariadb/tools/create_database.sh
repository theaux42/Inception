#!/bin/bash

echo "==> Starting MariaDB service..."
service mariadb start
sleep 5

echo "==> Running mysql_secure_installation..."
mysql_secure_installation << EOF
n
${MYSQL_ROOT_PASSWORD}
${MYSQL_ROOT_PASSWORD}
y
n
n
n
n
EOF

echo "==> Creating database and user..."
echo "Database: ${MYSQL_DATABASE}"
echo "User: ${MYSQL_USER}"

cat > /tmp/db1.sql << EOF
# 1. Définir la base de données et l'utilisateur de l'application (votre code)
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

# 2. SÉCURISATION ROOT LOCALE (NOUVEAU)
# Force root@localhost à utiliser le mot de passe défini par MARIADB_ROOT_PASSWORD
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_ROOT_PASSWORD}');

FLUSH PRIVILEGES;
EOF

echo "==> SQL script created at /tmp/db1.sql:"
cat /tmp/db1.sql

echo "==> Executing SQL script..."
mariadb -u root -p${MYSQL_ROOT_PASSWORD} < /tmp/db1.sql

if [ $? -eq 0 ]; then
    echo "==> Database setup completed successfully!"
else
    echo "==> ERROR: Database setup failed!"
    exit 1
fi

echo "==> Shutting down MariaDB..."
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

echo "==> Starting MariaDB daemon..."
exec mariadbd
