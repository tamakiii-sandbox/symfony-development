.PHONY: help setup install build clean

PHP_VERSION := 81
COMPOSER_VERSION := 2.4.2
# old: 2.2.9

help:
	@cat $(firstword $(MAKEFILE_LIST))

setup: \
	build

build:
	docker-compose build \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg COMPOSER_VERSION=$(COMPOSER_VERSION)

install: | dependency/tamakiii-sandbox/init-symfony
	docker-compose run --rm php composer install

clean:
	rm -rf dependency/tamakiii-sandbox/init-symfony/vendor
	docker-compose down -v --remove-orphans
