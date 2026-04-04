# home-lab
configuration files and documentation for homelab

``` bash
# setup nixos for dev-box
sudo make build-box-flake
sudo make build-wsl-flake
```

# build custom iso
``` bash
# build custom nixos iso
sudo make build-nix-iso
```

# initial setup installing nixos

``` bash
# copy install file move 
sudo cp /install/configuration /etc/nixos/configuration.nix
```

```bash
# rebuilt nix configuration
sudo nixos-rebuild switch
```
