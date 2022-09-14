.PHONY: help install clean

VERSION := 81

help:
	@cat $(firstword $(MAKEFILE_LIST))

install:
	docker-compose build --build-arg VERSION=$(VERSION)

clean:
	docker-compose down -v
