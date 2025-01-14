{ config, lib, pkgs, ... }: {
    home-manager.users.aundre = {
        programs.neovim.enable = true;
        programs.neovim.defaultEditor = true;

        programs.git = {
            enable = true;
            userName = "Aundre Lattie";
            userEmail = "aundre@gmail.com";
        };
            
        home.file = {
            ".config/nvim" = {
                source = ../../dotfiles/nvim;
                recursive = true;
            };
        };
        
        home.file = {
            ".ssh/config" = {
                source = ../../dotfiles/ssh-config;
            };
        };
            
        home.file = {
            ".config/fish" = {
                source = ../../dotfiles/fish;
                recursive = true;
            };
        };
        
        home.file = {
            ".config/starship.toml" = {
                source = ../../dotfiles/starship.toml;
            };
        };

        home.file = {
            ".config/zellij" = {
                source = ../../dotfiles/zellij;
                recursive = true;
            };
        };
            
        programs.home-manager.enable = true;
        home.stateVersion = "24.05";
    };
}
