{
   config,
   lib,
   pkgs-stable,
   pkgs-unstable,
   home-manager,
   secrets,
   ...
}:
let
   iso-utils = derivation {
      name = "iso-utils";
      system = builtins.currentSystem;
      builder = "${pkgs-stable.bash}/bin/bash";
      flake_dir = ../..;
      scripts_dir = ../../scripts;
      args = [
         "-c"
         ''
            export PATH=$PATH:${pkgs-stable.coreutils}/bin

            mkdir -p $out/etc/iso-utils
            mkdir -p $out/bin
            echo $out >&2
            echo $scripts_dir >&2
             
            echo "flake_dir: $flake_dir"
            echo "scripts_dir: $scripts_dir"
            echo "derivation location: $out"

            for file in $scripts_dir/*.sh; do
                echo "loop tracker $file"
                basefile=$(basename -- ''${file%.sh})
                echo "base $basefile"
                cp $file $out/bin/$basefile
                chmod 777 $out/bin/$basefile
            done

            cp -r $flake_dir/. $out/etc/iso-utils/flakes
         ''
      ];
   };

   stable-packages = with pkgs-stable; [
      git
      gnumake
      python3
      eza
      wget
      curl
      neovim
      htop

      iso-utils
   ];

   custom-packages = [
   ];
in
{
   imports = [
      (import "${home-manager}/nixos")
      <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

      # Provide an initial copy of the NixOS channel so that the user
      # doesn't need to run "nix-channel --update" first.
      <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
   ];
   isoImage.makeEfiBootable = true;
   isoImage.makeUsbBootable = false;

   # use the latest Linux kernel
   boot.kernelPackages = pkgs.linuxPackages_latest;
   boot.supportedFilesystems.zfs = false;
   boot.supportedFilesystems.bcachefs = true;
   boot.loader.efi.canTouchEfiVariables = false;

   i18n.supportedLocales = [
      "en_US.UTF-8/UTF-8"
   ];

   i18n.defaultLocale = "en_US.UTF-8";

   nix.settings.experimental-features = [
      "nix-command"
      "flakes"
   ];
   nixpkgs.config.allowUnfree = true;

   security.sudo.wheelNeedsPassword = false;

   users.users.nixos = {
      isNormalUser = true;
      description = "nixos";
      extraGroups = [ "wheel" ];
      shell = pkgs-stable.fish;

      openssh.authorizedKeys.keys = [
         secrets.dev_box_nixos
         secrets.cluster_node_nixos
      ];
   };

   home-manager.users.nixos = {
      home.stateVersion = "25.11";
   };

   environment.etc = {
      "iso-utils" = {
         source = "${iso-utils}/etc/iso-utils/";
      };
   };

   environment.systemPackages = stable-packages ++ custom-packages;

   programs.fish = {
      enable = true;
      interactiveShellInit = ''
         fish_vi_key_bindings
      '';
   };

   services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
         PermitRootLogin = "no";
         PasswordAuthentication = false;
      };
   };

   # This value determines the NixOS release from which the default
   # settings for stateful data, like file locations and database versions
   # on your system were taken. It‘s perfectly fine and recommended to leave
   # this value at the release version of the first install of this system.
   # Before changing this value read the documentation for this option
   # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
   system.stateVersion = "25.11"; # Did you read the comment?
}
