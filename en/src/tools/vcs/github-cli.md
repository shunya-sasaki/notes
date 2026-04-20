# GitHub CLI

![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github&labelColor=gray&logoColor=white)

<!-- toc -->

- [📦 Install](#-install)
- [⚙️ Setup](#-setup)
  - [Create classic token](#create-classic-token)
  - [Set token to environment variable](#set-token-to-environment-variable)
- [🚀 Usage](#-usage)
  - [Quick reference](#quick-reference)
  - [Login](#login)
  - [Status](#status)
  - [Repo](#repo)
  - [Issues](#issues)

<!-- /toc -->

## 📦 Install

---
**Option 1: Install via Homebrew (macOS)**:

```sh
brew install gh
```
---

**Option 2: Install via Apt (Linux/Ubuntu)**:

```sh
sudo apt install gh
```

---

**Option 3: Install via Scoop (Windows)**:

```ps1
scoop install main/gh
```

---

**Option 4: Install via Nix Home Manager**:

Add `gh` to your `home.packages` in your Nix Home Manager configuration:

```nix
{ pkgs }:

with pkgs; [
  gh
]
```

---

## ⚙️ Setup

### Create classic token

For GitHub CLI, you have to create a classic tokens.
You can create a token with the following permissions:

- repo
- workflow
- write:packages
- admin:org
- admin:repo_hook
- gist
- notifications
- user
- delete_repo
- write:discussion
- codespace
- copilot
- project
- admin:gpg_key
- admin:ssh_key

### Set token to environment variable

In order to authenticate with GitHub CLI, you need to set the token
to an environment variable.

You can use `GITHUB_TOKEN` or `GH_TOKEN` environment variable
to authenticate with GitHub CLI.

> [!TIP]
> `GH_TOKEN` is prioritized over `GITHUB_TOKEN` in the authentication process.

## 🚀 Usage

### Quick reference

| Command         | Description                   |
| --------------- | ----------------------------- |
| `gh auth login` | Authenticate with GitHub      |
| `gh status`     | Check status of repos and PRs |

### Login

First, you need to authenticate with GitHub:

```sh
gh auth login
```

### Status

To check the status of your GitHub repositories and pull requests:

```sh
gh status
```

### Repo

To view the list of repositories you have access to:

```sh
gh repo list
```

#### Create new repo

```sh
gh repo create <repo-name>
```

or

```sh
gh repo new <repo-name>
```

You can also specify the visibility of the repository:

**Public**:

```sh
gh repo create <repo-name> --public
```

**Private**:

```sh
gh repo create <repo-name> --private
```

### Issues

#### List Issues

```sh
gh issue list
```
