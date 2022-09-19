FROM amazonlinux:2.0.20220719.0

ARG PHP_VERSION
ARG COMPOSER_VERSION

RUN yum update -y && \
    yum install -y \
      yum-utils \
      shadow-utils \
      net-tools \
      fcgi \
      procps \
      which \
      less

RUN groupadd --gid 998 nginx && \
    useradd --gid nginx --uid 999 nginx

RUN amazon-linux-extras install -y epel && \
    yum-config-manager --enable epel && \
    yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php${PHP_VERSION}

RUN yum update -y && \
    yum install -y \
      php${PHP_VERSION} \
      php${PHP_VERSION}-php-xml \
      php${PHP_VERSION}-php-mbstring \
      php${PHP_VERSION}-php-process \
      php${PHP_VERSION}-php-intl \
      php${PHP_VERSION}-php-pdo \
      php${PHP_VERSION}-php-opcache \
      php${PHP_VERSION}-php-fpm \
      make \
      git \
      unzip \
      && \
    yum clean all && \
    rm -rf /var/cache/yum/*

RUN ln -s /opt/remi/php72/root/usr/sbin/php-fpm /usr/sbin/php${PHP_VERSION}-fpm && \
    alternatives --install /usr/bin/php php /usr/bin/php${PHP_VERSION} 1 && \
    alternatives --install /usr/bin/php-fpm php-fpm /usr/sbin/php${PHP_VERSION}-fpm 1

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/bin --version=${COMPOSER_VERSION} --filename=composer && \
    php -r "unlink('composer-setup.php');"

RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.rpm.sh' | bash && \
    yum install -y symfony-cli

RUN git config --global user.email "tamakiii@users.noreply.github.com" && \
    git config --global user.name "tamakiii" && \
    composer config --global --no-plugins allow-plugins.symfony/flex true

RUN mkdir /var/log/php-fpm
RUN userdel apache

RUN ln -s /dev/stderr /var/opt/remi/php${PHP_VERSION}/log/php-fpm/error.log && \
    ln -s /dev/stderr /var/opt/remi/php${PHP_VERSION}/log/php-fpm/www.access.log

COPY docker/php/etc/opt/remi/php72/php-fpm.conf /etc/opt/remi/php72/php-fpm.conf
COPY docker/php/etc/opt/remi/php72/php-fpm.d/www.conf /etc/opt/remi/php72/php-fpm.d/www.conf

CMD ["php-fpm", "--nodaemonize", "--allow-to-run-as-root"]
