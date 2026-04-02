COLOR_GREEN=\033[0;32m
COLOR_RED=\033[0;31m
COLOR_BLUE=\033[0;34m
END_COLOR=\033[0m

.PHONY: test
test:	
	./test/update-test.sh

.PHONY: build-nix-iso
build-nix-iso: #build nix iso
	nix build --verbose --impure --show-trace --print-build-logs nix-flakes/".#nixosConfigurations.iso-installer.config.system.build.isoImage"

.PHONY: clean-nix
clean-nix: #clean nix
	echo "clean nix"

default: help

.PHONY: help
help: #homelab builder
	@grep -E '^[a-za-z0-9 -]+:.*#'  makefile | sort | while read -r l; do printf "$(COLOR_GREEN)$$(echo $$l | cut -f 1 -d':')$(END_COLOR): $$(echo $$l | cut -f 2- -d'#')\n"; done
