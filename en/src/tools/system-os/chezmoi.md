# chezmoi

![gnubash](https://img.shields.io/badge/bash-gray?logo=gnubash&labelColor=gray&logoColor=white)
![zsh](https://img.shields.io/badge/zsh-gray?logo=zsh&labelColor=gray&logoColor=white)

This pages shows instructions of chezmoi.
The chezmoi your dotfiles across multiple diverse machines, securely.

<!-- toc -->

- [⚙️ Install](#-install)
- [🚀 Usage](#-usage)
  - [Basic commands](#basic-commands)
  - [Special directories](#special-directories)

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

### Basic commands

In this section, we will show basic usage of chezmoi.

#### add

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

#### diff

Show the difference between home directory and the repository.

```sh
chezmoi diff
```

#### apply

Apply changes in the repository to the home directory files.

```sh
chezmoi apply
```

#### update

Update the repository from the remote.

```sh
chezmoi update
```

> [!NOTE]
> This command run `git pull` in the repository and `chezmoi apply` in sequence.

### Special directories

#### exact_directory

If you want to manage a directory as it is, use `exact_directory`
instead of `directory` (e.g. `~/.config/exact_nvim` instead of `~/.config/nvim`).

#### .chezmoitemplates

The `.chezmoitemplates` directory stores reusable template snippets
that can be included in other managed files.

Files placed here are not applied to the home directory directly;
instead, they are referenced from other templates
using the `includeTmplate` action.

_.chezmoitemplates/zed-version_:

```text
{{- output "sh" "-c" `curl -sI "https://github.com/zed-industries/zed/releases/latest/" | grep -oE 'tag/[^[:space:]]+' | cut -d/ -f2 | tr -d '[:space:]'` -}}
```

Then include it from a templated dotfile such as `dot_zshrc.tmpl`:

```text
zed_version={{ includeTemplate "zed-version" . }}
```

#### .chezmoiscripts

The `.chezmoiscripts` directory stores scripts that run during `chezmoi apply`.
Scripts here are executed but not copied to the home directory.

##### run_before_XXX

Scripts prefixed with `run_before_` run before any dotfiles are applied.
Use them for setup tasks such as installing packages.

##### run_after_XXX

Scripts prefixed with `run_after_` run after all dotfiles are applied.
Use them for post-setup tasks such as reloading services.
