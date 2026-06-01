# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
    config,
    lib,
    pkgs-stable,
    pkgs-unstable,
    home-manager,
    hl-util,
    ...
}:
let
    stable-packages = with pkgs-stable; [
        # core cli tool
        # openssh
        git
        coreutils
        gnumake
        gcc
        xclip
        starship

        zsh

        # modern cli tools
        fastfetch
        fd
        ripgrep
        fzf
        yazi
        htop
        bat
        eza
        procs

        python3
        lua
        cargo

        #language interpretors, formatters and lsp

        taplo # toml formatter

        #bash
        shfmt # bash formatter

        #nix
        nil # nix lsp
        nixfmt # nix formatter

        #python
        basedpyright # python lsp
        ruff # python formatter

        #rust
        rust-analyzer # rust lsp
        rustfmt # rust formatter

        lua-language-server # lua lsp
        stylua # lua formatter

    ];

    unstable-packages = with pkgs-unstable; [
        #development tools
        pkgs-unstable.tmux
        pkgs-unstable.neovim
    ];

    custom-packages = [
        hl-util
    ];
in
{
    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    i18n.supportedLocales = [
        "en_US.UTF-8/UTF-8"
    ];

    i18n.defaultLocale = "en_US.UTF-8";

    environment.sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = stable-packages ++ unstable-packages ++ custom-packages;

    services.openssh.enable = true;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .

    # Do not modify or remove this configuation setting, above comment explains why.
    system.stateVersion = "25.11";
}
