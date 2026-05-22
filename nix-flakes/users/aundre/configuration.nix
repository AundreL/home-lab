# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
    config,
    lib,
    pkgs-stable,
    pkgs-unstable,
    home-manager,
    aundre-dotfiles,
    ...
}:
let
    dotfiles = aundre-dotfiles;
    secrets = import ../../.secrets.nix;
in
{
    imports = [
        (import "${home-manager}/nixos")
    ];

    programs.fish.enable = true;
    programs.starship.enable = true;

    users.users.aundre = builtins.trace "dotfiles location: ${dotfiles}" {
        isNormalUser = true;
        home = "/home/aundre";
        extraGroups = [
            "wheel"
            "networkmanager"
        ];
        shell = pkgs-stable.fish;

        openssh.authorizedKeys.keys = [
            secrets.dev_box_aundre
        ];
    };

    home-manager.users.aundre = {
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

        home.file.".config/fish" = {
            source = dotfiles + /fish;
            recursive = true;
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

        programs.home-manager.enable = true;

        home.stateVersion = "25.11";
    };
}
