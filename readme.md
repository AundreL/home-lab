# home-lab
configuration files and documentation for homelab

``` bash
    #setup nixos for dev-box
    cd home-lab-flakes
    sudo nixos-rebuild switch --flake ".#dev-box"
```

# initial setup installing nixos

copy install file move 
``` bash
sudo cp /install/configuration /etc/nixos/configuration.nix
```

```bash
sudo nixos-rebuild switch
```
