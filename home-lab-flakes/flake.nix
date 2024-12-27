{
	description = "home lab flake configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		home-manager.url = "github:nix-community/home-manager";
	};

	outputs = { nixpkgs, ... } @ inputs: 
	let
		pkgs = nixpkgs.legacyPackages.x86_64-linux;
	in
	{
		nixosConfigurations.dev-box = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix ./hosts/dev-box/hardware-configuration.nix ./hosts/dev-box/configuration.nix
			];
		};

		#implement dev-wsl, control-node, worker-node
	};
}
