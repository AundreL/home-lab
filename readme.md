# home-lab
configuration files and documentation for homelab

``` bash
# setup nixos for dev-box
cd home-lab-flakes
sudo nixos-rebuild switch --flake ".#dev-box"
sudo nixos-rebuild switch --flake ".#dev-wsl"
```

# build custom iso
``` bash
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
