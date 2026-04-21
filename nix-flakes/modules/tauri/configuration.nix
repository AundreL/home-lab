{ config, lib, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        cargo
        rustc
        cargo-tauri
        pkg-config
        wrapGAppsHook4
        bun

        librsvg
        webkitgtk_4_1
    ];
}
