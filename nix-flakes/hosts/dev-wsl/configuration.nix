# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{    
    networking.hostName = "dev-wsl";
	wsl.enable = true;
    
    environment.systemPackages = with pkgs; [
    ];
    
    environment.variables = {
        LD_LIBRARY_PATH = "${pkgs.librsvg}/lib:${pkgs.webkitgtk_4_1}/lib:$LD_LIBRARY_PATH";
        PKG_CONFIG_PATH = "${pkgs.webkitgtk_4_1}/lib:$PKG_CONFIG_PATH";
    };
    # run this sequence after to resolve erorr that occurs when you change default user
    # wsl -t nixos
    # wsl -d nixos --user root exit
    # wsl -t nixos
	wsl.defaultUser = "aundre";	
}

