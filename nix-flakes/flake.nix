{
	description = "home lab flake configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
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
        
        nixosConfigurations.dev-wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./configuration.nix ./hosts/dev-wsl/configuration.nix ./defaults/env-defaults.nix ./defaults/home-manager.nix
            ];
        };

        nixosConfigurations.iso-installer = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hosts/iso-installer/configuration.nix
            ];
        };

        #implement control-node, worker-node
	};
}
