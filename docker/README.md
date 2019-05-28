
![Depfu](https://img.shields.io/badge/TAG-latest-ff69b4.svg?longCache=true&style=for-the-badge)![Depfu](https://img.shields.io/badge/Ubuntu-18.10-red.svg?longCache=true&style=for-the-badge)![Depfu](https://img.shields.io/badge/Apache-2.1.29-green.svg?longCache=true&style=for-the-badge)![Depfu](https://img.shields.io/badge/Php-5.6+7.0+7.1+7.2+7.3-orange.svg?longCache=true&style=for-the-badge)![Depfu](https://img.shields.io/badge/PHPMYADMIN-4.8.2-yellow.svg?longCache=true&style=for-the-badge)
![Depfu](https://img.shields.io/badge/sSMTP-6.64-blue.svg?longCache=true&style=for-the-badge)

## Features


 * Php from 5.6 -> 7.3 with php.ini configuration file in docker-compose.yml
 * Ioncube loader
 * Php Composer
 * Npm
 * Nodejs
 * Graohicsmagick
 * Ghostscript
 * OpenSSH with no StrictHostKeyChecking configuration
 * Preconfigured PhpMyAdmin that connect directly to separate MySQL container
 * sSMTP & Mailutils with credential and configuration available from docker-compose.yml
 * Apache access.log & error.log are logged directly in docker.log
 * Apache public directory configuration file in docker-compose.yml (ideal for laravel projects)

## Deployment & Dependency

* Docker-CE
* Docker-compose

## Built With

* [Github](https://github.com/saklyayoub/d-lamp) - Source code - hosting & versioning platform used
* [Dockerhub Cloud](https://cloud.docker.com/swarm/saklyayoub) - Docker Image - CI & Hosting platform

## Using the image
### Initial docker-compose 

    version: '2'
    services:
    
    web:
      container_name: web
      image: saklyayoub/d-lamp
      restart: always
      hostname: my.localhost
      volumes:
        - $PWD/public_html:/var/www/html
      environment:
        VIRTUAL_HOST: my.localhost
        PHP_VERSION: 7.0
        PHP_MEMORY_LIMIT: 1024M
        PHP_MAX_EXECUTION_TIME: 600
        PHP_UPLOAD_MAX_FILESIZE: 64M
        PHP_POST_MAX_SIZE: 64M
        PHP_INPUT_VARS: 1500
        APACHE_PUBLIC_DIRECTORY: /var/www/html/public
        SSMTP_MAILHUB: smtp.provider.tn
        SSMTP_MAILHUB_PORT: '25'
        SSMTP_AUTH_USER: contat@myemail.me
        SSMTP_AUTH_PASS: 'kjhbkyTYFjkhbk'
        SSMTP_USE_TLS: 'NO'
        SSMTP_USE_STARTTLS: 'NO'
      ports:
        - 80:80
        - 587:587
      network_mode: bridge
        
### docker-compose with mysql container

    version: '2'
    services:
    
    mysql:
      container_name: mysql
      image: mysql:5.7.23
      restart: always
      environment:
        MYSQL_DATABASE : database
        MYSQL_USER: user
        MYSQL_PASSWORD: password
        MYSQL_ROOT_PASSWORD: password
      volumes:
        - $PWD/.mysql:/var/lib/mysql
        - #- ./init_sql:/docker-entrypoint-initdb.d
      network_mode: bridge
    
    web:
      container_name: web
      image: saklyayoub/d-lamp
      #build: ./docker-build
      depends_on:
        - mysql
      restart: always
      hostname: my.localhost
      links:
        - mysql:mysql
      volumes:
        - $PWD/public_html:/var/www/html
      environment:
        VIRTUAL_HOST: my.localhost
        PHP_VERSION: 7.0
        PHP_MEMORY_LIMIT: 1024M
        PHP_MAX_EXECUTION_TIME: 600
        PHP_UPLOAD_MAX_FILESIZE: 64M
        PHP_POST_MAX_SIZE: 64M
        PHP_INPUT_VARS: 1500
        APACHE_PUBLIC_DIRECTORY: /var/www/html/public
        SSMTP_MAILHUB: smtp.provider.tn
        SSMTP_MAILHUB_PORT: '25'
        SSMTP_AUTH_USER: contat@myemail.me
        SSMTP_AUTH_PASS: 'kjhbkyTYFjkhbk'
        SSMTP_USE_TLS: 'NO'
        SSMTP_USE_STARTTLS: 'NO'
      ports:
        - 80:80
        - 87:587
      network_mode: bridge
        
### docker-compose with nginx-reverse proxy and letsencrypt certbot and mysql backup container

    version: '2'
    services:
    nginx:
      container_name: nginx
      image: nginx
      restart: always
      ports:
        - 80:80
        - 443:443
      volumes:
        - /etc/nginx/conf.d
        - /etc/nginx/vhost.d
        - /usr/share/nginx/html
        - $PWD/.certs:/etc/nginx/certs:ro
        - $PWD/my_proxy.conf:/etc/nginx/conf.d/my_proxy.conf
      labels:
        - "com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy"
      network_mode: bridge
      nginx-gen:
      container_name: nginx-gen
      image: jwilder/docker-gen
      restart: always
      volumes_from:
        - nginx
      volumes:
        - $PWD/nginx.tmpl:/etc/docker-gen/templates/nginx.tmpl:ro 
        - /var/run/docker.sock:/tmp/docker.sock:ro
      labels:
        - "com.github.jrcs.letsencrypt_nginx_proxy_companion.docker_gen"
      command: -notify-sighup nginx -watch -wait 5s:30s /etc/docker-gen/templates/nginx.tmpl /etc/nginx/conf.d/default.conf   
      network_mode: bridge
      nginx-letsencrypt:
      container_name: nginx-letsencrypt
      image: jrcs/letsencrypt-nginx-proxy-companion
      restart: always
      depends_on:
        - "nginx-gen"
      volumes_from:
        - nginx
      volumes:
        - $PWD/.certs:/etc/nginx/certs:rw
        - /var/run/docker.sock:/var/run/docker.sock:ro
      network_mode: bridge
    mysql:
      container_name: mysql
      image: mysql:5.7.23
      restart: always
      environment:
        MYSQL_DATABASE : database
        #MYSQL_USER: user
        #MYSQL_PASSWORD: password
        MYSQL_ROOT_PASSWORD: password
      volumes:
        - $PWD/.mysql:/var/lib/mysql
        - #- ./init_sql:/docker-entrypoint-initdb.d
      network_mode: bridge
    mysql_backup:
      container_name: mysql_backup
      image: databack/mysql-backup
      depends_on:
        - mysql
      links:
        - mysql:mysql
      restart: always
      volumes:
        - $PWD/.db_backups:/db
      environment:
        - DB_DUMP_TARGET=/db
        - DB_USER=root
        - DB_PASS=password
        - DB_DUMP_FREQ=86400
        - DB_DUMP_BEGIN=0000
        - DB_SERVER=mysql
      network_mode: bridge  
    web:
      container_name: web
      image: saklyayoub/d-lamp
      #build: ./docker-build
      depends_on:
        - mysql
      restart: always
      hostname: my.localhost
      links:
        - mysql:mysql
      volumes:
        - $PWD/public_html:/var/www/html
      environment:
        VIRTUAL_HOST: my.localhost
        #LETSENCRYPT_EMAIL: myletsencryptemail@privider.com
    #LETSENCRYPT_HOST: www.$host, $host
        PHP_VERSION: 7.0
        PHP_MEMORY_LIMIT: 1024M
        PHP_MAX_EXECUTION_TIME: 600
        PHP_UPLOAD_MAX_FILESIZE: 64M
        PHP_POST_MAX_SIZE: 64M
        PHP_INPUT_VARS: 1500
        APACHE_PUBLIC_DIRECTORY: /var/www/html/public
        SSMTP_MAILHUB: smtp.provider.tn
        SSMTP_MAILHUB_PORT: '25'
        SSMTP_AUTH_USER: contat@myemail.me
        SSMTP_AUTH_PASS: 'kjhbkyTYFjkhbk'
        SSMTP_USE_TLS: 'NO'
        SSMTP_USE_STARTTLS: 'NO'
      ports:
        - 87:587
      network_mode: bridge
        
### Testing

We use docker-compose to setup, build and run our testing environment. It allows us to offload a large amount of the testing overhead to Docker, and to ensure that we always test our image in a consistent way thats not affected by the host machine.

## Contributing

If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

Clone/fork it
Create your feature branch (git checkout -b my-new-feature)
Commit your changes (git commit -am 'Add some feature')
Push to the branch (git push origin my-new-feature)
Create a new Pull Request

## License

This project is licensed under the GNU General Public License v3.0 License - see the [LICENSE](LICENSE) file for details.

## Authors

* **Sakly Ayoub** - *Initial work* - [Sakly Ayoub](https://github.com/saklyayoub)

## Acknowledgments

* Inspiration : [Docker Lamp](https://github.com/mattrayner/docker-lamp) by [Mat Trayner](https://github.com/mattrayner)