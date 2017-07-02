FROM arm32v7/php:7-apache
#https://hub.docker.com/r/arm32v7/php/
MAINTAINER Yves Mettier <ymettier@free.fr>

ARG version
ENV RC_DEFAULT_HOST 'localhost'
ENV RC_SMTP_SERVER 'localhost'
ENV RC_SMTP_PORT '25'
ENV RC_SMTP_USER '%u'
ENV RC_SMTP_PASS '%p'
ENV RC_PRODUCT_NAME 'Awesome Roundcube'
ENV RC_LOG_DIR 'logs/'
ENV RC_TEMP_DIR 'temp/'
ENV RC_LANGUAGE 'fr_FR'
ENV RC_PREFER_HTML 'false'
ENV RC_DISPLAY_NEXT 'false'
ENV RC_MESSAGE_CACHE_LIFETIME '10d'
ENV RC_SKIN 'larry'

WORKDIR /var/www/html

COPY config/php.ini /usr/local/etc/php/

RUN apt-get update \
  && apt-get -y dist-upgrade \
  && apt-get -y install \
      git \
      libcurl4-gnutls-dev \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libldap2-dev \
      libperl4-corelibs-perl \
      libpng12-dev \
      libsasl2-dev \
      lsof \
      psmisc \
      ucf \
      unzip \
      zip \
    && docker-php-ext-configure ldap --with-libdir=lib/arm-linux-gnueabihf \
    && docker-php-ext-install ldap \
    && docker-php-ext-install curl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN curl -q -s -L -o /tmp/rc.tar.gz https://github.com/roundcube/roundcubemail/releases/download/${version}/roundcubemail-${version}-complete.tar.gz \
  && tar xzf /tmp/rc.tar.gz -C /var/www/ \
  && (cd /var/www/roundcubemail-${version}; tar cf - . | tar -xf - -C /var/www/html ) \
  && rm -f /tmp/rc.tar.gz \
  && rm -rf /var/www/roundcubemail-${version}

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php --install-dir=/usr/bin --filename=composer \
  && php -r "unlink('composer-setup.php');"

RUN mv composer.json-dist composer.json \
    && composer config secure-http false \
    && composer require --update-no-dev \
        roundcube/plugin-installer:dev-master \
        roundcube/carddav:dev-master \
        roundcube/filters:dev-master \
        johndoh/markasjunk2 \
    && composer clear-cache

RUN chown -Rh www-data:www-data /var/www/html

RUN apt-get clean

COPY app /app

# Setup logging
RUN mkdir -p /etc/services.d/logs && echo /var/www/logs/errors >> /etc/services.d/logs/stderr

# Keep the db in a volume for persistence
VOLUME /var/www/db

EXPOSE 80

CMD ["/app/start.sh"]
