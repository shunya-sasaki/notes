# Password manager

<!-- toc -->

- [System local tools](#system-local-tools)
  - [macOS](#macos)
  - [Linux](#linux)
  - [Windows](#windows)

<!-- /toc -->

## System local tools

### macOS

On macOS, the built-in [`security`](https://ss64.com/mac/security.html) command
provides a command-line interface to the Keychain.

#### Register password

```sh
security add-generic-password -a "<account>" -s "<service>" -w "<password>"
```

#### Get password

```sh
security find-generic-password -a "<account>" -s "<service>" -w
```

#### Delete password

```sh
security delete-generic-password -a "<account>" -s "<service>"
```

### Linux

On Linux, [`secret-tool`](https://gitlab.gnome.org/GNOME/libsecret) provides a
command-line interface to the Secret Service API (GNOME Keyring, KWallet, etc.).

#### Setup

Install `secret-tool` via your distribution's package manager:

```sh
# Debian / Ubuntu
sudo apt install libsecret-tools

# Fedora / RHEL
sudo dnf install libsecret

# Arch
sudo pacman -S libsecret
```

`secret-tool` requires a running Secret Service provider such as
`gnome-keyring-daemon` or `kwallet`. On a desktop session this is typically
started automatically; on a headless system you may need to launch it
manually:

```sh
eval "$(gnome-keyring-daemon --start --components=secrets)"
export SSH_AUTH_SOCK GNOME_KEYRING_CONTROL
```

#### Register password

```sh
secret-tool store --label="<label>" account "<account>" service "<service>"
```

`secret-tool` will prompt for the password on stdin. Pass arbitrary
`key value` pairs as attributes after the label; the same attributes must be
used on lookup.

#### Get password

```sh
secret-tool lookup account "<account>" service "<service>"
```

#### Delete password

```sh
secret-tool clear account "<account>" service "<service>"
```

### Windows

On Windows, the official
[`Microsoft.PowerShell.SecretManagement`](https://learn.microsoft.com/en-us/powershell/utility-modules/secretmanagement/overview)
module provides a vault-agnostic interface for storing secrets, with
[`Microsoft.PowerShell.SecretStore`](https://learn.microsoft.com/en-us/powershell/utility-modules/secretstore/overview)
as the default local vault backend.

#### Setup

```powershell
Install-Module Microsoft.PowerShell.SecretManagement -Scope CurrentUser
Install-Module Microsoft.PowerShell.SecretStore -Scope CurrentUser
Register-SecretVault -Name SecretStore `
  -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
```

#### Register password

```powershell
Set-Secret -Name "<service>" -Secret "<password>"
```

#### Get password

```powershell
Get-Secret -Name "<service>" -AsPlainText
```

#### Delete password

```powershell
Remove-Secret -Name "<service>"
```
