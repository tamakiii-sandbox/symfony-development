FROM amazonlinux:2.0.20220719.0

ARG VERSION

RUN yum update -y && \
    yum install -y yum-utils

RUN amazon-linux-extras install -y epel && \
    yum-config-manager --enable epel && \
    yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php${VERSION}

RUN yum update -y && \
    yum install -y \
      php${VERSION} \
      php${VERSION}-php-xml \
      php${VERSION}-php-mbstring \
      php${VERSION}-php-process \
      php${VERSION}-php-intl \
      php${VERSION}-php-pdo \
      php${VERSION}-php-opcache \
      which \
      less \
      make \
      git \
      unzip

RUN alternatives --install /usr/bin/php php /usr/bin/php${VERSION} 1

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    mkdir -p /usr/local/cellar/composer/2.2.9/bin && \
    php composer-setup.php --install-dir=/usr/local/cellar/composer/2.2.9/bin --version=2.2.9 --filename=composer && \
    php -r "unlink('composer-setup.php');"

RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.rpm.sh' | bash && \
    yum install -y symfony-cli

RUN git config --global user.email "tamakiii@users.noreply.github.com" && \
    git config --global user.name "tamakiii" && \
    composer config --global --no-plugins allow-plugins.symfony/flex true
