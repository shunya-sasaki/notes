# chezmoi

![gnubash](https://img.shields.io/badge/bash-gray?logo=gnubash&labelColor=gray&logoColor=white)
![zsh](https://img.shields.io/badge/zsh-gray?logo=zsh&labelColor=gray&logoColor=white)

このページでは chezmoi の使い方を説明します。
chezmoi は複数の異なるマシン間でドットファイルを安全に管理します。

<!-- toc -->

- [⚙️ Install](#install)
- [🚀 Usage](#usage)
  - [add](#add)
  - [diff](#diff)
  - [apply](#apply)
  - [update](#update)

<!-- /toc -->

👉 [Official chezmoi page](https://www.chezmoi.io/)

## ⚙️ Install

まず、Homebrew または Snap で chezmoi をインストールします。

---

**Option 1. Homebrew**:

```zsh
brew install chezmoi
```

---

**Option2. Snap**:

```sh
snap install chezmoi --classic
```

---

以下のコマンドを実行して chezmoi を初期化します。
このコマンドにより、ドットファイルを管理するためのリポジトリ
`~/.local/share/chezmoi` が作成されます。

```sh
chezmoi init
```

## 🚀 Usage

このセクションでは、chezmoi の基本的な使い方を説明します。

### add

ファイルまたはディレクトリをリポジトリに追加します。

---

**Option 1. file**:

```sh
chezmoi add <file>
```

---

**Option 2. directory**:

```sh
chezmoi add -r <directory>
```

---

> [!NOTE]
>
> ドットファイルを直接編集した場合は、`chezmoi add` を再度実行してリポジトリを更新してください。

### diff

ホームディレクトリとリポジトリの差分を表示します。

```sh
chezmoi diff
```

### apply

リポジトリの変更をホームディレクトリのファイルに適用します。

```sh
chezmoi apply
```

### update

リモートからリポジトリを更新します。

```sh
chezmoi update
```

> [!NOTE]
> このコマンドはリポジトリ内で `git pull` を実行し、続いて `chezmoi apply` を実行します。
