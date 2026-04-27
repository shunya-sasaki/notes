# Nix

この記事では、再現可能なビルドとソフトウェア環境の宣言的な構成を提供する強力なパッケージマネージャー兼ビルドシステムであるNixについて解説します。

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

Nixをインストールするには、ターミナルで次のコマンドを実行します。

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

## nix-shell: Isolated Development Environments

Nixは、隔離された開発環境を作成できる`nix-shell`という強力なツールを提供しています。

### Interactive Shell

特定のパッケージを含むインタラクティブシェルを起動するには、次のコマンドを使用します。

```sh
nix-shell -p PACKAGE_NAME
```

`PACKAGE_NAME`を、シェルに含めたいパッケージ名に置き換えてください。

### Run commands

`nix-shell`を使用して、インタラクティブシェルに入ることなく、隔離された環境内で特定のコマンドを実行することもできます。

```sh
nix-shell -p PACKAGE_NAME --run "COMMAND"
```

### shell.nix: Declarative Shells

`shell.nix`ファイルを作成して、宣言的なシェル環境を定義することができます。以下に例を示します。

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

Nix Packages Searchウェブサイトを使用してパッケージを検索することができます。

👉 [search packages](https://search.nixos.org/packages)

## flakes: A New Way to Manage Nix Projects

Flakesは、Nixプロジェクトをより構造化された再現可能な方法で管理するためのNixの新機能です。

### Enable flakes

flakes機能を有効にするには、`~/.config/nix/nix.conf`を次のように作成します。

```conf
extra-experimental-features = nix-command flakes
```

## Home manager

Home Managerは、Nixを使用してユーザー設定を管理するためのツールです。
このセクションでは、Home Managerのインストールと設定について説明します。

### Install home-manager

`~/.config/home-manager/home.nix`ファイルを次のような内容で作成します。

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

設定ファイルを作成した後、home-managerを初期化するために次のコマンドを実行します。

```sh
nix run home-manager/master -- init --switch
```

### Update home-manager configuration

home-managerの設定に対する変更を反映するには、次のコマンドを実行します。

```sh
home-manager switch
```

flakesを使用している場合は、次のコマンドでパッケージを更新できます。

```sh
nix flake update
home-manager switch
```

### List up installed packages

インストールされているパッケージを一覧表示するには、次のコマンドを実行します。

```sh
home-manager packages
```

### Change repository

デフォルト設定では、Nixは**unstable**パッケージリポジトリを使用します。
安定版のパッケージリポジトリを使用したい場合は、`flake.nix`の設定を変更する必要があります。
例えば、安定版25.11を使用したい場合は、設定を次のように変更します。

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

ニーズに応じて、Nixパッケージとhome-managerに適したリポジトリを選択することができます。
以下は異なるバージョンのURLです。

| Nix package                               | Home Manager                                    | 説明                                     |
| ----------------------------------------- | ----------------------------------------------- | ---------------------------------------- |
| github:nixos/nixpkgs/nixpkgs-unstable     | github:nix-community/home-manager               | Unstableバージョン                       |
| github:nixos/nixpkgs/nixpkgs-25.11        | github:nix-community/home-manager/release-25.11 | LinuxとMacOS向けの安定版25.11            |
| github:nixos/nixpkgs/nixpkgs-25.11-darwin | github:nix-community/home-manager/release-25.11 | MacOS向けの安定版25.11                   |
| github:nixos/nixpkgs/nixos-25.11          | github:nix-community/home-manager/release-25.11 | NixOS向けの安定版25.11                   |

> [!TIP]
> 最新の安定版を使用したい場合は、Nixパッケージのリポジトリを
> `nixos-unstable`に、Home Managerのリポジトリを`home-manager`に
> 設定することができます。これらは最新の安定版リリースで更新されます。

## Initialize flake in a project

flakeを初期化して`flake.nix`を作成するには、次のコマンドを実行します。

```sh
nix flake init
```

その後、`flake.nix`ファイル内でプロジェクトの依存関係と設定を定義できます。
flakeで定義された開発環境を自動的にアクティブ化したい場合は、
次のセクションで説明する`direnv`を使用してください。

## Automatic environment activation with `direnv`

プロジェクトディレクトリに入った際にnix環境を自動的にアクティブ化するには、
nixと組み合わせて`direnv`を使用することができます。
このセクションでは、nixと連携した`direnv`のインストールと設定について解説します。

### Install direnv

direnvを使ってnix環境を自動的にアクティブ化するには、まずdirenvをインストールします。

---

**Option 1: Using Homebrew**:

```sh
brew install direnv
```

---

direnvをインストールした後、シェルの設定ファイル(例: `~/.bashrc`、`~/.zshrc`など)に次の行を追加します。

```sh
eval "$(direnv hook SHELL_NAME)"
```

例えば、`zsh`を使用している場合は、次のように追加します。

```sh
eval "$(direnv hook zsh)"
```

### Configure direnv with nix in a project

nix環境の自動アクティブ化を有効にするには、プロジェクトのルートに`.envrc`を次のように作成します。

```env
use nix
```

`.envrc`ファイルを作成した後、direnvに設定の読み込みを許可するため、次のコマンドを実行します。

```sh
direnv allow
```

## Project setup

### General

最初に、プロジェクトのルートに`flake.nix`を作成します。

次に、プロジェクトのルートに`.envrc`を次のように作成します。

```env
use flake
```

最後に、direnvに設定の読み込みを許可するため、次のコマンドを実行します。

```sh
direnv allow
```

セットアップ後、プロジェクトディレクトリに入ると、direnvがflakeで定義されたnix環境を自動的にアクティブ化します。

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
> Next.jsプロジェクトを作成する場合、最初に
> `nix-shell -p nodejs_<nodeVersion> --run npx create-next-app <project-name>`
> を実行します(例: `nix-shell -p nodejs_24 --run npx create-next-app my-next`)。
> プロジェクトを作成した後、上記のように
> プロジェクトのルートディレクトリに'flake.nix'と'.envrc'を作成します。
