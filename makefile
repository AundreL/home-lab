COLOR_GREEN=\033[0;32m
COLOR_RED=\033[0;31m
COLOR_BLUE=\033[0;34m
END_COLOR=\033[0m

ifeq ($(shell id -u), 0)
	HOME_DIR=/home/$(shell echo $$SUDO_USER)
else
	HOME_DIR=$$HOME
endif

SSH_DIR=$(HOME_DIR)/.ssh

SSH_DEV_BOX_NIXOS=id_ed25519_dev_box_nixos
SSH_DEV_BOX_AUNDRE=id_ed25519_dev_box_aundre

SSH_DEV_BOX_NIXOS_PUB_KEY_F=$(HOME_DIR)/.ssh/$(SSH_DEV_BOX_NIXOS).pub
SSH_DEV_BOX_AUNDRE_PUB_KEY_F=$(HOME_DIR)/.ssh/$(SSH_DEV_BOX_AUNDRE).pub

.PHONY: build-nix-iso-prod
build-nix-iso-prod: #build nix iso for production
	nix build --impure path:nix-flakes/".#nixosConfigurations.iso-installer.config.system.build.isoImage" &> build-log-output.txt
	$(eval SECRET_STORE := $(shell grep -oP "location: \K.*" build-log-output.txt | tr -d ' '))

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

create-nix-secrets: check-keys-exist #create nix secrets
	rm nix-flakes/secrets.nix
	@echo "{" >> nix-flakes/secrets.nix
	@echo ' 	dev_box_nixos = "$(shell cat ~/.ssh/id_ed25519_dev_box_nixos.pub)";' >> nix-flakes/secrets.nix
	@echo ' 	dev_box_aundre = "$(shell cat ~/.ssh/id_ed25519_dev_box_aundre.pub)";' >> nix-flakes/secrets.nix
	@echo "}" >> nix-flakes/secrets.nix
	cat nix-flakes/secrets.nix

nix-flakes/secrets.nix: 
check-keys-exist:
	@if ! [ -f $(SSH_DEV_BOX_NIXOS_PUB_KEY_F) ]; then \
		ssh-keygen -q -t ed25519 -N '' -f $(SSH_DIR)/$(SSH_DEV_BOX_NIXOS); \
	fi
	@if ! [ -f $(SSH_DEV_BOX_AUNDRE_PUB_KEY_F) ]; then \
		ssh-keygen -q -t ed25519 -N '' -f $(SSH_DIR)/$(SSH_DEV_BOX_AUNDRE); \
	fi

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
