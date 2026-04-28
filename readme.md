# home-lab
configuration files and documentation for homelab

``` bash
# commands to run to update fully installed systems
sudo make build-box-flake

# install NixOS wsl first
# https://github.com/nix-community/NixOS-WSL
sudo make build-wsl-flake
```

# build custom iso
``` bash
# build custom nixos iso
sudo make build-nix-iso-prod
```

# custom nixos iso live disk tools
``` bash
# once the live disk reaches command line run tool to install system
# said system
init-dev-box
init-kube-node

# these and commands only used during testing 
nix-cleanup
nixos-desk-setup
```
