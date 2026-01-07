{ config, pkgs, lib, ... }:
let 
    iso-utils = builtins.trace "iso-utils derivation" derivation {
        name = "iso-utils";
        system = builtins.currentSystem;
        builder = "${pkgs.bash}/bin/bash";
        flake_dir = ../..;
        scripts_dir = ../../../scripts;
        dotfiles_dir = ../../../dotfiles;
        args = [
            "-c"
            ''
                export PATH=$PATH:${pkgs.coreutils}/bin
                
                mkdir -p $out/etc/iso-utils

                echo $out >&2
                echo $scripts_dir >&2
                 
                cp -r $scripts_dir/. $out/bin/
                chmod -R 777 $out/bin/
                
                echo "testing"
                echo $out
                
                for x in {1..3}; do
                    echo "here";
                done

                for file in $scripts_dir/.; do
                    echo "''$file"
                    #cp "''$file" "$out/bin/''$file"
                    #chmod 770 $out/bin/''$file
                done
                 

                mkdir -p $out/etc/iso-utils/flakes
                cp -r $flake_dir/. $out/etc/iso-utils/flakes

                mkdir -p $out/etc/iso-utils/dotfiles
                cp -r $dotfiles_dir/. $out/etc/iso-utils/dotfiles
                cp -r $dotfiles_dir/. $out/etc/iso-utils/flakes/dotfiles
            ''
        ];
    };

in
{
    imports = [
        <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
        <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ];
     
    i18n.supportedLocales = [
        "en_US.UTF-8/UTF-8"
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    security.sudo.wheelNeedsPassword = false;

    users.users.nixos = {
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFqIYjjH05wl+tQj1YRIw481RZqFGIMmCrEKINSZI8k/ aundre@dev-wsl"
        ];

        isNormalUser = true;
        description = "nixos";
        extraGroups = [ "wheel" ];
        initialPassword = "admin";
        shell = pkgs.fish;

        packages = with pkgs; [];
    };
 
    environment.etc = {
        "iso-utils" = {
            source = "${iso-utils}/etc/iso-utils/";
        };
    };
    
    environment.systemPackages = with pkgs; [
        git
        gnumake
        python3
        tree
        wget
        curl
        fish
        neovim
        iso-utils
    ];

    programs.fish.enable = true;
  
    services.openssh = {
        enable = true;
        ports = [ 22 ];
        passwordAuthentication = true;
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?
}
