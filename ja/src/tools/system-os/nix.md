# Nix

この記事では、ソフトウェア環境の再現可能なビルドと宣言的な設定を提供する強力なパッケージマネージャー兼ビルドシステムである Nix について説明します。

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

Nix をインストールするには、ターミナルで以下のコマンドを実行します:

```sh
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

## nix-shell: Isolated Development Environments

Nix は分離された開発環境を作成できる `nix-shell` という強力なツールを提供しています。

### Interactive Shell

特定のパッケージを含むインタラクティブシェルを開始するには、以下のコマンドを使用します:

```sh
nix-shell -p PACKAGE_NAME
```

`PACKAGE_NAME` をシェルに含めたいパッケージ名に置き換えてください。

### Run commands

`nix-shell` を使用して、インタラクティブシェルに入らずに分離された環境内で特定のコマンドを実行することもできます:

```sh
nix-shell -p PACKAGE_NAME --run "COMMAND"
```

### shell.nix: Declarative Shells

`shell.nix` ファイルを作成して宣言的なシェル環境を定義できます。以下は例です:

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

Nix Packages Search ウェブサイトを使用してパッケージを検索できます:

👉 [search packages](https://search.nixos.org/packages)

## flakes: A New Way to Manage Nix Projects

Flakes は Nix の新機能で、Nix プロジェクトをより構造的で再現可能な方法で管理できます。

### Enable flakes

flakes 機能を有効にするには、`~/.config/nix/nix.conf` を以下のように作成します:

```conf
extra-experimental-features = nix-command flakes
```

## Home manager

Home Manager は Nix を使用してユーザー設定を管理するためのツールです。
このセクションでは、Home Manager のインストールと設定について説明します。

### Install home-manager

以下のような内容で `~/.config/home-manager/home.nix` ファイルを作成します:

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

設定ファイルを作成した後、以下を実行して home-manager を初期化します。

```sh
nix run home-manager/master -- init --switch
```

### Update home-manager configuration

home-manager の設定に加えた変更を適用するには、以下のコマンドを実行します:

```sh
home-manager switch
```

flakes を使用している場合は、以下のコマンドでパッケージを更新できます:

```sh
nix flake update
home-manager switch
```

### List up installed packages

インストール済みのパッケージを一覧表示するには、以下を実行します:

```sh
home-manager packages
```

### Change repository

デフォルト設定では、nix は **unstable** パッケージリポジトリを使用します。
安定版パッケージリポジトリを使用したい場合は、`flake.nix` の設定を変更する必要があります。
例えば、安定版 25.11 を使用したい場合は、以下のように設定を変更します:

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

## Initialize flake in a project

以下のコマンドを実行して flake を初期化します。`flake.nix` が作成されます。

```sh
nix flake init
```

プロジェクトの依存関係と設定を `flake.nix` ファイルに定義できます。
flake で定義された開発環境を自動的に有効化したい場合は、
次のセクションで説明する `direnv` を使用してください。

## Automatic environment activation with `direnv`

プロジェクトディレクトリに入ったときに nix 環境を自動的に有効化するには、
nix と組み合わせて `direnv` を使用できます。
このセクションでは、nix での `direnv` のインストールと設定について説明します。

### Install direnv

direnv を使用して nix 環境の自動有効化を行うには、まず direnv をインストールします:

---

**Option 1: Using Homebrew**:

```sh
brew install direnv
```

---

direnv をインストールした後、シェルの設定ファイル（例: `~/.bashrc`、`~/.zshrc` など）に以下の行を追加します:

```sh
eval "$(direnv hook SHELL_NAME)"
```

例えば、`zsh` を使用している場合は以下を追加します:

```sh
eval "$(direnv hook zsh)"
```

### Configure direnv with nix in a project

nix 環境の自動有効化を行うには、プロジェクトルートに `.envrc` を以下のように作成します:

```env
use nix
```

`.envrc` ファイルを作成した後、以下のコマンドを実行して direnv が設定を読み込めるようにします:

```sh
direnv allow
```

## Project setup

### General

まず、プロジェクトルートに `flake.nix` を作成します。

次に、プロジェクトルートに `.envrc` を以下のように作成します:

```env
use flake
```

最後に、以下のコマンドを実行して direnv が設定を読み込めるようにします:

```sh
direnv allow
```

設定後、プロジェクトディレクトリに入ると、direnv が flake で定義された nix 環境を自動的に有効化します。

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
> Next.js プロジェクトを作成する場合は、まず
> `nix-shell -p nodejs_<nodeVersion> --run npx create-next-app <project-name>` を実行します
> （例: `nix-shell -p nodejs_24 --run npx create-next-app my-next`）。
> プロジェクト作成後、プロジェクトルートディレクトリに上記のように 'flake.nix' と '.envrc'
> を作成します。
