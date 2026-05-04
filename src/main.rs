use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli{
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    NixIso{},
    DevWslFlake{},
    DevBoxFlake{},
    Nix{},
}

fn main() {
    println!("home lab utility");
}

#[cfg(test)]
mod tests{
    use super::*;
    use clap::Parser;
 
    const PROGRAM_NAME:&str = "hl-util";
    
    #[test]
    fn nix_iso_default() {
        let args = vec![ PROGRAM_NAME, "nix-iso" ];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command{
            Some(Commands::NixIso {}) => {
               todo!("not implemented");
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
