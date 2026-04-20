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

1. Run the following command to start the key generation process:

```sh
gpg --full-generate-key
```

2. Follow the prompts to select the key type, key size, expiration date, and provide your name and email address.

3. After the key pair is generated, you can list your secret keys to find the key ID:
   The key ID is the last 8 characters of the long key ID, which is displayed in the output.

```sh
gpg --list-secret-keys --keyid-format=long
```
