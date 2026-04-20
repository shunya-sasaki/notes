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

Aerospace is a tiling window manager for macOS.
It is written in Rust and provides a highly customizable and efficient way
to manage windows on macOS. It is designed to be fast

## 📦 Install

---

**Option 1. Homebrew**:

```zsh
brew install aerospace
```

---

**Option 2. Nix**:

Add `aerospace` to your nix flake.

---

## ⚙️ Configuration

### Configuration file

If you set `XDG_CONFIG_HOME` to `~/.config`, you can find the configuration file
at `~/.config/aerospace/config.toml`.

### Default configuration file

You can download the default configuration file from
[Aerospace Guide Page](https://nikitabobko.github.io/AeroSpace/config-examples/default-config.toml).

## 🚀 Usage

- Reload configuration file
  In terminal run the following command:

  `aerospace reload-config`

- Change workspace:
  `option+<workspace name>` (e.g, `option+1`, `option+w`)

- Move node to workspace:
  After activating window, `option+shift+<workspace>`
