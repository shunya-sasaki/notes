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

Nix Home Manager の設定で `home.packages` に `gh` を追加します:

```nix
{ pkgs }:

with pkgs; [
  gh
]
```

---

## ⚙️ Setup

### Create classic token

GitHub CLI を使用するには、クラシックトークンを作成する必要があります。
以下の権限でトークンを作成できます:

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

GitHub CLI で認証するには、環境変数にトークンを設定する必要があります。

`GITHUB_TOKEN` または `GH_TOKEN` 環境変数を使用して
GitHub CLI で認証できます。

> [!TIP]
> 認証プロセスでは `GH_TOKEN` が `GITHUB_TOKEN` よりも優先されます。

## 🚀 Usage

### Quick reference

| Command         | Description                              |
| --------------- | ---------------------------------------- |
| `gh auth login` | GitHub で認証します                      |
| `gh status`     | リポジトリと PR のステータスを確認します |

### Login

まず、GitHub で認証する必要があります:

```sh
gh auth login
```

### Status

GitHub リポジトリとプルリクエストのステータスを確認するには:

```sh
gh status
```

### Repo

アクセス可能なリポジトリの一覧を表示するには:

```sh
gh repo list
```

#### Create new repo

```sh
gh repo create <repo-name>
```

または

```sh
gh repo new <repo-name>
```

リポジトリの公開範囲も指定できます:

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
