.PHONY: help setup install build clean

PHP_VERSION := 81
COMPOSER_VERSION := 2.4.2
# old: 2.2.9

help:
	@cat $(firstword $(MAKEFILE_LIST))

setup: \
	build

install:
	docker-compose run --rm php composer install

build:
	docker-compose build \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg COMPOSER_VERSION=$(COMPOSER_VERSION)

clean:
	docker-compose down -v
