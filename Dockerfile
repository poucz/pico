FROM php:7.4-apache


RUN apt-get update && apt-get install -y zip git inotify-tools nano



RUN docker-php-source extract 	\
	php7.4-fpm php7.4 php7.4-cli php7.4-fpm php7.4-common php7.4-curl php7.4-gd php7.4-json php7.4-zip php7.4-xml php7.4-mbstring \
	&& docker-php-source delete


RUN docker-php-ext-install exif 
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd

WORKDIR /tmp
RUN curl -sSL https://getcomposer.org/installer | php
RUN php composer.phar --no-interaction create-project picocms/pico-composer /var/www/html

#POU themes:
RUN git clone https://github.com/poucz/picoFentoTheme.git
WORKDIR /tmp/picoFentoTheme
RUN cp -r picoFentoTheme/ /var/www/html/themes/
RUN cp -r plugins/PicoFotofolder/ /var/www/html/plugins/
RUN cp -r config.php /var/www/html/config/


WORKDIR /var/www/html

COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

#CMD ["apache2-foreground"]
CMD ["/usr/bin/run.sh"]
