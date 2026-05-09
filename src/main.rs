use clap::error::ErrorKind;
use clap::{CommandFactory, Parser, Subcommand};

#[cfg(not(test))]
use std::process::Command;

#[derive(Parser)]
#[command(name = "ul-util")]
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
            todo!("nix default not implemented");
        }
        Some(NixHostsSubCommands::BuildDevBox {}) => {
            todo!("nix default not implemented");
        }
        Some(NixHostsSubCommands::BuildDevBoxVm {}) => {
            todo!("nix default not implemented");
        }
        _ => {
            panic!("handler_nix_iso: critical error should never reach");
        }
    }
}

fn handler_nix_shells(command: &Option<NixShellsSubCommands>) {
    match command {
        Some(NixShellsSubCommands::StartTauri {}) => {
            todo!("nix default not implemented");
        }
        _ => {
            panic!("handler_nix_iso: critical error should never reach");
        }
    }
}

fn handler_nix(command: &Option<NixSubCommands>) {
    match command {
        Some(NixSubCommands::InitStruct {}) => {
            todo!("nix default not implemented");
        }
        Some(NixSubCommands::ResyncStruct {}) => {
            todo!("nix default not implemented");
        }
        Some(NixSubCommands::CreateSecrets {}) => {
            todo!("nix default not implemented");
        }
        Some(NixSubCommands::Clean {}) => {
            todo!("nix default not implemented");
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

    const PROGRAM_NAME: &str = "hl-util";

    /*
     * project check list
     * current make command     cli command             test-setup     drafted   path_test   mvp_test   complete
     *build-iso-prod            build-iso-prod              X             X         X           X
     *build-nix-iso-dev         build-iso-dev               X             X         X           X
     *build-nix-iso-verbose     build-iso-dev --verbose     X             X         X           X
     *<none>                    nix-hosts                   X             X         X
     *build-dev-wsl-flake       nix-hosts build-dev-wsl     X             X         X
     *build-dev-box-flake       nix-hosts build-dev-box     X             X         X
     *build-dev-box-vm-flake    nix-hosts build-dev-box-vm  X             X         X
     *start-tuari-shell         nix-shells start-tauri      X             X         X
     *<none>                    nix                         X             X         X
     *nix-init-struct(nix)      nix init-struct             X             X         X
     *nix-resync-struct(nix)    nix resync-struct           X             X         X
     *nix-create-secrets        nix create-secrets          X             X         X
     *nix-clean                 nix clean                   X             X         X
     *help                      --help                      X             X         X
     *default                   <none>                      X             X         X
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
