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
ENV RC_LANGUAGE 'en_US'
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
  && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
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

# Fix for bug in filters plugin (https://github.com/6ec123321/filters/pull/28)
RUN sed -i -e 's/, RCUBE_INPUT_POST, true/, rcube_utils::INPUT_POST, true/g' /var/www/html/plugins/filters/filters.php

RUN apt-get clean

COPY app /app

# Setup logging
RUN mkdir -p /etc/services.d/logs && echo /var/www/logs/errors >> /etc/services.d/logs/stderr

# Keep the db in a volume for persistence
VOLUME /var/www/db

EXPOSE 80

CMD ["/app/start.sh"]
