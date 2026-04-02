# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
	# Use the systemd-boot EFI boot loader.
	boot.loader.efi.canTouchEfiVariables = false;
	boot.loader.systemd-boot.enable = true;
	
	networking.hostName = "dev-box";
	time.timeZone = "Canada/Eastern";
	
	environment.systemPackages = with pkgs; [
		fish
		starship
        cargo
        rustup
        kdlfmt
   ];
  
    programs.fish.enable = true;
    programs.starship.enable = true;
}

