# SOPS & age

![gnubash](https://img.shields.io/badge/bash-gray?logo=gnubash&labelColor=gray&logoColor=white)
![zsh](https://img.shields.io/badge/zsh-gray?logo=zsh&labelColor=gray&logoColor=white)

このページでは SOPS と age の使い方を説明します。
SOPS (Secrets OPerationS) は YAML、JSON、ENV、INI、バイナリ形式に対応した
暗号化ファイルのエディタです。
age はシンプルでモダンなファイル暗号化ツールであり、SOPS の鍵バックエンドとして使用できます。

<!-- toc -->

- [⚙️ Install](#-install)
- [🔑 Generate an age Key](#-generate-an-age-key)
- [🚀 Usage](#-usage)
  - [Configure SOPS](#configure-sops)
  - [Encrypt a file](#encrypt-a-file)
  - [Decrypt a file](#decrypt-a-file)
  - [Edit an encrypted file](#edit-an-encrypted-file)
  - [Rotate keys](#rotate-keys)

<!-- /toc -->

👉 [Official SOPS page](https://getsops.io/) /
[Official age page](https://age-encryption.org/)

## ⚙️ Install

`sops` と `age` の両方をパッケージマネージャでインストールします。

---

**Option 1. Homebrew**:

```zsh
brew install sops age
```

---

**Option 2. APT (Debian/Ubuntu)**:

```sh
apt-get install age
```

SOPS については、[releases page](https://github.com/getsops/sops/releases)
から最新のバイナリをダウンロードしてください。

---

## 🔑 Generate an age Key

新しい age 鍵ペアを生成し、SOPS が読み取るデフォルトの場所に保存します。

```sh
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

このコマンドは、公開鍵 (recipient) を標準エラー出力に表示します。例:

```text
Public key: age1qz...examplepublickey...8h
```

> [!NOTE]
>
> `keys.txt` は秘密に保ってください。安全にバックアップしてください。
> 紛失するとその鍵で暗号化されたすべてのファイルを読めなくなります。

デフォルトでは SOPS は `~/.config/sops/age/keys.txt` から鍵を読み取ります。
パスを変更するには `SOPS_AGE_KEY_FILE` 環境変数を使用します。

## 🚀 Usage

### Configure SOPS

リポジトリのルートに `.sops.yaml` ファイルを配置し、
どのファイルをどの recipient が復号できるかを宣言します。

_.sops.yaml_:

```yaml
creation_rules:
  - path_regex: \.enc\.ya?ml$
    age: age1qz...examplepublickey...8h
  - path_regex: secrets/.*\.env$
    age: age1qz...examplepublickey...8h
```

複数の recipient をカンマ区切りで列挙することで、
複数の鍵で同じファイルを復号できるようにすることができます。

### Encrypt a file

既存のプレーンテキストファイルをその場で暗号化します。

```sh
sops --encrypt --in-place secrets.yaml
```

YAML と JSON では、デフォルトで値のみが暗号化されます。
キーは可読のまま残るため、差分が意味を保ちます。

暗号化して新しいファイルに書き出すには次のようにします。

```sh
sops --encrypt secrets.yaml > secrets.enc.yaml
```

### Decrypt a file

標準出力に復号します。

```sh
sops --decrypt secrets.enc.yaml
```

または、その場で復号します。

```sh
sops --decrypt --in-place secrets.enc.yaml
```

### Edit an encrypted file

`$EDITOR` で復号されたコンテンツを開き、保存時に再暗号化します。

```sh
sops secrets.enc.yaml
```

これが推奨ワークフローです。プレーンテキストがディスクに残ることはありません。

### Rotate keys

`.sops.yaml` の recipient を更新したあと、新しい鍵セットで既存のファイルを再暗号化します。

```sh
sops updatekeys secrets.enc.yaml
```
