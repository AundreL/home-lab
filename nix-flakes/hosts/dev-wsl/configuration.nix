# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
	home-manager = builtins.fetchTarball {
		url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
		sha256 = "00wp0s9b5nm5rsbwpc1wzfrkyxxmqjwsc1kcibjdbfkh69arcpsn";
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
    
    # run this sequence after to resolve erorr that occurs when you change default user
    # wsl -t nixos
    # wsl -d nixos --user root exit
    # wsl -t nixos
	wsl.defaultUser = "aundre";
	
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

