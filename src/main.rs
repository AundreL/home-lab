use clap::{CommandFactory, Parser, Subcommand};
use std::collections::HashMap;
use std::fs::File;
use std::io::BufReader;

use std::error::Error;
use std::path::PathBuf;
use std::{env, fs};

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
    #[command(about="sync development files to build structure for building home lab", long_about = None)]
    ResyncStruct {},
    #[command(about="clear all build objects to allow for fresh builds", long_about = None)]
    Clean {},
}

struct DebugArgs {
    dry_run: bool,
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
            #[cfg(test)]
            handler_nix_iso_build_iso_prod(DebugArgs { dry_run: true });

            #[cfg(not(test))]
            handler_nix_iso_build_iso_prod(DebugArgs { dry_run: false });
        }

        Some(NixIsoSubCommands::BuildIsoDev { verbose }) => {
            #[cfg(test)]
            handler_nix_iso_build_iso_dev(*verbose, DebugArgs { dry_run: true });

            #[cfg(not(test))]
            handler_nix_iso_build_iso_dev(*verbose, DebugArgs { dry_run: false });
        }
        _ => {
            panic!("handler_nix_iso: critical error should never reach");
        }
    }
}

fn handler_nix_hosts(command: &Option<NixHostsSubCommands>) {
    match command {
        Some(NixHostsSubCommands::BuildDevWsl {}) => {
            #[cfg(test)]
            handler_nix_host_build_dev_wsl(DebugArgs { dry_run: true });

            #[cfg(not(test))]
            {
                handler_nix_resync_struct(DebugArgs { dry_run: false });
                handler_nix_host_build_dev_wsl(DebugArgs { dry_run: false });
            }
        }
        Some(NixHostsSubCommands::BuildDevBox {}) => {
            #[cfg(test)]
            handler_nix_host_build_dev_box(DebugArgs { dry_run: true });

            #[cfg(not(test))]
            {
                handler_nix_resync_struct(DebugArgs { dry_run: false });
                handler_nix_host_build_dev_box(DebugArgs { dry_run: false });
            }
        }
        Some(NixHostsSubCommands::BuildDevBoxVm {}) => {
            #[cfg(test)]
            handler_nix_host_build_dev_box_vm(DebugArgs { dry_run: true });

            #[cfg(not(test))]
            {
                handler_nix_resync_struct(DebugArgs { dry_run: false });
                handler_nix_host_build_dev_box_vm(DebugArgs { dry_run: false });
            }
        }
        _ => {
            panic!("handler_nix_hosts: critical error should never reach");
        }
    }
}

fn handler_nix_shells(command: &Option<NixShellsSubCommands>) {
    match command {
        Some(NixShellsSubCommands::StartTauri {}) => {
            #[cfg(test)]
            handler_nix_shell_tauri(DebugArgs { dry_run: true });

            #[cfg(not(test))]
            handler_nix_shell_tauri(DebugArgs { dry_run: false });
        }
        _ => {
            panic!("handler_nix_shells: critical error should never reach");
        }
    }
}

fn handler_nix(command: &Option<NixSubCommands>) {
    match command {
        Some(NixSubCommands::ResyncStruct {}) => {
            #[cfg(test)]
            handler_nix_resync_struct(DebugArgs { dry_run: true });

            #[cfg(not(test))]
            handler_nix_resync_struct(DebugArgs { dry_run: false });
        }

        Some(NixSubCommands::CreateSecrets {}) => {
            //dry run during tests
            #[cfg(test)]
            handler_create_secrets(DebugArgs { dry_run: true });

            #[cfg(not(test))]
            handler_create_secrets(DebugArgs { dry_run: false });
        }

        Some(NixSubCommands::Clean {}) => {
            #[cfg(test)]
            handler_nix_clean(DebugArgs { dry_run: true });

            #[cfg(not(test))]
            handler_nix_clean(DebugArgs { dry_run: false });
        }
        _ => {
            panic!("handler_nix_iso: critical error should never reach");
        }
    }
}

fn handler_nix_iso_build_iso_prod(debug: DebugArgs) {
    if debug.dry_run {
        return ();
    }

    let shell_command = format!(
        "{} {} {}",
        "nix build --impure",
        "path:nix-flakes\"#nixosConfigurations.iso-installer.config.system.build.isoImage\"",
        "&> build-log-output.txt"
    );

    println!("{}", shell_command);
    Command::new("sh")
        .arg("-c")
        .arg(shell_command)
        .status()
        .expect("failed to execute command");
}

fn handler_nix_iso_build_iso_dev(verbose: bool, debug: DebugArgs) {
    if debug.dry_run {
        return ();
    }

    let nix_command = if verbose {
        "nix build --verbose --impure"
    } else {
        "nix build --impure"
    };

    let shell_command = format!(
        "{} {}",
        nix_command,
        "path:nix-flakes\"#nixosConfigurations.iso-installer.config.system.build.isoImage\"",
    );

    println!("{}", shell_command);
    Command::new("sh")
        .arg("-c")
        .arg(shell_command)
        .status()
        .expect("failed to execute command");
}

fn handler_nix_host_build_dev_wsl(debug: DebugArgs) {
    if debug.dry_run {
        return ();
    }

    Command::new("sh")
        .arg("-c")
        .arg("nixos-rebuild switch --impure --flake path:nix-flakes\"#dev-wsl\"")
        .status()
        .expect("error occured during build-dev-wsl-flake");
}

fn handler_nix_host_build_dev_box(debug: DebugArgs) {
    if debug.dry_run {
        return ();
    }

    Command::new("sh")
        .arg("-c")
        .arg("nixos-rebuild switch --impure --flake path:nix-flakes\"#dev-box\"")
        .status()
        .expect("error occured during build-dev-box-flake");
}

fn handler_nix_host_build_dev_box_vm(debug: DebugArgs) {
    if debug.dry_run {
        return ();
    }

    Command::new("sh")
        .arg("-c")
        .arg("nixos-rebuild switch --impure --flake path:nix-flakes\"#dev-box-vm\"")
        .status()
        .expect("error occured during build-dev-box-vm-flake");
}

fn handler_nix_shell_tauri(debug: DebugArgs) {
    if debug.dry_run {
        return ();
    }

    Command::new("sh")
        .arg("-c")
        .arg("nix develop \".#tuari\"")
        .status()
        .expect("error occured during build-dev-wsl-flake");
}

fn handler_nix_resync_struct(debug: DebugArgs) {
    if debug.dry_run {
        return ();
    }
    Command::new("sh")
                    .arg("-c")
                    .arg("rsync -avh --delete --mkpath --filter=\":- .gitignore\" --exclude=\".git/\" --exclude=\".gitignore\" scripts/ nix-flakes/scripts")
                    .status()
                    .expect("error occured during init-struct");

    Command::new("sh")
                    .arg("-c")
                    .arg("rsync -avh --delete --mkpath --filter=\":- .gitignore\" --exclude=\".git/\" --exclude=\".gitignore\" src/ nix-flakes/src")
                    .status()
                    .expect("error occured during init-struct");

    Command::new("sh")
        .arg("-c")
        .arg("rsync -avz --delete --mkpath Cargo.toml Cargo.lock secrets.json nix-flakes")
        .status()
        .expect("error occured during init-struct");
}

fn handler_create_secrets(debug: DebugArgs) {
    if debug.dry_run {
        return ();
    }

    let _ = manage_secret("github", None);
    let _ = manage_secret("dev_box_nixos", None);
    let _ = manage_secret("dev_box_aundre", None);
    let _ = manage_secret("cluster_node_nixos", None);
    let _ = manage_secret("cluster_node_node", None);
}

fn manage_secret(
    key_name: &str,
    custom_path: Option<PathBuf>,
) -> Result<(String, String), Box<dyn Error>> {
    //create path
    let mut ssh_private_key_location = custom_path.clone().unwrap_or_else(|| {
        env::var_os("HOME")
            .map(PathBuf::from)
            .expect("error getting user home")
    });

    ssh_private_key_location.push(".ssh");

    if let Some(_) = &custom_path {
        let _ = fs::create_dir_all(&ssh_private_key_location);
    }

    ssh_private_key_location.push(format!("id_ed25519_{}", &key_name));

    let mut ssh_public_key_location = ssh_private_key_location.clone();
    ssh_public_key_location.set_extension("pub");

    let sterile_string_for_args: String = ssh_private_key_location
        .clone()
        .into_os_string()
        .into_string()
        .expect("error turning path to string");

    if !ssh_private_key_location.exists() {
        let mut generate_ssh_key = Command::new("ssh-keygen");
        generate_ssh_key.args([
            "-q",
            "-t",
            "ed25519",
            "-N",
            "''",
            "-f",
            &sterile_string_for_args,
        ]);

        match generate_ssh_key.status() {
            Ok(_) => {
                #[cfg(test)]
                println!(" success {:?}", generate_ssh_key);
            }
            Err(error) => {
                eprintln!("error creating key {:?}", generate_ssh_key);
                return Err(Box::new(error));
            }
        }
    }

    let mut path_secrets = custom_path.unwrap_or_else(|| PathBuf::new());
    path_secrets.push("secrets.json");

    let public_key_value = fs::read_to_string(ssh_public_key_location)?;

    let mut ssh_keys: HashMap<String, String> = if path_secrets.exists() {
        let file_secrets = File::open(&path_secrets)?;
        let reader = BufReader::new(file_secrets);
        serde_json::from_reader(reader)?
    } else {
        HashMap::new()
    };

    ssh_keys.insert(
        key_name.to_string(),
        public_key_value.clone().to_string().trim().to_string(),
    );

    if let Some(parent) = path_secrets.parent() {
        fs::create_dir_all(parent)?;
    }

    let output_file = File::create(path_secrets)?;
    let _ = serde_json::to_writer_pretty(output_file, &ssh_keys);

    return Ok((key_name.to_string(), public_key_value));
}

fn handler_nix_clean(debug: DebugArgs) {
    if debug.dry_run {
        return ();
    }

    Command::new("sh")
        .arg("-c")
        .arg("nix-collect-garbage -d")
        .status()
        .expect("error occured during init-struct");
}

#[cfg(test)]
mod tests {
    use super::*;
    use clap::Parser;
    use clap::error::ErrorKind;
    use tempfile::tempdir;

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
    fn test_manage_secret() {
        //setup the test
        let test_key = "test_key";

        let temp_stage = tempdir().expect("error occured creating temp directory");

        let mut expected_ssh_key_private_location = temp_stage.path().to_path_buf();

        expected_ssh_key_private_location.push(".ssh");
        let mut expected_ssh_key_public_location = expected_ssh_key_private_location.clone();

        expected_ssh_key_private_location.push("id_ed25519_test_key");
        expected_ssh_key_public_location.push("id_ed25519_test_key.pub");

        println!("{:?}", expected_ssh_key_public_location);

        let (ssh_key_name, public_key_value) =
            manage_secret(test_key, Some(temp_stage.path().to_path_buf()))
                .expect("error during secret management");

        println!("got past manage_secrets");
        let mut path_secrets = temp_stage.path().to_path_buf();
        path_secrets.push("secrets.json");

        assert!(expected_ssh_key_private_location.exists());
        assert!(expected_ssh_key_public_location.exists());
        assert!(path_secrets.exists());

        let file_secrets = File::open(&path_secrets).expect("failed to open secrets.json");
        let reader = BufReader::new(file_secrets);

        let parsed_json: HashMap<String, String> =
            serde_json::from_reader(reader).expect("failed to parse secrets.json into hashmap");

        assert_eq!(test_key, ssh_key_name);
        assert!(
            parsed_json.contains_key(test_key),
            "missing test_key entry in json file"
        );

        assert_eq!(
            parsed_json.get(test_key).unwrap().to_string(),
            public_key_value.to_string().trim()
        );
        //cleanup after test
        fs::remove_file(expected_ssh_key_public_location)
            .expect("error cleaning up test manage_secret");
        fs::remove_file(expected_ssh_key_private_location)
            .expect("error cleaning up test manage_secret");
        fs::remove_file(&path_secrets).expect("error cleaning up secret");
    }

    #[test]
    fn nix_clean() {
        let args = vec![PROGRAM_NAME, "nix", "clean"];
        let cli = Cli::try_parse_from(args).unwrap();

        hl_util(cli);
    }
}
