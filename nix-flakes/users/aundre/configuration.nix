# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
    dotfiles = ../../../dotfiles;
in
{ 	
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nixpkgs.config.allowUnfree = true;
  
	programs.fish.enable = true;
	programs.starship.enable = true;

	users.users.aundre = {
		isNormalUser = true;
		home = "/home/aundre";
		extraGroups = [ "wheel" "networkmanager" ]; 
		shell = pkgs.fish;
	};
	
	home-manager.users.aundre = {
		programs.neovim.enable = true;
		programs.neovim.defaultEditor = true;

		programs.git = {
			enable = true;
			userName = "Aundre Lattie";
			userEmail = "aundre@gmail.com";
            
            extraConfig = {
                core.editor = "nvim";
            };
		};
		
		home.file = {
			".config/nvim" = {
				source = dotfiles + /nvim;
				recursive = true;
			};
		};
		
		home.file = {
			".ssh/config" = {
				source = dotfiles + /ssh-config;
			};
		};
		
		home.file = {
			".config/fish" = {
				source = dotfiles + /fish;
				recursive = true;
			};
		};
		
		home.file = {
			".config/starship.toml" = {
				source = dotfiles + /starship.toml;
			};
		};
        
        home.file = {
            ".tmux.conf" = {
                source = dotfiles + /tmux/tmux.conf;
            };
        };

		home.file = {
			".config/zellij" = {
				source = dotfiles + /zellij;
				recursive = true;
			};
		};
		
		programs.home-manager.enable = true;

		home.stateVersion = "25.05";
	};
}

