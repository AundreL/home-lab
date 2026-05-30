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
    imports = [
        <nixos-wsl/modules>
    ];

    networking.hostName = "dev-wsl";
    time.timeZone = "Canada/Eastern";

    wsl.enable = true;

    # run this sequence after to resolve erorr that occurs when you change default user
    # wsl -t nixos
    # wsl -d nixos --user root exit
    # wsl -t nixos
    wsl.defaultUser = "aundre";
}
