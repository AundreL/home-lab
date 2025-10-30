{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    passwordAuthentication  = true;
  };
}
