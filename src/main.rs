use clap::error::ErrorKind;
use clap::{CommandFactory, Parser, Subcommand};

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
    BuildIsoDev {},
}

#[derive(Subcommand)]
#[command(arg_required_else_help = true)]
enum NixHostsSubCommands {
    BuildDevWsl {},
    BuildDevBox {},
    BuildDevBoxVm {},
}

#[derive(Subcommand)]
#[command(arg_required_else_help = true)]
enum NixShellsSubCommands {
    StartTauri {},
}

#[derive(Subcommand)]
#[command(arg_required_else_help = true)]
enum NixSubCommands {
    CreateSecrets {},
    InitStruct {},
    ResyncStruct {},
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
            todo!("nix-hosts default not implemented");
        }
        Some(Commands::NixShells { subcommand }) => {
            todo!("nix-shells default not implemented");
        }
        Some(Commands::Nix { subcommand }) => {
            todo!("nix default not implemented");
        }
        _ => {
            Cli::command().print_help().unwrap();
        }
    }
}

fn handler_nix_iso(command: &Option<NixIsoSubCommands>) {
    match command {
        Some(NixIsoSubCommands::BuildIsoProd {}) => {
            todo!("nix default not implemented");
        }
        Some(NixIsoSubCommands::BuildIsoDev {}) => {
            todo!("nix default not implemented");
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

#[cfg(test)]
mod tests {
    use super::*;
    use clap::Parser;

    const PROGRAM_NAME: &str = "hl-util";

    /*
     * current make command       drafted   path_test   working       complete
     *build-iso-prod                X           X
     *build-nix-iso-dev             X           X
     *build-nix-iso-verbose         X
     *build-dev-wsl-flake           X
     *build-dev-box-flake           X
     *build-dev-box-vm-flake        X
     *start-tuari-shell             X
     *nix-init-struct(nix)          X
     *nix-resync-struct(nix)        X
     *nix-create-secrets            X
     *nix-clean                     X
     *default/help                  X
     *
     */
    #[test]
    fn nix_iso_default() {
        let args = vec![PROGRAM_NAME, "nix-iso"];
        let cli = Cli::try_parse_from(args);

        match &cli {
            Ok(_result) => panic!("critical error unexpected cli parse path"),
            Err(error) => {
                if error.kind() != ErrorKind::DisplayHelpOnMissingArgumentOrSubcommand {
                    panic!(
                        "error_trigger: passed |  expected: DisplayHelpOnMissingArgumentOrSubcommand | got: {}",
                        error
                    );
                }
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
    fn nix_host_dev_wsl() {
        let args = vec![PROGRAM_NAME, "nix-hosts", "build-dev-wsl"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }

    #[test]
    fn nix_host_dev_box() {
        let args = vec![PROGRAM_NAME, "nix-hosts", "build-dev-box"];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command {
            Some(Commands::NixHosts { subcommand }) => match subcommand {
                Some(NixHostsSubCommands::BuildDevBox {}) => {
                    todo!("not implemented");
                }
                _ => {}
            },
            _ => {}
        }
    }

    #[test]
    fn nix_host_dev_box_vm() {
        let args = vec![PROGRAM_NAME, "nix-hosts", "build-dev-box-vm"];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command {
            Some(Commands::NixHosts { subcommand }) => match subcommand {
                Some(NixHostsSubCommands::BuildDevBoxVm {}) => {
                    todo!("not implemented");
                }
                _ => {}
            },
            _ => {}
        }
    }

    #[test]
    fn nix_shell_tauri() {
        let args = vec![PROGRAM_NAME, "nix-shells", "start-tauri"];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command {
            Some(Commands::NixShells { subcommand }) => match subcommand {
                Some(NixShellsSubCommands::StartTauri {}) => {
                    todo!("not implemented");
                }
                _ => {}
            },
            _ => {}
        }
    }

    #[test]
    fn nix_init_struct() {
        let args = vec![PROGRAM_NAME, "nix", "init-struct"];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command {
            Some(Commands::Nix { subcommand }) => match subcommand {
                Some(NixSubCommands::InitStruct {}) => {
                    todo!("not implemented");
                }
                _ => {}
            },
            _ => {}
        }
    }

    #[test]
    fn nix_resync_struct() {
        let args = vec![PROGRAM_NAME, "nix", "resync-struct"];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command {
            Some(Commands::Nix { subcommand }) => match subcommand {
                Some(NixSubCommands::ResyncStruct {}) => {
                    todo!("not implemented");
                }
                _ => {}
            },
            _ => {}
        }
    }

    #[test]
    fn nix_create_secrets() {
        let args = vec![PROGRAM_NAME, "nix", "create-secrets"];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command {
            Some(Commands::Nix { subcommand }) => match subcommand {
                Some(NixSubCommands::CreateSecrets {}) => {
                    todo!("not implemented");
                }
                _ => {}
            },
            _ => {}
        }
    }

    #[test]
    fn nix_clean() {
        let args = vec![PROGRAM_NAME, "nix", "clean"];
        let cli = Cli::try_parse_from(args).unwrap();

        match &cli.command {
            Some(Commands::Nix { subcommand }) => match subcommand {
                Some(NixSubCommands::Clean {}) => {
                    todo!("not implemented");
                }
                _ => {}
            },
            _ => {}
        }
    }
}
