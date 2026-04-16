# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
	home-manager = builtins.fetchTarball {
		url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
		sha256 = "07pk5m6mxi666dclaxdwf7xrinifv01vvgxn49bjr8rsbh31syaq";
	};
in
{
	imports =
    [
		(import "${home-manager}/nixos")
		<nixos-wsl/modules>
    ];
    
    networking.hostName = "dev-wsl";
	wsl.enable = true;
    
    environment.systemPackages = with pkgs; [
        cargo
        rustup
        cargo-tauri
        pkg-config
        wrapGAppsHook4
        bun
        librsvg
        webkitgtk_4_1
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

