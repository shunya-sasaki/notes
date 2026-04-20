# Mise

Mise（mise-en-place）は開発ツールのバージョンマネージャーです。
Node.js、Python、Ruby、Go、Rust など複数のランタイムバージョンを管理します。
環境変数の管理やタスクランナー機能もサポートしています。

<!-- toc -->

- [⚙️ Install](#-install)
- [📝 Configuration](#-configuration)
- [🚀 Usage](#-usage)
  - [Install](#install)
  - [use](#use)
  - [ls](#ls)
  - [current](#current)
  - [Task runner](#task-runner)

<!-- /toc -->

👉 [Official mise page](https://mise.jdx.dev/)

## ⚙️ Install

---

**Option 1. Homebrew**:

```sh
brew install mise
```

---

**Option 2. Scoop** (Windows):

```sh
scoop install mise
```

---

**Option 3. Nix flake**:

flake の inputs に `mise` を追加し、packages に含めます。

---

インストール後、シェルの設定ファイルに以下を追加して mise を有効化します:

```sh
# zsh (~/.zshrc)
eval "$(mise activate zsh)"

# bash (~/.bashrc)
eval "$(mise activate bash)"
```

## 📝 Configuration

プロジェクトルートに `.mise.toml` ファイルを配置します。グローバル設定は
`~/.config/mise/config.toml` に配置します。

```toml
# .mise.toml
[tools]
node = "22"
python = "3.12"

[env]
NODE_ENV = "development"
```

Mise は `.tool-versions` フォーマット（asdf 互換）もサポートしています:

```
node 22.0.0
python 3.12.0
```

> [!NOTE]
>
> 設定はディレクトリツリーを上に辿って解決されます。最も近い `.mise.toml` が親ディレクトリやグローバル設定よりも優先されます。

## 🚀 Usage

### Install

`.mise.toml` で定義されたツールをインストールします。

```sh
mise install
```

特定のツールとバージョンをインストールするには:

```sh
mise install node@22
```

### use

`.mise.toml` にツールバージョンを設定し、インストールします。

```sh
mise use node@22
```

グローバルにバージョンを設定するには:

```sh
mise use -g node@22
```

### ls

インストール済みのツールとそのバージョンを一覧表示します。

```sh
mise ls
```

ツールの利用可能な全バージョンを一覧表示するには:

```sh
mise ls-remote node
```

### current

現在アクティブなツールとバージョンを表示します。

```sh
mise current
```

### Task runner

`.mise.toml` でタスクを定義し、`mise run` で実行します。

```toml
# .mise.toml
[tasks.build]
run = "npm run build"
description = "Build the project"

[tasks.test]
run = "npm test"
depends = ["build"]
```

```sh
mise run build
mise tasks ls
```
