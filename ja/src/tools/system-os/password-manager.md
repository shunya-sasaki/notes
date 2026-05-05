# Password manager

<!-- toc -->

- [System local tools](#system-local-tools)
  - [macOS](#macos)
  - [Linux](#linux)
  - [Windows](#windows)

<!-- /toc -->

## System local tools

### macOS

macOS では、組み込みの [`security`](https://ss64.com/mac/security.html) コマンドが
キーチェーンへのコマンドラインインタフェースを提供します。

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

Linux では、[`secret-tool`](https://gitlab.gnome.org/GNOME/libsecret) が
Secret Service API (GNOME Keyring、KWallet など) へのコマンドラインインタフェースを提供します。

#### Setup

ディストリビューションのパッケージマネージャで `secret-tool` をインストールします。

```sh
# Debian / Ubuntu
sudo apt install libsecret-tools

# Fedora / RHEL
sudo dnf install libsecret

# Arch
sudo pacman -S libsecret
```

`secret-tool` は `gnome-keyring-daemon` や `kwallet` などの Secret Service プロバイダが
動作している必要があります。デスクトップセッションでは通常自動的に起動されますが、
ヘッドレスシステムでは手動で起動する必要があるかもしれません。

```sh
eval "$(gnome-keyring-daemon --start --components=secrets)"
export SSH_AUTH_SOCK GNOME_KEYRING_CONTROL
```

#### Register password

```sh
secret-tool store --label="<label>" account "<account>" service "<service>"
```

`secret-tool` は標準入力からパスワードの入力を求めます。ラベルの後に任意の
`key value` ペアを属性として渡してください。検索時にも同じ属性を使用する必要があります。

#### Get password

```sh
secret-tool lookup account "<account>" service "<service>"
```

#### Delete password

```sh
secret-tool clear account "<account>" service "<service>"
```

### Windows

Windows では、公式の
[`Microsoft.PowerShell.SecretManagement`](https://learn.microsoft.com/en-us/powershell/utility-modules/secretmanagement/overview)
モジュールがシークレットを保存するためのボールトに依存しないインタフェースを提供します。
デフォルトのローカルボールトバックエンドとして
[`Microsoft.PowerShell.SecretStore`](https://learn.microsoft.com/en-us/powershell/utility-modules/secretstore/overview)
を使用します。

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
