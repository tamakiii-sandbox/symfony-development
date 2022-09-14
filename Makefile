.PHONY: help setup install clean

VERSION := 2.7

help:
	@cat $(firstword $(MAKEFILE_LIST))

setup: \
	dependency/cellar/tamakiii-sandbox/init-symfony-$(VERSION) \
	dependency/tamakiii-sandbox/init-symfony

install:

dependency/tamakiii-sandbox/init-symfony: dependency/cellar/tamakiii-sandbox/init-symfony-$(VERSION) | dependency/tamakiii-sandbox
	bin/ln $< $@

dependency/cellar/tamakiii-sandbox/init-symfony-$(VERSION): | dependency/cellar/tamakiii-sandbox
	git clone git@github.com:$(notdir $|)/$(notdir $@).git $@

dependency/cellar/tamakiii-sandbox: | dependency/cellar
	mkdir $@

dependency/tamakiii-sandbox: | dependency
	mkdir $@

dependency/cellar: | dependency
	mkdir $@

dependency:
	mkdir $@

clean:
	rm -rf dependency
