# Aerospace

<!-- toc -->

- [Overview](#overview)
- [📦 Install](#-install)
- [⚙️ Configuration](#-configuration)
  - [Configuration file](#configuration-file)
  - [Default configuration file](#default-configuration-file)
- [🚀 Usage](#-usage)

<!-- /toc -->

## Overview

Aerospace は macOS 向けのタイリングウィンドウマネージャーです。
Rust で書かれており、macOS 上でウィンドウを管理するための
高度にカスタマイズ可能で効率的な方法を提供します。高速に動作するよう設計されています。

## 📦 Install

---

**Option 1. Homebrew**:

```zsh
brew install aerospace
```

---

**Option 2. Nix**:

nix flake に `aerospace` を追加します。

---

## ⚙️ Configuration

### Configuration file

`XDG_CONFIG_HOME` を `~/.config` に設定している場合、設定ファイルは
`~/.config/aerospace/config.toml` にあります。

### Default configuration file

デフォルトの設定ファイルは
[Aerospace Guide Page](https://nikitabobko.github.io/AeroSpace/config-examples/default-config.toml) からダウンロードできます。

## 🚀 Usage

- 設定ファイルのリロード
  ターミナルで以下のコマンドを実行します:

  `aerospace reload-config`

- ワークスペースの切り替え:
  `option+<workspace name>`（例: `option+1`、`option+w`）

- ノードをワークスペースに移動:
  ウィンドウをアクティブにした後、`option+shift+<workspace>`
