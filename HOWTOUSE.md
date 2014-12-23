PUMA
==============================
To launch puma with the right settings:
  $ bundle exec puma -e production -b unix:///Users/joshu/work/ColourMatch/tmp/sockets.puma.sock

SECRET KEYS
==============================
For some reason, it isnt reading the environment variable. Just copy/paste one of the other environments' in config/secrets.yml

ENVIRONMENT SETTINGS
==============================
In config/database.yml, make sure the production uses the development database, so we dont have to copy our DB over.


NGINX
==============================

You'll also need to make sure nginx is configured properly and running. 
Let's backup the configuration file and open in sublime.

  $ cd /usr/local/etc/nginx/ && mv nginx.conf nginx_BACKUP.conf && subl nginx.conf


Paste this into the new file:


#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;



    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    upstream puma {
      server unix:///Users/joshu/work/ColourMatch/tmp/sockets/puma.sock;
    }

    server {
      listen 3000;
      # server_name example.com;

      root /Users/joshu/work/ColourMatch/public;
      access_log /Users/joshu/work/ColourMatch/log/nginx.access.log;
      error_log /Users/joshu/work/ColourMatch/log/nginx.error.log info;

      location ^~ /assets/ {
        gzip_static on;
        expires max;
        add_header Cache-Control public;
      }

      location ^~ /photos/ {
        add_header Cache-Control no-cache;
      }

      try_files $uri/index.html $uri @puma;
      location @puma {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;

        proxy_pass http://puma;
      }

      error_page 500 502 503 504 /500.html;
      client_max_body_size 10M;
      keepalive_timeout 10;
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}
