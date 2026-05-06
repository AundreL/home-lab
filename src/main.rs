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
    DevWslFlake{},
    DevBoxFlake{},
    Nix{},
}

#[derive(Subcommand)]
enum NixIsoSubCommands{
    BuildIsoProd{},
    BuildIsoDev{},
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
 *build-dev-box-vm-flake
 *create-nix-secrets
 *start-tuari-shell
 *init-struct(nix)
 *resync-nix-struct
 *clean-nix
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
    fn dev_wsl_flake() {
        let args = vec![ PROGRAM_NAME, "dev-wsl-flake" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::DevWslFlake {}) => {
               todo!("not implemented");
            }
            _ => {}
        }
    }

    #[test]
    fn dev_box_flake() {
        let args = vec![ PROGRAM_NAME, "dev-box-flake" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::DevBoxFlake {}) => {
               todo!("not implemented");
            }
            _ => {}
        }
    }

    #[test]
    fn nix() {
        let args = vec![ PROGRAM_NAME, "nix" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::Nix {}) => {
               todo!("not implemented");
            }
            _ => {}
        }
    }
}
