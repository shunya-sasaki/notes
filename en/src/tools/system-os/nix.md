# Nix

In this article, we will explore Nix, a powerful package manager and build system that provides reproducible builds and declarative configuration for software environments.

<!-- toc -->

- [📦 Install Nix](#-install-nix)
- [nix-shell: Isolated Development Environments](#nix-shell-isolated-development-environments)
  - [Interactive Shell](#interactive-shell)
  - [Run commands](#run-commands)
  - [shell.nix: Declarative Shells](#shellnix-declarative-shells)
- [nix packages: Finding and Installing Packages](#nix-packages-finding-and-installing-packages)
- [flakes: A New Way to Manage Nix Projects](#flakes-a-new-way-to-manage-nix-projects)
  - [Enable flakes](#enable-flakes)
- [Home manager](#home-manager)
  - [Install home-manager](#install-home-manager)
  - [Update home-manager configuration](#update-home-manager-configuration)
  - [List up installed packages](#list-up-installed-packages)
  - [Change repository](#change-repository)
- [Initialize flake in a project](#initialize-flake-in-a-project)
- [Automatic environment activation with `direnv`](#automatic-environment-activation-with-direnv)
  - [Install direnv](#install-direnv)
  - [Configure direnv with nix in a project](#configure-direnv-with-nix-in-a-project)
- [Project setup](#project-setup)
  - [General](#general)
  - [Rust project](#rust-project)
  - [Python project](#python-project)
  - [Node.js](#nodejs)

<!-- /toc -->

## 📦 Install Nix

To install Nix, run the following command in your terminal:

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

## nix-shell: Isolated Development Environments

Nix provides a powerful tool called `nix-shell` that allows you to create isolated development environments.

### Interactive Shell

To start an interactive shell with specific packages, use the following command:

```sh
nix-shell -p PACKAGE_NAME
```

Replace `PACKAGE_NAME` with the name of the package you want to include in the shell.

### Run commands

You can also use `nix-shell` to run specific commands within the isolated environment without entering an interactive shell:

```sh
nix-shell -p PACKAGE_NAME --run "COMMAND"
```

### shell.nix: Declarative Shells

You can create a `shell.nix` file to define a declarative shell environment. Here is an example:

```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    cowsay
    lolcat
  ];

  GREETING = "Hello, Nix";

  shellHook = ''
    echo $GREETING | cowsay | lolcat
  '';
}
```

## nix packages: Finding and Installing Packages

You can search for packages using the Nix Packages Search website:

👉 [search packages](https://search.nixos.org/packages)

## flakes: A New Way to Manage Nix Projects

Flakes is a new feature in Nix that provides a more structured and reproducible way to manage Nix projects.

### Enable flakes

To enable flakes feature, create `~/.config/nix/nix.conf` as follows:

```conf
extra-experimental-features = nix-command flakes
```

## Home manager

Home Manager is a tool that allows you to manage your user configuration using Nix.
In this section, we will guide you through the installation and configuration of Home Manager.

### Install home-manager

Create `~/.config/home-manager/home.nix` file containing something like:

```nix
{ config, pkgs, ...}:

{
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  home.username = "shun";
  home.homeDirectory = "/Users/shun";
  home.stateVersion = "25.11";
  home.packages = import ./packages.nix { inherit pkgs; };
  programs = import ./programs.nix;
}
```

_packages.nix_:

```nix
{ pkgs }:

with pkgs; [
  # editors
  neovim
  # vcs
  git
  delta
  lazygit
  # communication tools
  slack
  # Development tools 
  zellij
  direnv
  # fonts
  moralerspace-hw
]
```

_programs.nix_:

```nix
{
  home-manager.enable = true;
  zsh.enable = false;
  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
```

After creating the configuration file, run the following to initlize home-manager.

```sh
nix run home-manager/master -- init --switch
```

### Update home-manager configuration

To apply changes made to your home-manager configuration, run the following command:

```sh
home-manager switch
```

If you are using flakes, you can update packages with the following command:

```sh
nix flake update
home-manager switch
```

### List up installed packages

To list up installed packages, run the following:

```sh
home-manager packages
```

### Change repository

In default setting, nix use **unstable** package repository.
If you woluld like to use stable package repository, you need to change the settings in `flake.nix`.
For example, if you woluld like to use a stable version 25.11, you change settings as follows:

_flake.nix_

```diff
  inputs = {
-   nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
+   nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
-     url = "github:nix-community/home-manager";
+     url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }
```

#### URLs for Nix Packages and Home Manager

You can choose the appropriate repository for Nix packages and Home Manager based on your needs.
Here are the URLs for different versions:

| Nix package                               | Home Manager                                    | Explain                                  |
| ----------------------------------------- | ----------------------------------------------- | ---------------------------------------- |
| github:nixos/nixpkgs/nixpkgs-unstable     | github:nix-community/home-manager               | Unstable version                         |
| github:nixos/nixpkgs/nixpkgs-25.11        | github:nix-community/home-manager/release-25.11 | Stable version 25.11 for Linux and MacOS |
| github:nixos/nixpkgs/nixpkgs-25.11-darwin | github:nix-community/home-manager/release-25.11 | Stable version 25.11 for MacOS           |
| github:nixos/nixpkgs/nixos-25.11          | github:nix-community/home-manager/release-25.11 | Stable version 25.11 for NixOS           |

> [!TIP]
> If you prefer to use the latest stable version, you can set the repository to
> `nixos-unstable` for Nix packages and `home-manager` for Home Manager,
> as they will be updated with the latest stable releases.

## Initialize flake in a project

Run the following command to initialize flake, that create `flake.nix`.

```sh
nix flake init
```

You can then define your project dependencies and configurations in the `flake.nix` file.
If you want to activate the development environment defined in the flake automatically,
use `direnv` as the next section describes.

## Automatic environment activation with `direnv`

To automatically activate nix environment when you enter a project directory,
you can use `direnv` in combination with nix.
In this section, we will guide you through the installation and configuration of `direnv` with nix.

### Install direnv

To enable automatic activation of nix environment using direnv, first install direnv:

---

**Option 1: Using Homebrew**:

```sh
brew install direnv
```

---

After installing direnv, add the following line to your shell configuration file (e.g., `~/.bashrc`, `~/.zshrc`, etc.):

```sh
eval "$(direnv hook SHELL_NAME)"
```

For example, if you are using `zsh`, add:

```sh
eval "$(direnv hook zsh)"
```

### Configure direnv with nix in a project

To enable automatically activate nix environment, create `.envrc` at the project root as follows:

```env
use nix
```

After creating the `.envrc` file, run the following command to allow direnv to load the configuration:

```sh
direnv allow
```

## Project setup

### General

First, create `flake.nix` at the project root.

Second, create `.envrc` at the project root as follows:

```env
use flake
```

Finally, run the following command to allow direnv to load the configuration:

```sh
direnv allow
```

After setting up, when you enter the project directory, direnv will automatically activate the nix environment defined in the flake.

### Rust project

_flake.nix_

```nix
{
  description = "Node.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nodeVersion = pkgs.nodejs_22;
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            packages = [
              nodeVersion
              nodeVersion.pkgs.yarn
              nodeVersion.pkgs.pnpm
            ];
            shellHook = ''
              echo "Node.js ${nodeVersion.version} environment"
            '';
          };
      }
    );
}
```

### Python project

_flake.nix_

```nix
{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-python,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonVersion = "pythonVersion";
        python = nixpkgs-python.packages.${system}.${pythonVersion};
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
              packages = [
              python
              pkgs.uv
              ];
              LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
                pkgs.stdenv.cc.cc
                pkgs.zlib
              ];
              shellHook = ''
                echo "Python ${pythonVersion} environment with uv"
                export UV_PYTHON=${python}/bin/python
                if [ ! -d ".venv" ]; then
                    echo "Createing virtual environment..."
                    uv venv
                fi
                source .venv/bin/activate
            '';
          };
      }
    );
}
```

### Node.js

_flake.nix_

```nix
{
  description = "Node.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nodeVersion = pkgs.nodejs_22;
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            packages = [
              nodeVersion
              nodeVersion.pkgs.yarn
              nodeVersion.pkgs.pnpm
            ];
            shellHook = ''
              echo "Node.js ${nodeVersion.version} environment"
            '';
          };
      }
    );
}
```

> [!TIP]
> If you create Next.js project, at first you run
> `nix-shell -p nodejs_<nodeVersion> --run npx create-next-app <project-name>`,
> (e.g., `nix-shell -p nodejs_24 --run npx create-next-app my-next`).
> After creating a project, create 'flake.nix' and '.envrc'
> as above in the project root directory.
