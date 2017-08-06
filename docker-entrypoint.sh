#!/usr/bin/env bash
set -e

# Configure php-fpm
sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf

PHP_ERROR_REPORTING=${PHP_ERROR_REPORTING:-"E_ALL"}
sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/7.0/cli/php.ini
sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/7.0/fpm/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php/7.0/cli/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php/7.0/fpm/php.ini
echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php/7.0/cli/php.ini
echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php/7.0/fpm/php.ini

# Configure nginx
echo "daemon off;" >> /etc/nginx/nginx.conf
cat <<'EOF' > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;

    index index.php index.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }
}
EOF

# Configure supervisor
cat <<'EOF' > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true

[program:php-fpm]
command=/usr/sbin/php-fpm7.0

[program:nginx]
command=/usr/sbin/nginx
EOF

# Use supervisor to monitor FPM and nginx
supervisord
