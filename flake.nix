{
    description = "home lab flake configuration";

    inputs = {
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
        home-manager.url = "github:nix-community/home-manager/release-25.11";
        aundre-dotfiles = {
            url = "github:AundreL/dotfiles";
            flake = false;
        };

    };

    outputs =
        {
            self,
            nixpkgs-stable,
            nixpkgs-unstable,
            home-manager,
            aundre-dotfiles,
            ...
        }@inputs:
        let
            system = builtins.currentSystem;
            lib = nixpkgs-stable.lib;
            pkgs-stable = nixpkgs-stable.legacyPackages.${system};
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

            secrets = builtins.fromJSON (builtins.readFile ./secrets.json);

            hl-util = pkgs-stable.rustPlatform.buildRustPackage {
                pname = "hl-util";
                version = "0.0.3";
                src = ./.;

                cargoHash = "sha256-ThS9JFVkKPKpz1/vBYmaBNcCX3NejtRwwuFmw2tI60E=";

                nativeBuildInputs = [ pkgs-stable.openssh ];
                outputs = [
                    "out"
                ];
                meta = {
                    description = "utility tool to manage home lab";
                    homepage = "";
                    license = "";
                };
            };

            defaultModuleArgs = {
                inherit pkgs-unstable; # pass unstable to modules
                inherit pkgs-stable;
                inherit home-manager;
            };

        in
        {
            nixosConfigurations.iso-installer = nixpkgs-stable.lib.nixosSystem {
                system = system;
                specialArgs = defaultModuleArgs;
                modules = [
                    ./nix-flakes/hosts/iso-installer/configuration.nix
                ];
            };

            nixosConfigurations.dev-box = nixpkgs-stable.lib.nixosSystem {
                system = system;
                specialArgs = defaultModuleArgs;
                modules = [
                    ./nix-flakes/configuration.nix
                    ./nix-flakes/hosts/dev-box/hardware-configuration.nix
                    ./nix-flakes/hosts/dev-box/configuration.nix
                    ./nix-flakes/users/aundre/configuration.nix
                ];
            };

            #system for testing configs on vm before using on my main system
            nixosConfigurations.dev-box-vm = nixpkgs-stable.lib.nixosSystem {
                system = system;
                specialArgs = defaultModuleArgs;
                modules = [
                    ./nix-flakes/configuration.nix
                    ./nix-flakes/hosts/kube-node/hardware-configuration.nix
                    ./nix-flakes/hosts/dev-box/configuration.nix
                    ./nix-flakes/users/aundre/configuration.nix
                ];
            };

            nixosConfigurations.dev-wsl = nixpkgs-stable.lib.nixosSystem {
                system = system;
                specialArgs = defaultModuleArgs // {
                    inherit aundre-dotfiles;
                    secrets = secrets;
                    hl-util = hl-util;
                };

                modules = [
                    ./nix-flakes/configuration.nix
                    ./nix-flakes/hosts/dev-wsl/configuration.nix
                    ./nix-flakes/users/aundre/configuration.nix
                ];

            };

            nixosConfigurations.kube-node = nixpkgs-stable.lib.nixosSystem {
                system = system;
                specialArgs = defaultModuleArgs;
                modules = [
                    ./nix-flakes/configuration.nix
                    ./nix-flakes/hosts/kube-node/hardware-configuration.nix
                    ./nix-flakes/hosts/kube-node/configuration.nix
                ];
            };

            devShells.x86_64-linux.tauri = pkgs-stable.mkShell {
                nativeBuildInputs = with pkgs-stable; [
                    pkg-config
                    wrapGAppsHook4
                    cargo
                    cargo-tauri
                    rustc
                    bun
                ];

                buildInputs = with pkgs-stable; [
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
