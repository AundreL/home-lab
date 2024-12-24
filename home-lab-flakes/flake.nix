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
			modules = [
				./configuration.nix
			];
		};

		packages.x86_64-linux.hello = pkgs.hello;
		packages.x86_64-linux.default = pkgs.hello;
	
		devShells.x86_64-linux.default = pkgs.mkShell {
			buildInputs = [ pkgs.neovim pkgs.vim ];
		};
	};
}
