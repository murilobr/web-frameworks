FROM php:7.3-fpm

RUN apt-get -qq update
RUN apt-get -qy install git zlib1g-dev libzip-dev nginx {{#deps}} {{{.}}} {{/deps}}
RUN docker-php-ext-install zip opcache

WORKDIR /usr/src/app

{{#php_ext}}
  RUN pecl install {{{.}}}
  RUN docker-php-ext-enable {{{.}}}
{{/php_ext}}

COPY . ./

{{^standalone}}
RUN curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --prefer-dist --classmap-authoritative
RUN composer dumpautoload -o
{{/standalone}}

{{#environment}}
ENV {{{.}}}
{{/environment}}

{{#before_command}}
  RUN {{{.}}}
{{/before_command}}

{{#command}}
  CMD {{{.}}}
{{/command}}

{{^command}}
  RUN sed -i 's/\;prefix.*/prefix = \/usr\/src\/app\/public/g' /usr/local/etc/php-fpm.d/www.conf
  RUN sed -i 's/\(listen =\).*/\1 \/var\/run\/php-fpm.sock/g' /usr/local/etc/php-fpm.d/www.conf
  RUN sed -i 's/\;\(listen\.owner.*\).*/\1/g' /usr/local/etc/php-fpm.d/www.conf
  RUN sed -i 's/\;\(listen\.group.*\).*/\1/g' /usr/local/etc/php-fpm.d/www.conf
  RUN sed -i 's/\;\(listen\.mode.*\).*/\1/g' /usr/local/etc/php-fpm.d/www.conf
  
  RUN rm -fr /etc/nginx/sites-enabled/default
  RUN rm -fr /usr/local/etc/php-fpm.d/zz-docker.conf
  
  RUN echo 'server {\n\
      root /usr/src/app/public;\n\
      listen 0.0.0.0:3000;\n\
      location / {\n\
          fastcgi_pass unix:/var/run/php-fpm.sock;\n\
          fastcgi_param   SCRIPT_FILENAME         $document_root/index.php;\n\
          include fastcgi_params;\n\
      }\n\
  }\n'\
  >> /etc/nginx/conf.d/www.conf
  
  RUN echo 'opcache.enable=1\n\
  opcache.memory_consumption=512\n\
  opcache.interned_strings_buffer=64\n\
  opcache.max_accelerated_files=32531\n\
  opcache.validate_timestamps=0\n\
  opcache.save_comments=1\n\
  opcache.fast_shutdown=0\n'\
  >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
  
  RUN echo "daemon off;" >> /etc/nginx/nginx.conf
  
  CMD /usr/local/sbin/php-fpm --daemonize; service nginx start
{{/command}}
