{ config, lib, pkgs, ... }:{
    networking.hostName = "dev-wsl";
    time.timeZone = "Canada/Eastern";
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        fish
        starship
        stylua
        kdlfmt
    ];

    programs.fish.enable = true;
    programs.starship.enable = true;

    users.users.aundre = {
        isNormalUser = true;
        home = "/home/aundre";
        extraGroups = [ "wheel" "networkmanager" ]; 
        shell = pkgs.fish;
    };
}
