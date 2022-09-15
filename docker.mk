.PHONY: help setup install build clean

VERSION := 81

help:
	@cat $(firstword $(MAKEFILE_LIST))

setup: \
	build

install:
	docker-compose run --rm php composer install

build:
	docker-compose build --build-arg VERSION=$(VERSION)

clean:
	docker-compose down -v
