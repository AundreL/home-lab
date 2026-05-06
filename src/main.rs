use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli{
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    NixIso{
        #[command(subcommand)]
        subcommand:  Option<NixIsoSubCommands>
    },
    NixHosts{
        #[command(subcommand)]
        subcommand:  Option<NixHostsSubCommands>
    },
    NixShells{
        #[command(subcommand)]
        subcommand:  Option<NixShellsSubCommands>
    },
    Nix{
        #[command(subcommand)]
        subcommand:  Option<NixSubCommands>
    },
}

#[derive(Subcommand)]
enum NixIsoSubCommands{
    BuildIsoProd{},
    BuildIsoDev{},
}

#[derive(Subcommand)]
enum NixHostsSubCommands{
    BuildDevWsl{},
    BuildDevBox{},
    BuildDevBoxVm{},
}

#[derive(Subcommand)]
enum NixShellsSubCommands{
    StartTauri{},
}

#[derive(Subcommand)]
enum NixSubCommands{
    CreateSecrets{},
    InitStruct{},
    ResyncStruct{},
    Clean{}
}

fn main() {
    println!("home lab utility");
}

#[cfg(test)]
mod tests{
    use super::*;
    use clap::Parser;
 
    const PROGRAM_NAME:&str = "hl-util";

/*
 * current make command       drafted      working       complete
 *build-iso-prod                X      
 *build-nix-iso-dev             X
 *build-nix-iso-verbose         X
 *build-dev-wsl-flake           X
 *build-dev-box-flake           X
 *build-dev-box-vm-flake        X
 *start-tuari-shell             X
 *nix-init-struct(nix)          X
 *nix-resync-struct(nix)        X
 *nix-create-secrets            X
 *nix-clean                     X
 *default/help
 *
 */
    #[test]
    fn nix_iso_default() {
        let args = vec![ PROGRAM_NAME, "nix-iso" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::NixIso { subcommand }) => {
                assert!( subcommand.is_none() );
                todo!("not implemented");
            }
            _ => {}
        }
    }
     
    #[test]
    fn nix_iso_build_iso_prod() {
        let args = vec![ PROGRAM_NAME, "nix-iso", "build-iso-prod" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::NixIso { subcommand }) => {
                match subcommand{
                    Some(NixIsoSubCommands::BuildIsoProd{}) =>{         
                        todo!("not implemented");
                    }
                    _ => {}
                }
            }
            _ => {}
        }
    }

    #[test]
    fn nix_host_dev_wsl() {
        let args = vec![ PROGRAM_NAME, "nix-hosts", "build-dev-wsl" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::NixHosts { subcommand}) => {
                match subcommand{
                    Some(NixHostsSubCommands::BuildDevWsl {}) => {
                        todo!("not implemented");
                    }
                    _ => {}
                }
            }
            _ => {}
        }
    }

    #[test]
    fn nix_host_dev_box() {
        let args = vec![ PROGRAM_NAME, "nix-hosts", "build-dev-box" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::NixHosts { subcommand }) => {
                match subcommand {
                    Some (NixHostsSubCommands::BuildDevBox {}) =>{
                        todo!("not implemented");
                    }
                    _ => {}
                }
            }
            _ => {}
        }
    }

    #[test]
    fn nix_host_dev_box_vm() {
        let args = vec![ PROGRAM_NAME, "nix-hosts", "build-dev-box-vm" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::NixHosts { subcommand }) => {
                match subcommand {
                    Some (NixHostsSubCommands::BuildDevBoxVm {}) =>{
                        todo!("not implemented");
                    }
                    _ => {}
                }
            }
            _ => {}
        }
    }

    #[test]
    fn nix_shell_tauri(){
        let args = vec![ PROGRAM_NAME, "nix-shells", "start-tauri" ];
        let cli = Cli::try_parse_from(args).unwrap();
        
        match &cli.command{
            Some(Commands::NixShells { subcommand }) => {
                match subcommand {
                    Some (NixShellsSubCommands::StartTauri{}) => {
                        todo!("not implemented");
                    },
                    _ => {}
                }
            },
            _ => {}
        }
    }
    
    #[test]
    fn nix_init_struct() {
        let args = vec![ PROGRAM_NAME, "nix", "init-struct" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::Nix { subcommand }) => {
                match subcommand {
                    Some(NixSubCommands::InitStruct{} ) => {
                        todo!("not implemented");
                    },
                    _ => {}
                }
            },
            _ => {}
        }
    }

    #[test]
    fn nix_resync_struct() {
        let args = vec![ PROGRAM_NAME, "nix", "resync-struct" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::Nix { subcommand }) => {
                match subcommand {
                    Some(NixSubCommands::ResyncStruct{} ) => {
                        todo!("not implemented");
                    },
                    _ => {}
                }
            },
            _ => {}
        }
    }

    #[test]
    fn nix_create_secrets() {
        let args = vec![ PROGRAM_NAME, "nix", "create-secrets" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::Nix { subcommand }) => {
                match subcommand {
                    Some(NixSubCommands::CreateSecrets{} ) => {
                        todo!("not implemented");
                    },
                    _ => {}
                }
            },
            _ => {}
        }
    }

    #[test]
    fn nix_clean() {
        let args = vec![ PROGRAM_NAME, "nix", "clean" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::Nix { subcommand }) => {
                match subcommand {
                    Some(NixSubCommands::Clean{} ) => {
                        todo!("not implemented");
                    },
                    _ => {}
                }
            },
            _ => {}
        }
    }
}
