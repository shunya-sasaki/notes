# chezmoi

![gnubash](https://img.shields.io/badge/bash-gray?logo=gnubash&labelColor=gray&logoColor=white)
![zsh](https://img.shields.io/badge/zsh-gray?logo=zsh&labelColor=gray&logoColor=white)

This pages shows instructions of chezmoi.
The chezmoi your dotfiles across multiple diverse machines, securely.

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

Fist, install chezmoi by either Homebrew or Snap.

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

Run the following command to initialize chezmoi.
This command creates `~/.local/share/chezmoi`
that is a repository to manage your dotfiles.

```sh
chezmoi init
```

## 🚀 Usage

In this section, we will show basic usage of chezmoi.

### add

Add a file or directory to the repository.

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
> If your edit dotfiles in directly, run `chezmoi add` again to update the repository.

### diff

Show the difference between home directory and the repository.

```sh
chezmoi diff
```

### apply

Apply changes in the repository to the home directory files.

```sh
chezmoi apply
```

### update

Update the repository from the remote.

```sh
chezmoi update
```

> [!NOTE]
> This command run `git pull` in the repository and `chezmoi apply` in sequence.