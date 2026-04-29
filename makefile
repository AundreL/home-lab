COLOR_GREEN=\033[0;32m
COLOR_RED=\033[0;31m
COLOR_BLUE=\033[0;34m
END_COLOR=\033[0m

HOME_DIR=/home/$(shell echo $$SUDO_USER)
SSH_DIR=$(HOME_DIR)/.ssh

.PHONY: build-nix-iso-prod
build-nix-iso-prod: #build nix iso for production
	nix build --impure path:nix-flakes/".#nixosConfigurations.iso-installer.config.system.build.isoImage" &> build-log-output.txt
	$(eval SECRET_STORE := $(shell grep -oP "location: \K.*" build-log-output.txt | tr -d ' '))
	@echo "variable: $(HOME_DIR)"

	rm -f $(HOME_DIR)/.ssh/known_hosts
	rm -f $(HOME_DIR)/.ssh/id_ed25519
	rm -f $(HOME_DIR)/.ssh/id_ed25519.pub
	cp $(SECRET_STORE)/id_ed25519 $(SSH_DIR)
	cp $(SECRET_STORE)/id_ed25519.pub $(SSH_DIR)
	
	chown $(SUDO_USER) $(SSH_DIR)/id_ed25519
	chown $(SUDO_USER) $(SSH_DIR)/id_ed25519.pub

	chmod 600 $(SSH_DIR)/id_ed25519
	chmod 600 $(SSH_DIR)/id_ed25519.pub

.PHONY: build-nix-iso-dev
build-nix-iso-dev: #build nix iso production script with output sent to stdout instead of log file
	nix build --impure path:nix-flakes/".#nixosConfigurations.iso-installer.config.system.build.isoImage"

.PHONY: build-nix-iso-verbose
build-nix-iso-verbose: #build nix iso with trace and verbose on
	nix build --verbose --impure --show-trace path:nix-flakes/".#nixosConfigurations.iso-installer.config.system.build.isoImage"

.PHONY: build-dev-wsl-flake
build-dev-wsl-flake: #build wsl flake
	nixos-rebuild switch --impure --flake path:nix-flakes/"#dev-wsl"

.PHONY: build-dev-box-flake
build-dev-box-flake: #build  dev box flake
	nixos-rebuild switch --impure --flake path:nix-flakes/"#dev-box"

.PHONY: create-nix-secrets
create-nix-secrets: #create nix secrets
	@echo "not implemented"
	#generate ssk key for iso boot strap
	#generate ssh key for node
	#move ssh to user .ssh folder
	#write public keys to .secrets.nix file

.PHONY: start-tauri-shell
start-tauri-shell:#start tauri shell
	nix develop nix-flakes/".#tauri" --command fish

.PHONY: test
test:	
	./test/update-test.sh

.PHONY: init-nix-struct
init-struct: #initialize file structure for flakes
	cp -r scripts/ nix-flakes
	cp -r dotfiles/ nix-flakes

.PHONY: resync-nix-struct
resync-nix-struct: #sync file structure for flakes
	rsync -avh --delete scripts/ nix-flakes/scripts
	rsync -avh --delete dotfiles/ nix-flakes/dotfiles

.PHONY: clean-nix
clean-nix: #clean nix
	nix-collect-garbage -d

default: help

.PHONY: help
help: #homelab builder
	@grep -E '^[a-za-z0-9 -]+:.*#'  makefile | sort | while read -r l; do printf "$(COLOR_GREEN)$$(echo $$l | cut -f 1 -d':')$(END_COLOR): $$(echo $$l | cut -f 2- -d'#')\n"; done
