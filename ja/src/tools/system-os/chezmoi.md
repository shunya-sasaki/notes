# chezmoi

![gnubash](https://img.shields.io/badge/bash-gray?logo=gnubash&labelColor=gray&logoColor=white)
![zsh](https://img.shields.io/badge/zsh-gray?logo=zsh&labelColor=gray&logoColor=white)

このページでは chezmoi の使い方を説明します。
chezmoi は複数の異なるマシン間でドットファイルを安全に管理します。

<!-- toc -->

- [⚙️ Install](#-install)
- [🚀 Usage](#-usage)
  - [Basic commands](#basic-commands)
  - [Special directories](#special-directories)

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

### Basic commands

このセクションでは、chezmoi の基本的な使い方を説明します。

#### add

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

#### diff

ホームディレクトリとリポジトリの差分を表示します。

```sh
chezmoi diff
```

#### apply

リポジトリの変更をホームディレクトリのファイルに適用します。

```sh
chezmoi apply
```

#### update

リモートからリポジトリを更新します。

```sh
chezmoi update
```

> [!NOTE]
> このコマンドはリポジトリ内で `git pull` を実行し、続いて `chezmoi apply` を実行します。

### Special directories

#### exact_directory

ディレクトリをそのまま管理したい場合は、`directory` の代わりに `exact_directory`
を使用します (例: `~/.config/nvim` の代わりに `~/.config/exact_nvim`)。

#### .chezmoitemplates

`.chezmoitemplates` ディレクトリには、他の管理対象ファイルにインクルードできる
再利用可能なテンプレートスニペットを格納します。

ここに置かれたファイルはホームディレクトリに直接適用されません。
代わりに、`includeTmplate` アクションを使って他のテンプレートから参照されます。

_.chezmoitemplates/zed-version_:

```text
{{- output "sh" "-c" `curl -sI "https://github.com/zed-industries/zed/releases/latest/" | grep -oE 'tag/[^[:space:]]+' | cut -d/ -f2 | tr -d '[:space:]'` -}}
```

そして、`dot_zshrc.tmpl` のようなテンプレート化されたドットファイルからインクルードします。

```text
zed_version={{ includeTemplate "zed-version" . }}
```

#### .chezmoiscripts

`.chezmoiscripts` ディレクトリには、`chezmoi apply` 中に実行されるスクリプトを格納します。
ここにあるスクリプトは実行されますが、ホームディレクトリにはコピーされません。

##### run_before_XXX

`run_before_` というプレフィックスを持つスクリプトは、すべてのドットファイルが適用される前に実行されます。
パッケージのインストールなどのセットアップタスクに使用します。

##### run_after_XXX

`run_after_` というプレフィックスを持つスクリプトは、すべてのドットファイルが適用された後に実行されます。
サービスの再読み込みなどのセットアップ後のタスクに使用します。
