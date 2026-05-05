# SOPS & age

![gnubash](https://img.shields.io/badge/bash-gray?logo=gnubash&labelColor=gray&logoColor=white)
![zsh](https://img.shields.io/badge/zsh-gray?logo=zsh&labelColor=gray&logoColor=white)

This page shows instructions of SOPS and age.
SOPS (Secrets OPerationS) is an editor of encrypted files that supports
YAML, JSON, ENV, INI, and binary formats.
age is a simple, modern file encryption tool that SOPS can use as its key backend.

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

Install both `sops` and `age` with your package manager.

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

For SOPS, download the latest binary from the
[releases page](https://github.com/getsops/sops/releases).

---

## 🔑 Generate an age Key

Generate a new age key pair and store it in the default location
that SOPS reads.

```sh
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

The command prints the public key (recipient) to stderr,
for example:

```text
Public key: age1qz...examplepublickey...8h
```

> [!NOTE]
>
> Keep `keys.txt` private. Back it up securely; losing it makes
> every file encrypted to that key unreadable.

By default SOPS reads keys from `~/.config/sops/age/keys.txt`.
Override the path with the `SOPS_AGE_KEY_FILE` environment variable.

## 🚀 Usage

### Configure SOPS

Place a `.sops.yaml` file at the root of your repository
to declare which recipients can decrypt which files.

_.sops.yaml_:

```yaml
creation_rules:
  - path_regex: \.enc\.ya?ml$
    age: age1qz...examplepublickey...8h
  - path_regex: secrets/.*\.env$
    age: age1qz...examplepublickey...8h
```

You can list multiple recipients separated by commas to allow
several keys to decrypt the same file.

### Encrypt a file

Encrypt an existing plaintext file in place.

```sh
sops --encrypt --in-place secrets.yaml
```

For YAML and JSON, only the values are encrypted by default —
keys remain readable so diffs stay meaningful.

To encrypt and write to a new file instead:

```sh
sops --encrypt secrets.yaml > secrets.enc.yaml
```

### Decrypt a file

Decrypt to stdout.

```sh
sops --decrypt secrets.enc.yaml
```

Or decrypt in place:

```sh
sops --decrypt --in-place secrets.enc.yaml
```

### Edit an encrypted file

Open the decrypted content in `$EDITOR`, then re-encrypt on save.

```sh
sops secrets.enc.yaml
```

This is the recommended workflow — the plaintext never touches disk.

### Rotate keys

After updating recipients in `.sops.yaml`, re-encrypt existing files
with the new key set.

```sh
sops updatekeys secrets.enc.yaml
```
