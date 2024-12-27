# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
	home-manager = builtins.fetchTarball {
		url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
		sha256 = "0b41b251gxbrfrqplp2dkxv00x8ls5x5b3n5izs4nxkcbhkjjadz";

	};
in
{
	imports =
    [
		(import "${home-manager}/nixos")
    ];
  
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nixpkgs.config.allowUnfree = true;

	networking.hostName = "nixos";
	time.timeZone = "Canada/Eastern";

	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = false;


	environment.systemPackages = with pkgs; [
		fish
		starship
		tree
		git
		gnumake
	];
  
	programs.fish.enable = true;
	programs.starship.enable = true;

	programs.neovim = {
    	enable = true;
		defaultEditor = true;
	};

	services.openssh.enable = true;

	users.users.aundre = {
		isNormalUser = true;
		home = "/home/aundre";
		extraGroups = [ "wheel" "networkmanager" ]; 
		shell = pkgs.fish;
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
	system.stateVersion = "24.11";
}

