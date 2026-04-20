# Mise

Mise (mise-en-place) is a development tool version manager.
It manages multiple runtime versions such as Node.js, Python, Ruby, Go, and Rust.
It also supports environment variable management and a task runner feature.

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

Add `mise` to your flake inputs and include it in your packages.

---

After installing, activate mise by adding the following to your shell configuration file:

```sh
# zsh (~/.zshrc)
eval "$(mise activate zsh)"

# bash (~/.bashrc)
eval "$(mise activate bash)"
```

## 📝 Configuration

Place a `.mise.toml` file in the project root. Global configuration goes
in `~/.config/mise/config.toml`.

```toml
# .mise.toml
[tools]
node = "22"
python = "3.12"

[env]
NODE_ENV = "development"
```

Mise also supports the `.tool-versions` format (asdf compatible):

```
node 22.0.0
python 3.12.0
```

> [!NOTE]
>
> Configuration is resolved by walking up the directory tree. The closest `.mise.toml` takes precedence over parent directories and the global config.

## 🚀 Usage

### Install

Install tools defined in `.mise.toml`.

```sh
mise install
```

To install a specific tool and version:

```sh
mise install node@22
```

### use

Set a tool version in `.mise.toml` and install it.

```sh
mise use node@22
```

To set a version globally:

```sh
mise use -g node@22
```

### ls

List installed tools and their versions.

```sh
mise ls
```

To list all available versions for a tool:

```sh
mise ls-remote node
```

### current

Show currently active tools and versions.

```sh
mise current
```

### Task runner

Define tasks in `.mise.toml` and run them with `mise run`.

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
