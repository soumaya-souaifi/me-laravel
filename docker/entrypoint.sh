#!/bin/bash
set -euo pipefail
logo_print(){
        cat << "EOF"








         ▄▄▄▄▄▄▄▄▄▄                ▄            ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
        ▐░░░░░░░░░░▌              ▐░▌          ▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░░░░░░░░░░░▌
        ▐░█▀▀▀▀▀▀▀█░▌             ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀█░▌
        ▐░▌       ▐░▌             ▐░▌          ▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌
        ▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄▄▄ ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄█░▌
        ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌
        ▐░▌       ▐░▌ ▀▀▀▀▀▀▀▀▀▀▀ ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀▀▀ 
        ▐░▌       ▐░▌             ▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          
        ▐░█▄▄▄▄▄▄▄█░▌             ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          
        ▐░░░░░░░░░░▌              ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          
         ▀▀▀▀▀▀▀▀▀▀                ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀         ▀  ▀     



        ███╗   ███╗██╗███╗   ██╗██████╗     ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗███████╗██████╗ ██╗███╗   ██╗ ██████╗     
        ████╗ ████║██║████╗  ██║██╔══██╗    ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝██╔════╝██╔══██╗██║████╗  ██║██╔════╝     
        ██╔████╔██║██║██╔██╗ ██║██║  ██║    █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗  █████╗  ██████╔╝██║██╔██╗ ██║██║  ███╗    
        ██║╚██╔╝██║██║██║╚██╗██║██║  ██║    ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝  ██╔══╝  ██╔══██╗██║██║╚██╗██║██║   ██║    
        ██║ ╚═╝ ██║██║██║ ╚████║██████╔╝    ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗███████╗██║  ██║██║██║ ╚████║╚██████╔╝    
        ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═════╝     ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝  


                Docker LAMP (R) 2019
                by SAKLY Ayoub
                saklyayoub@gmail.com
                https://mind.engineering/



EOF
}
php_initilizing(){
        if [[ "$PHP_VERSION" = "5.6" ]] || [[ "$PHP_VERSION" = "7.0" ]] || [[ "$PHP_VERSION" = "7.1" ]] || [[ "$PHP_VERSION" = "7.2" ]] || [[ "$PHP_VERSION" = "7.3" ]]; then
                apt-get update -yq 1>/dev/null 2>&1;
                apt-get install libapache2-mod-php$PHP_VERSION 1>/dev/null 2>&1;
                a2enmod php$PHP_VERSION 1>/dev/null 2>&1;
                update-alternatives --set php /usr/bin/php$PHP_VERSION  1>/dev/null 2>&1;
                echo "[OK] PHP "$PHP_VERSION" INITILIZED"
        else
                echo "[ERROR] php version must be declared in docker-compose.yml in the correct format (5.6, 7.0, 7.1, 7.2 or 7.3)"
                exit
        fi
}
set_phpini_configuration(){
        if [[ -n "$PHP_MEMORY_LIMIT" ]]; then
                sed -i -e "s/memory_limit\s*=\s*2M/memory_limit = "$PHP_MEMORY_LIMIT"/g" /etc/php/$PHP_VERSION/apache2/php.ini
                echo "[OK] SET PHP_MEMORY_LIMIT "$PHP_MEMORY_LIMIT
        fi
        if [[ -n "$PHP_MAX_EXECUTION_TIME" ]]; then
                sed -i -e "s/max_execution_time\s*=\s*60M/max_execution_time = "$PHP_MAX_EXECUTION_TIME"/g" /etc/php/$PHP_VERSION/apache2/php.ini
                echo "[OK] SET PHP_MAX_EXECUTION_TIME "$PHP_MAX_EXECUTION_TIME
        fi
        if [[ -n "$PHP_UPLOAD_MAX_FILESIZE" ]]; then
                sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = "$PHP_UPLOAD_MAX_FILESIZE"/g" /etc/php/$PHP_VERSION/apache2/php.ini
                echo "[OK] SET PHP_UPLOAD_MAX_FILESIZE "$PHP_UPLOAD_MAX_FILESIZE
        fi
        if [[ -n "$PHP_POST_MAX_SIZE" ]]; then
                sed -i -e "s/post_max_size\s*=\s*2M/post_max_size = "$PHP_POST_MAX_SIZE"/g" /etc/php/$PHP_VERSION/apache2/php.ini
                echo "[OK] SET PHP_POST_MAX_SIZE "$PHP_POST_MAX_SIZE
        fi
        if [[ -n "$PHP_INPUT_VARS" ]]; then
                sed -i -e "s/max_input_vars\s*=\s*500/max_input_vars = "$PHP_INPUT_VARS"/g" /etc/php/$PHP_VERSION/apache2/php.ini
                echo "[OK] SET PHP_INPUT_VARS "$PHP_INPUT_VARS
        fi        
}
set_ioncubeloader_configuration(){
        if [[ "$PHP_VERSION" = "5.6" ]]; then
                cp /ioncube/ioncube/ioncube_loader_lin_5.6.so /usr/lib/php/20131226 && \
                echo zend_extension = /usr/lib/php/20131226/ioncube_loader_lin_5.6.so > /etc/php/5.6/cli/php.ini && \
                echo zend_extension = /usr/lib/php/20131226/ioncube_loader_lin_5.6.so > /etc/php/5.6/apache2/conf.d/00-ioncube.ini && \
                rm -rf /ioncube/ioncube/
                echo "[OK] IONCUBE LOADER 5.6 INSTALLED" 
        elif [[ "$PHP_VERSION" = "7.0" ]]; then
                cp /ioncube/ioncube/ioncube_loader_lin_7.0.so /usr/lib/php/20151012 && \
                echo zend_extension = /usr/lib/php/20151012/ioncube_loader_lin_7.0.so > /etc/php/7.0/cli/php.ini && \
                echo zend_extension = /usr/lib/php/20151012/ioncube_loader_lin_7.0.so > /etc/php/7.0/apache2/conf.d/00-ioncube.ini && \
                rm -rf /ioncube/ioncube/
                echo "[OK] IONCUBE LOADER 7.0 INSTALLED" 
        elif [[ "$PHP_VERSION" = "7.1" ]]; then
                cp /ioncube/ioncube/ioncube_loader_lin_7.1.so /usr/lib/php/20160303 && \
                echo zend_extension = /usr/lib/php/20160303/ioncube_loader_lin_7.1.so > /etc/php/7.1/cli/php.ini && \
                echo zend_extension = /usr/lib/php/20160303/ioncube_loader_lin_7.1.so > /etc/php/7.1/apache2/conf.d/00-ioncube.ini && \
                rm -rf /ioncube/ioncube/
                echo "[OK] IONCUBE LOADER 7.1 INSTALLED" 
        elif [[ "$PHP_VERSION" = "7.2" ]]; then
                cp /ioncube/ioncube/ioncube_loader_lin_7.2.so /usr/lib/php/20170718 && \
                echo zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.2.so > /etc/php/7.2/cli/php.ini && \
                echo zend_extension = /usr/lib/php/20170718/ioncube_loader_lin_7.2.so > /etc/php/7.2/apache2/conf.d/00-ioncube.ini && \
                rm -rf /ioncube/ioncube/    
                echo "[OK] IONCUBE LOADER 7.2 INSTALLED" 
        elif [[ "$PHP_VERSION" = "7.3" ]]; then
                cp /ioncube/ioncube/ioncube_loader_lin_7.3.so /usr/lib/php/20180731 && \
                echo zend_extension = /usr/lib/php/20180731/ioncube_loader_lin_7.3.so > /etc/php/7.3/cli/php.ini && \
                echo zend_extension = /usr/lib/php/20180731/ioncube_loader_lin_7.3.so > /etc/php/7.3/apache2/conf.d/00-ioncube.ini && \
                rm -rf /ioncube/ioncube/
                echo "[OK] IONCUBE LOADER 7.3 INSTALLED" 
        else
                echo "[ERROR] php version must be declared in docker-compose.yml in the correct format (5.6, 7.0, 7.1, 7.2 or 7.3)"
                exit
        fi
}
set_ssmtp_php_configuration(){

        echo "sendmail_path=sendmail -i -t" >> /etc/php/5.6/apache2/conf.d/php-sendmail.ini
        echo "[OK] SENDMAIL PHP COMMAND CONFIGURATION"
}
set_apache_servername(){

        echo "ServerName "$VIRTUAL_HOST >> /etc/apache2/apache2.conf 
        echo "[OK] APACHE SERVER NAME CONFIGURATION"  
}
set_apache_public_directory(){
        if [[ -n "$APACHE_PUBLIC_DIRECTORY" ]]; then
                sed -i -e 's#/var/www/html#'$APACHE_PUBLIC_DIRECTORY'#g' /etc/apache2/sites-enabled/000-default.conf
                echo "[OK] SET APACHE PUBLIC DIRECTORY "$APACHE_PUBLIC_DIRECTORY
        fi  
}
set_ssmtp_config(){
        if [[ -n "$SSMTP_MAILHUB" ]]; then
                sed -i -e 's#SSMTP_MAILHUB#'$SSMTP_MAILHUB'#g' /etc/ssmtp/ssmtp.conf
                echo "[OK] SSMTP MAILHUB "$SSMTP_MAILHUB
        fi
        if [[ -n "$SSMTP_MAILHUB_PORT" ]]; then
                sed -i -e 's#SSMTP_MAILHUB_PORT#'$SSMTP_MAILHUB_PORT'#g' /etc/ssmtp/ssmtp.conf
                echo "[OK] SSMTP PORT "$SSMTP_MAILHUB_PORT
        fi
        if [[ -n "$SSMTP_AUTH_USER" ]]; then
                sed -i -e 's#SSMTP_AUTH_USER#'$SSMTP_AUTH_USER'#g' /etc/ssmtp/ssmtp.conf
                sed -i -e 's#SSMTP_AUTH_USER#'$SSMTP_AUTH_USER'#g' /etc/ssmtp/revaliases
                echo "[OK] SSMTP AUTH USER "$SSMTP_AUTH_USER
        fi
        if [[ -n "$SSMTP_AUTH_PASS" ]]; then
                sed -i -e 's#SSMTP_AUTH_PASS#'$SSMTP_AUTH_PASS'#g' /etc/ssmtp/ssmtp.conf
                echo "[OK] SSMTP AUTH PASS "$SSMTP_AUTH_PASS
        fi
        if [[ -n "$SSMTP_USE_TLS" ]]; then
                sed -i -e 's#SSMTP_USE_TLS#'$SSMTP_USE_TLS'#g' /etc/ssmtp/ssmtp.conf
                echo "[OK] SSMTP USE TLS "$SSMTP_USE_TLS
        fi
        if [[ -n "$SSMTP_USE_STARTTLS" ]]; then
                sed -i -e 's#SSMTP_USE_STARTTLS#'$SSMTP_USE_STARTTLS'#g' /etc/ssmtp/ssmtp.conf
                echo "[OK] SSMTP USE STARTTLS "$SSMTP_USE_STARTTLS
        fi      
}
if [[ "$1" == apache2* ]]; then
        logo_print
        echo "[Initilizing ...]"
        echo ""
        echo ""
        php_initilizing
        #set_phpini_configuration
        set_ioncubeloader_configuration
        set_ssmtp_php_configuration
        set_apache_servername
        set_apache_public_directory
        set_ssmtp_config
        echo ""
        echo ""
        echo "**** CONTAINER STARED SUCCESSFULY ****"
        echo "below there will be the instant apache access and error log"
        echo ""
        echo ""
fi
exec "$@"
