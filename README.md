ymettier/rpi-roundcube
======================

Roundcube Docker container with these characteristics :

* Built from stable Roundcube releases
* `FROM arm32v7/php:7-apache`
* No SSL support (use a separate reverse proxy container if you need SSL)
* Hardcoded to sqlite (no need to configure a database)
* Defines a volume for database persistence
* Includes additional plugins :
* * carddav
* * markasjunk2
* * filters

Source
------

Get to https://github.com/ymettier/rpi-roundcube in order to build this container.

Usage
-----

```
docker run -d -p 80:80 ymettier/rpi-roundcube:<version>
```

With a volume for database persistence :

```
docker run -d -p 80:80 -v /some/path/for/persistence:/var/www/db ymettier/rpi-roundcube:<version>
```

Environment variables
---------------------

See `Dockerfile` for exhaustive list.

```
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
```

License
-------

This repo is published under the [MIT License](http://www.opensource.org/licenses/mit-license.php).
