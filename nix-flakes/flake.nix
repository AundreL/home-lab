{
	description = "home lab flake configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
	};

	outputs = { self, nixpkgs, ... } @ inputs: 
	let
		pkgs = nixpkgs.legacyPackages.x86_64-linux;
	in
	{
        nixosConfigurations.iso-installer = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hosts/iso-installer/configuration.nix
            ];
        };

		nixosConfigurations.dev-box = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix ./hosts/dev-box/hardware-configuration.nix 
                ./hosts/dev-box/configuration.nix ./users/aundre/configuration.nix
			];
		};
  
        nixosConfigurations.dev-wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./configuration.nix ./hosts/dev-wsl/configuration.nix
                ./users/aundre/configuration.nix
            ];

        };
        
        nixosConfigurations.kube-node = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./configuration.nix ./hosts/kube-node/hardware-configuration.nix
                ./hosts/kube-node/configuration.nix
            ];
        };

       #implement control-node, worker-node

        devShells.x86_64-linux.tauri = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
                pkg-config
                wrapGAppsHook4
                cargo
                cargo-tauri
                rustc
                bun
            ];

            buildInputs = with pkgs; [
                nodePackages."@angular/cli"
                librsvg
                webkitgtk_4_1
            ];

            shellHook = ''
                echo "starting tauri shell"
                export XDG_DATA_DIRS="$GSETTINGS_SCHEMAS_PATH" # Needed on Wayland to report the correct display scale
            '';
        };
	};
}
