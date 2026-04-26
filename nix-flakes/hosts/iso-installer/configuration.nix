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
                mkdir -p $out/bin
                echo $out >&2
                echo $scripts_dir >&2
                 
                #cp -r $scripts_dir/. $out/bin/
                #chmod -R 777 $out/bin/
                
                echo "testing"
                echo "out $out"
                
                for file in $scripts_dir/*.sh; do
                    echo "loop tracker $file"
                    basefile=$(basename -- ''${file%.sh})
                    echo "base $basefile"
                    cp $file $out/bin/$basefile
                    chmod 777 $out/bin/$basefile
                done
                 
                mkdir -p $out/etc/iso-utils/flakes
                cp -r $flake_dir/. $out/etc/iso-utils/flakes

                mkdir -p $out/etc/iso-utils/dotfiles
                cp -r $dotfiles_dir/. $out/etc/iso-utils/dotfiles
                cp -r $dotfiles_dir/. $out/etc/iso-utils/flakes/dotfiles
            ''
        ];
    };
    
    secrets.dir = builtins.trace "secrets derivation" derivation {
        name = "secrets";
        system = builtins.currentSystem;
        builder = "${pkgs.bash}/bin/bash";
        args = [
            "-c"
            ''
                export PATH=$PATH:${pkgs.coreutils}/bin:${pkgs.openssh}/bin
                mkdir -p $out
                ssh-keygen -q -t ed25519 -N '''''' -f $out/id_ed25519
                chmod 600 $out/id_ed25519
                chmod 600 $out/id_ed25519.pub
            ''
        ];
    };
    
    secrets.private-key = secrets.dir + /id_ed25519;
    secrets.public-key = secrets.dir + /id_ed25519.pub;
    
    home-manager = builtins.fetchTarball {
        url = "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
        sha256 = "16mcnqpcgl3s2frq9if6vb8rpnfkmfxkz5kkkjwlf769wsqqg3i9";
    };

    auth-contents = builtins.trace "secret location ${secrets.dir}" ( builtins.readFile (secrets.public-key) );
in
{
    imports = [
        (import "${home-manager}/nixos")
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
        isNormalUser = true;
        description = "nixos";
        extraGroups = [ "wheel" ];
        shell = pkgs.fish;

        openssh.authorizedKeys.keys = [
            auth-contents
        ];
        packages = with pkgs; [];
    };
    
    home-manager.users.nixos = {
        home.stateVersion = "25.11";
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
        neovim
        iso-utils
        secrets.dir
    ];

    programs.fish = {
        enable = true;
        interactiveShellInit = ''
            fish_vi_key_bindings
        '';
    };
  
    services.openssh = {
        enable = true;
        ports = [ 22 ];
        settings.PasswordAuthentication = false;
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?
}
