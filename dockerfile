# Dockerfile
FROM php:8.2-apache

FROM php:8.2-apache

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Installer Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && rm composer-setup.php

# Activer le module Apache rewrite
RUN a2enmod rewrite

# Définir la racine web
ENV APACHE_DOCUMENT_ROOT=/var/www/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# Copier le code source
COPY . /var/www/

WORKDIR /var/www/


# Copie tout dans le conteneur
COPY . /var/www/

# Spécifie le bon dossier comme racine publique
ENV APACHE_DOCUMENT_ROOT=/var/www/public

# Modifie la config Apache
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf \
 && a2enmod rewrite

WORKDIR /var/www/
