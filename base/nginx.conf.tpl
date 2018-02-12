user $NGINX_USER;
worker_processes auto;
pid /run/nginx.pid;

events {
	worker_connections 768;
}

http {

	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	gzip on;
	gzip_disable "msie6";

	include /etc/nginx/conf.d/*.conf;
	#include /etc/nginx/sites-enabled/*;

	server {
        listen 80  default_server;
        root $NGINX_WEB_ROOT;

        location / {
            try_files $uri $NGINX_PHP_FALLBACK$is_args$args;
        }

        location ~ [^/]\.php(/|$) {
            fastcgi_split_path_info ^(.+?\.php)(/.*)$;
            if (!-f $document_root$fastcgi_script_name) {
                return 404;
            }

            fastcgi_param HTTP_PROXY "";

            fastcgi_pass unix:$PHP_SOCK_FILE;
            fastcgi_index index.php;

            # include the fastcgi_param setting
            include fastcgi_params;

            fastcgi_param  SCRIPT_FILENAME   $document_root$fastcgi_script_name;
        }
    }
}
