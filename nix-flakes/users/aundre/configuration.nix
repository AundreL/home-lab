# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
	home-manager = builtins.fetchTarball {
		url = "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
        sha256 = "16mcnqpcgl3s2frq9if6vb8rpnfkmfxkz5kkkjwlf769wsqqg3i9";
	};

    dotfiles = ../../../dotfiles;
in
{
	imports =
    [
		(import "${home-manager}/nixos")
		<nixos-wsl/modules>
    ];

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
            settings = {
                user.name = "Aundre Lattie";
                user.email = "aundre@gmail.com";
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

		home.stateVersion = "25.11";
	};
}

