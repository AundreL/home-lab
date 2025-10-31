# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
	home-manager = builtins.fetchTarball {
<<<<<<< HEAD
		url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
		sha256 = "1vklmr0vzhplcjcqg19v66c1swg3xcgw96ry90dyd4hl2cb9j80b";
=======
		url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
		sha256 = "12chczw73y3gxsl3mic69fp3m3inp1z5f71pnbrrbhx8668wcly3";
>>>>>>> release-0.0.3

	};
in
{
	imports =
    [
		(import "${home-manager}/nixos")
    ];
  
	# Use the systemd-boot EFI boot loader.
	boot.loader.efi.canTouchEfiVariables = false;
	boot.loader.systemd-boot.enable = true;
	
	networking.hostName = "dev-box";
	time.timeZone = "Canada/Eastern";
	
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = with pkgs; [
		fish
		starship
        stylua
        kdlfmt
        cargo
        rustup
	];
  
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
		};
		
		home.file = {
			".config/nvim" = {
				source = ../../../dotfiles/nvim;
				recursive = true;
			};
		};
		
		home.file = {
			".ssh/config" = {
				source = ../../../dotfiles/ssh-config;
			};
		};
		
		home.file = {
			".config/fish" = {
				source = ../../../dotfiles/fish;
				recursive = true;
			};
		};
		
		home.file = {
			".config/starship.toml" = {
				source = ../../../dotfiles/starship.toml;
			};
		};

		home.file = {
			".config/zellij" = {
				source = ../../../dotfiles/zellij;
				recursive = true;
			};
		};
		
		programs.home-manager.enable = true;

		home.stateVersion = "24.11";
	};
	# This option defines the first version of NixOS you have installed on this particular machine,
	# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
	#
	# Most users should NEVER change this value after the initial install, for any reason,
	# even if you've upgraded your system to a new NixOS release.
	#
	# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
	# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
	# to actually do that.
	#
	# This value being lower than the current NixOS release does NOT mean your system is
	# out of date, out of support, or vulnerable.
	# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
	# and migrated your data accordingly.
	#
	# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion . 

	# Do not modify or remove this configuation setting, above comment explains why.
	system.stateVersion = "24.05";
}

