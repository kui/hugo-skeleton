all: hugo build

hugo:
	./scripts/install-hugo.sh

build:
	./hugo

.PHONY: all build
