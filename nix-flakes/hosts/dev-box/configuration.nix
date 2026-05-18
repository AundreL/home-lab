# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
    config,
    lib,
    pkgs,
    ...
}:
{
    # Use the systemd-boot EFI boot loader.
    boot.loader.efi.canTouchEfiVariables = false;
    boot.loader.systemd-boot.enable = true;

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    networking.hostName = "dev-box";
    time.timeZone = "Canada/Eastern";

    i18n.supportedLocales = [
        "en_US.UTF-8/UTF-8"
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    nixpkgs.config.allowUnfree = true;
    security.sudo.wheelNeedsPassword = true;

    environment.systemPackages = with pkgs; [
        fish
        starship
        kdlfmt
    ];

    services.openssh = {
        enable = true;
        ports = [ 22 ];
        settings.PasswordAuthentication = false;
    };
}
