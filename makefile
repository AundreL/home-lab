COLOR_GREEN=\033[0;32m
COLOR_RED=\033[0;31m
COLOR_BLUE=\033[0;34m
END_COLOR=\033[0m

.PHONY: test
test:	
	./test/update-test.sh

default: help

.PHONY: help
help: #jig make file commands
	@grep -E '^[a-za-z0-9 -]+:.*#'  makefile | sort | while read -r l; do printf "$(COLOR_GREEN)$$(echo $$l | cut -f 1 -d':')$(END_COLOR): $$(echo $$l | cut -f 2- -d'#')\n"; done
