{ config, pkgs, ... }:
let
    setup-script = (builtins.readFile ./setup.sh);
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
    
    environment.etc."/home/nixost/setup.sh" = {
        mode = "0770";
        text = setup-script;
    };

    environment.systemPackages = with pkgs; [
        git
        fish
        neovim
        wget
        curl
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
