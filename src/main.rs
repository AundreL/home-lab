use clap::{CommandFactory, Parser, Subcommand};
use std::env;
use std::fs;
use std::io;

#[cfg(not(test))]
use std::process::Command;

#[derive(Parser)]
#[command(name = "hl-util")]
#[command(version, about, long_about = None)]
#[command(propagate_version = true)]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    NixIso {
        #[command(subcommand)]
        subcommand: Option<NixIsoSubCommands>,
    },
    NixHosts {
        #[command(subcommand)]
        subcommand: Option<NixHostsSubCommands>,
    },
    NixShells {
        #[command(subcommand)]
        subcommand: Option<NixShellsSubCommands>,
    },
    Nix {
        #[command(subcommand)]
        subcommand: Option<NixSubCommands>,
    },
}

#[derive(Subcommand)]
#[command(arg_required_else_help = true)]
enum NixIsoSubCommands {
    #[command(about="build iso prod", long_about = None)]
    BuildIsoProd {},
    #[command(about="build iso dev", long_about = None)]
    BuildIsoDev {
        #[arg(long)]
        verbose: bool,
    },
}

#[derive(Subcommand)]
#[command(arg_required_else_help = true)]
enum NixHostsSubCommands {
    #[command(about="build dev wsl flake", long_about = None)]
    BuildDevWsl {},
    #[command(about="build dev dev box flake", long_about = None)]
    BuildDevBox {},
    #[command(about="build dev box vm flake", long_about = None)]
    BuildDevBoxVm {},
}

#[derive(Subcommand)]
#[command(arg_required_else_help = true)]
enum NixShellsSubCommands {
    #[command(about="start a nix shell for tauri development", long_about = None)]
    StartTauri {},
}

#[derive(Subcommand)]
#[command(arg_required_else_help = true)]
enum NixSubCommands {
    #[command(about="create/initialize secrets for home lab", long_about = None)]
    CreateSecrets {},
    #[command(about="initialize folder structure for building home lab", long_about = None)]
    InitStruct {},
    #[command(about="sync development files to build structure for building home lab", long_about = None)]
    ResyncStruct {},
    #[command(about="clear all build objects to allow for fresh builds", long_about = None)]
    Clean {},
}

fn main() {
    let cli = Cli::parse();
    hl_util(cli);
}

fn hl_util(cli: Cli) {
    match &cli.command {
        Some(Commands::NixIso { subcommand }) => {
            handler_nix_iso(subcommand);
        }
        Some(Commands::NixHosts { subcommand }) => {
            handler_nix_hosts(subcommand);
        }
        Some(Commands::NixShells { subcommand }) => {
            handler_nix_shells(subcommand);
        }
        Some(Commands::Nix { subcommand }) => {
            handler_nix(subcommand);
        }
        _ => {
            Cli::command().print_help().unwrap();
        }
    }
}

fn handler_nix_iso(command: &Option<NixIsoSubCommands>) {
    match command {
        Some(NixIsoSubCommands::BuildIsoProd {}) => {
            #[cfg(not(test))]
            {
                let shell_command = format!(
                    "{} {} {}",
                    "nix build --impure",
                    "path:nix-flakes/\".#nixosConfigurations.iso-installer.config.system.build.isoImage\"",
                    "&> build-log-output.txt"
                );

                println!("{}", shell_command);
                Command::new("sh")
                    .arg("-c")
                    .arg(shell_command)
                    .status()
                    .expect("failed to execute command");
            }
        }
        Some(NixIsoSubCommands::BuildIsoDev { verbose }) => {
            #[cfg(not(test))]
            {
                #![allow(unused)]
                let mut nix_command = "";

                if *verbose == true {
                    nix_command = "nix build --verbose --impure";
                } else {
                    nix_command = "nix build --impure";
                }

                let shell_command = format!(
                    "{} {}",
                    nix_command,
                    "path:nix-flakes/\".#nixosConfigurations.iso-installer.config.system.build.isoImage\"",
                );

                Command::new("sh")
                    .arg("-c")
                    .arg(shell_command)
                    .status()
                    .expect("failed to execute command");
            }
        }
        _ => {
            panic!("handler_nix_iso: critical error should never reach");
        }
    }
}

fn handler_nix_hosts(command: &Option<NixHostsSubCommands>) {
    match command {
        Some(NixHostsSubCommands::BuildDevWsl {}) => {
            #[cfg(not(test))]
            Command::new("sh")
                .arg("-c")
                .arg("nixos-rebuild switch --impure --flake path:nix-flakes/\"#dev-wsl\"")
                .status()
                .expect("error occured during build-dev-wsl-flake");
        }
        Some(NixHostsSubCommands::BuildDevBox {}) => {
            #[cfg(not(test))]
            Command::new("sh")
                .arg("-c")
                .arg("nixos-rebuild switch --impure --flake path:nix-flakes/\"#dev-box\"")
                .status()
                .expect("error occured during build-dev-box-flake");
        }
        Some(NixHostsSubCommands::BuildDevBoxVm {}) => {
            #[cfg(not(test))]
            Command::new("sh")
                .arg("-c")
                .arg("nixos-rebuild switch --impure --flake path:nix-flakes/\"#dev-box-vm\"")
                .status()
                .expect("error occured during build-dev-box-vm-flake");
        }
        _ => {
            panic!("handler_nix_hosts: critical error should never reach");
        }
    }
}

fn handler_nix_shells(command: &Option<NixShellsSubCommands>) {
    match command {
        Some(NixShellsSubCommands::StartTauri {}) => {
            #[cfg(not(test))]
            Command::new("sh")
                .arg("-c")
                .arg("nix develop nix-flakes/\".#tuari\"")
                .status()
                .expect("error occured during build-dev-wsl-flake");
        }
        _ => {
            panic!("handler_nix_shells: critical error should never reach");
        }
    }
}

fn handler_nix(command: &Option<NixSubCommands>) {
    match command {
        Some(NixSubCommands::InitStruct {}) => {
            #[cfg(not(test))]
            {
                Command::new("sh")
                    .arg("-c")
                    .arg("cp -r scripts/ nix-flakes")
                    .status()
                    .expect("error occured during init-struct");

                Command::new("sh")
                    .arg("-c")
                    .arg("cp -r dotfiles/ nix-flakes")
                    .status()
                    .expect("error occured during init-struct");
            }
        }
        Some(NixSubCommands::ResyncStruct {}) => {
            #[cfg(not(test))]
            {
                Command::new("sh")
                    .arg("-c")
                    .arg("rsync -avh --delete scripts/ nix-flakes/scripts")
                    .status()
                    .expect("error occured during init-struct");

                Command::new("sh")
                    .arg("-c")
                    .arg("rsync -avh --delete dotfiles/ nix-flakes/dotfiles")
                    .status()
                    .expect("error occured during init-struct");
            }
        }
        Some(NixSubCommands::CreateSecrets {}) => {
            match fs::remove_file("nix-flakes/secrets.nix") {
                Ok(_) => {
                    println!("remove secrets.nix");
                }
                Err(e) if e.kind() == io::ErrorKind::NotFound => {
                    println!("no file to delete");
                }
                Err(_) => panic!("critical error during secrets.nix deletion"),
            }
            let home_drive = env::var("HOME").expect("unable to detect homedrive");

            let dev_box_nixos_public_key_location =
                format!("{}/.ssh/id_ed25519_dev_box_nixos.pub", home_drive);

            let dev_box_aundre_public_key_location =
                format!("{}/.ssh/id_ed25519_dev_box_aundre.pub", home_drive);

            let dev_box_nixos_public_key_content =
                fs::read_to_string(dev_box_nixos_public_key_location).expect("error loading file");

            let dev_box_aundre_public_key_content =
                fs::read_to_string(dev_box_aundre_public_key_location).expect("error loading file");

            let l1 = format!(
                "dev_box_nixos = \"{}\";",
                dev_box_nixos_public_key_content.trim()
            );
            let l2 = format!(
                "dev_box_aundre = \"{}\";",
                dev_box_aundre_public_key_content.trim()
            );
            let secrets_nix_contents = format!("{{\n\t{}\n\t{}\n}}\n", l1, l2);

            fs::write("nix-flakes/.secrets.nix", secrets_nix_contents)
                .expect("had issue writing to file");
        }
        Some(NixSubCommands::Clean {}) => {
            #[cfg(not(test))]
            Command::new("sh")
                .arg("-c")
                .arg("nix-collect-garbage -d")
                .status()
                .expect("error occured during init-struct");
        }
        _ => {
            panic!("handler_nix_iso: critical error should never reach");
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use clap::Parser;
    use clap::error::ErrorKind;

    const PROGRAM_NAME: &str = "hl-util";

    /*
     * project check list
     * current make command     cli command             test-setup     drafted   path_test   mvp_test   complete
     *build-iso-prod            build-iso-prod              X             X         X           X
     *build-nix-iso-dev         build-iso-dev               X             X         X           X
     *build-nix-iso-verbose     build-iso-dev --verbose     X             X         X           X
     *<none>                    nix-hosts                   X             X         X           X
     *build-dev-wsl-flake       nix-hosts build-dev-wsl     X             X         X           X
     *build-dev-box-flake       nix-hosts build-dev-box     X             X         X           X
     *build-dev-box-vm-flake    nix-hosts build-dev-box-vm  X             X         X           X
     *start-tuari-shell         nix-shells start-tauri      X             X         X           X
     *<none>                    nix                         X             X         X           X
     *nix-init-struct(nix)      nix init-struct             X             X         X           X
     *nix-resync-struct(nix)    nix resync-struct           X             X         X           X
     *nix-create-secrets        nix create-secrets          X             X         X           X
     *nix-clean                 nix clean                   X             X         X           X
     *help                      --help                      X             X         X           X
     *default                   <none>                      X             X         X           X
     */

    #[test]
    fn default() {
        let args = vec![PROGRAM_NAME];
        let cli = Cli::try_parse_from(args);

        match &cli {
            Ok(_result) => println!("should get here"),
            Err(error) => panic!("unexpected error {}", error),
        }
    }

    #[test]
    fn help() {
        let args = vec![PROGRAM_NAME, "--help"];
        let cli = Cli::try_parse_from(args);

        match &cli {
            Ok(_result) => println!("should get here"),
            Err(error) => assert_eq!(error.kind(), ErrorKind::DisplayHelp),
        }
    }

    #[test]
    fn nix_iso_default() {
        let args = vec![PROGRAM_NAME, "nix-iso"];
        let cli = Cli::try_parse_from(args);

        match &cli {
            Ok(_result) => panic!("critical error unexpected cli parse path"),
            Err(error) => {
                assert_eq!(
                    error.kind(),
                    ErrorKind::DisplayHelpOnMissingArgumentOrSubcommand
                );
            }
        }
    }

    #[test]
    fn nix_iso_build_iso_invalid_subcommand() {
        let args = vec![PROGRAM_NAME, "nix-iso", "does-not-exist"];
        let cli = Cli::try_parse_from(args);

        match &cli {
            Ok(_result) => panic!("critical error unexpected cli parse path"),
            Err(error) => {
                if error.kind() != ErrorKind::InvalidSubcommand {
                    panic!(
                        "error_trigger: passed |  expected: DisplayHelpOnMissingArgumentOrSubcommand | got: {}",
                        error
                    );
                }
            }
        }
    }

    #[test]
    fn nix_iso_build_iso_prod() {
        let args = vec![PROGRAM_NAME, "nix-iso", "build-iso-prod"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_iso_build_dev() {
        let args = vec![PROGRAM_NAME, "nix-iso", "build-iso-dev"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_iso_build_dev_verbose() {
        let args = vec![PROGRAM_NAME, "nix-iso", "build-iso-dev", "--verbose"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_host_default() {
        let args = vec![PROGRAM_NAME, "nix-hosts"];
        let cli = Cli::try_parse_from(args);

        match &cli {
            Ok(_result) => panic!("critical error unexpected cli parse path"),
            Err(error) => {
                assert_eq!(
                    error.kind(),
                    ErrorKind::DisplayHelpOnMissingArgumentOrSubcommand
                );
            }
        }
    }

    #[test]
    fn nix_host_dev_wsl() {
        let args = vec![PROGRAM_NAME, "nix-hosts", "build-dev-wsl"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_host_dev_box() {
        let args = vec![PROGRAM_NAME, "nix-hosts", "build-dev-box"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_host_dev_box_vm() {
        let args = vec![PROGRAM_NAME, "nix-hosts", "build-dev-box-vm"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_shell_tauri() {
        let args = vec![PROGRAM_NAME, "nix-shells", "start-tauri"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_default() {
        let args = vec![PROGRAM_NAME, "nix"];
        let cli = Cli::try_parse_from(args);

        match &cli {
            Ok(_result) => panic!("critical error unexpected cli parse path"),
            Err(error) => {
                assert_eq!(
                    error.kind(),
                    ErrorKind::DisplayHelpOnMissingArgumentOrSubcommand
                );
            }
        }
    }

    #[test]
    fn nix_init_struct() {
        let args = vec![PROGRAM_NAME, "nix", "init-struct"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_resync_struct() {
        let args = vec![PROGRAM_NAME, "nix", "resync-struct"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_create_secrets() {
        let args = vec![PROGRAM_NAME, "nix", "create-secrets"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_clean() {
        let args = vec![PROGRAM_NAME, "nix", "clean"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }
}
