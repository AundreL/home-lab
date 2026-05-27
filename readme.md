# Home Laboratory
Configuration files and documentation for homelab.

## Boot Strap WSL

``` bash
    nix-shell -p git openssh cargo
    ssh-keygen -t ed25519 -C "<example@gmail.com>"
    
    # add to authrized keys on github
    cat ~./ssh/id_ed25519.pub
    git clone git@github.com:AundreL/home-lab.git

    echo "{}" >> nix-flakes/.secrets.nix
    cargo run nix-hosts build-dev-wsl
```

## Update Installed System
``` bash
# commands to run to update fully installed systems
sudo make build-dev-box-flake

# install NixOS wsl first
# https://github.com/nix-community/NixOS-WSL
sudo make build-wsl-flake
```

## Build New Custom NixOS ISO
``` bash
# build custom nixos iso
sudo make build-nix-iso-prod
```

## Custom NixOS ISO Live Disk Tools
``` bash
# once the live disk reaches command line 
# run tool to install system
# use the command based on the system
init-dev-box
init-dev-box-vm
init-kube-node

# commands only used during testing 
nix-cleanup
nixos-desk-setup
```
