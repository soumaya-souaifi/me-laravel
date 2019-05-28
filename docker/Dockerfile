FROM ubuntu:18.10
LABEL Maintainer="Sakly Ayoub"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install software-properties-common -yq 
RUN add-apt-repository ppa:ondrej/php -y 
RUN apt-get install -yq \
    apt-utils \
    curl \
    apache2 \
    php5.6 \
    php5.6-cli \
    php5.6-json \
    php5.6-curl \
    php5.6-fpm \
    php5.6-gd \
    php5.6-ldap \
    php5.6-mbstring \
    php5.6-mysql \
    php5.6-soap \
    php5.6-sqlite3 \
    php5.6-xml \
    php5.6-zip \
    php5.6-intl \
    php5.6-mcrypt \
    php7.0 \
    php7.0-cli \
    php7.0-json \
    php7.0-curl \
    php7.0-fpm \
    php7.0-gd \
    php7.0-ldap \
    php7.0-mbstring \
    php7.0-mysql \
    php7.0-soap \
    php7.0-sqlite3 \
    php7.0-xml \
    php7.0-zip \
    php7.0-intl \
    php7.0-mcrypt \
    php7.1 \
    php7.1-cli \
    php7.1-json \
    php7.1-curl \
    php7.1-fpm \
    php7.1-gd \
    php7.1-ldap \
    php7.1-mbstring \
    php7.1-mysql \
    php7.1-soap \
    php7.1-sqlite3 \
    php7.1-xml \
    php7.1-zip \
    php7.1-intl \
    php7.1-mcrypt \
    php7.2 \
    php7.2-cli \
    php7.2-json \
    php7.2-curl \
    php7.2-fpm \
    php7.2-gd \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-xml \
    php7.2-zip \
    php7.2-intl \
    php7.3 \
    php7.3-cli \
    php7.3-json \
    php7.3-curl \
    php7.3-fpm \
    php7.3-gd \
    php7.3-ldap \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-soap \
    php7.3-sqlite3 \
    php7.3-xml \
    php7.3-zip \
    php7.3-intl \
    php-imagick \ 
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    iputils-ping \
    nodejs \
    npm \
    locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install wget -y
RUN mkdir /ioncube && \
    cd /ioncube && \
    wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
    tar xvf ioncube_loaders_lin_x86-64.tar.gz
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8 && \ 
    a2enmod rewrite expires && \
    rm /var/www/html/index.html && \
    chown -R www-data:www-data /var/www/html
RUN apt-get install openssh-server -y && \
    { echo "\nStrictHostKeyChecking no"; } > /etc/ssh/ssh_config \
    && mkdir -p /root/.ssh
RUN wget -O /tmp/phpmyadmin.tar.gz https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.tar.gz && \
    tar xfvz /tmp/phpmyadmin.tar.gz -C /var/www && \
    ln -s /var/www/phpMyAdmin-4.8.2-all-languages /var/www/phpmyadmin &&\
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get clean && \
    apt-get autoremove && \
    apt-get update -y && \
    apt-get install ssmtp -q -y && \
    apt-get install mailutils -q -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /etc/ssmtp/ssmtp.conf /etc/ssmtp/revaliases    
VOLUME /var/www/html
ADD config.inc.php /var/www/phpMyAdmin-4.8.2-all-languages/
RUN chmod 544 /var/www/phpMyAdmin-4.8.2-all-languages/config.inc.php  
ADD revaliases /etc/ssmtp/revaliases
ADD ssmtp.conf /etc/ssmtp/ssmtp.conf
ADD php.ini /etc/php/5.6/apache2/conf.d/
ADD php.ini /etc/php/7.0/apache2/conf.d/
ADD php.ini /etc/php/7.1/apache2/conf.d/
ADD php.ini /etc/php/7.2/apache2/conf.d/
ADD php.ini /etc/php/7.3/apache2/conf.d/
ADD default.conf /etc/apache2/sites-enabled/000-default.conf
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 80 443 587 25
RUN ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log
CMD ["apache2ctl", "-D", "FOREGROUND"]