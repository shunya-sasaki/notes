# GnuPG: Generating a GPG Key Pair

<!-- toc -->

- [Install GnuPG](#install-gnupg)
  - [Using Homebrew (macOS)](#using-homebrew-macos)
  - [Using APT (Debian/Ubuntu)](#using-apt-debianubuntu)
- [Generating a GPG Key Pair](#generating-a-gpg-key-pair)

<!-- /toc -->

## Install GnuPG

### Using Homebrew (macOS)

```sh
brew install gnupg
```

### Using APT (Debian/Ubuntu)

```sh
apt-get install gnupg
```

## Generating a GPG Key Pair

1. 以下のコマンドを実行して鍵生成プロセスを開始します:

```sh
gpg --full-generate-key
```

2. プロンプトに従って、鍵の種類、鍵のサイズ、有効期限を選択し、名前とメールアドレスを入力します。

3. 鍵ペアが生成された後、以下のコマンドで秘密鍵を一覧表示して鍵 ID を確認できます:
   鍵 ID は、出力に表示される長い鍵 ID の最後の 8 文字です。

```sh
gpg --list-secret-keys --keyid-format=long
```
