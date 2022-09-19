.PHONY: help setup install build clean

PHP_VERSION := 81
COMPOSER_VERSION := 2.4.2
TARGET := development
# old: 2.2.9

help:
	@cat $(firstword $(MAKEFILE_LIST))

setup: \
	build

build:
	docker-compose build \
		--build-arg TARGET=$(TARGET) \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg COMPOSER_VERSION=$(COMPOSER_VERSION)

install: | dependency/tamakiii-sandbox/init-symfony
	docker-compose run --rm php composer install

clean:
	docker-compose down -v --remove-orphans
