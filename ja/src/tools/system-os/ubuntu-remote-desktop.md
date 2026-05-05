# Ubuntu Remote Desktop

この記事では、Ubuntu の最新バージョン (24.04 以降) で RDP をサポートする
組み込みの `gnome-remote-desktop` サービスを使って、
Ubuntu でリモートデスクトップアクセスを設定する方法を説明します。

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&labelColor=gray&logoColor=white)

## 📝 Overview

最新の Ubuntu (24.04 以降) には `gnome-remote-desktop` が同梱されており、
従来の VNC ベースの GNOME 共有ではなく **RDP** でデスクトップを公開します。
Microsoft Remote Desktop、Remmina、FreeRDP などの任意の RDP クライアントから接続できます。

## 🚀 Setup

### Option A — Desktop session

ローカルにもログインするマシンで使用します。

#### Install

```sh
sudo apt update
sudo apt install -y gnome-remote-desktop
```

#### Enable the per-user service

```sh
systemctl --user enable --now gnome-remote-desktop.service
```

> [!TIP]
>
> - `--user`: ログインユーザのコンテキストで動作する、
>   ユーザごとのサービスを操作します。
> - `--now`: ログイン時の有効化に加えて、
>   サービスを即座に開始します。

#### Configure RDP credentials

```sh
grdctl rdp set-credentials <username> <password>
grdctl rdp enable
```

> [!NOTE]
> RDP のパスワードはユーザのログインパスワードと同じである必要はありません。
> システムのパスワードを変更しても RDP のパスワードは変わらず、その逆も同様です。

#### Generate a self-signed TLS certificate

RDP には TLS 証明書が必要です。

```sh
mkdir -p ~/.local/share/gnome-remote-desktop
openssl req -new -newkey rsa:4096 -days 720 -nodes -x509 \
    -subj "/CN=$(hostname)" \
    -out  ~/.local/share/gnome-remote-desktop/rdp-tls.crt \
    -keyout ~/.local/share/gnome-remote-desktop/rdp-tls.key

grdctl rdp set-tls-cert ~/.local/share/gnome-remote-desktop/rdp-tls.crt
grdctl rdp set-tls-key  ~/.local/share/gnome-remote-desktop/rdp-tls.key
```

#### Verify and open the firewall

```sh
grdctl status
sudo ufw allow 3389/tcp
```

GUI から同じことを行うこともできます。
**Settings → System → Remote Desktop → Remote Login**

### Option B — Headless server

モニタが接続されていない、またはログインユーザがいないマシンで使用します。
システム全体のサービスは、接続時に独自の GNOME セッションを開始します。

```sh
sudo apt install -y gnome-remote-desktop
sudo systemctl enable --now gnome-remote-desktop.service

sudo grdctl --system rdp set-credentials <username> <password>
sudo grdctl --system rdp enable
sudo grdctl --system status

sudo ufw allow 3389/tcp
```

## 🔌 Connecting

- **macOS / Windows** — Microsoft Remote Desktop アプリ
- **Linux** — Remmina、またはコマンドラインから FreeRDP:

```sh
xfreerdp /v:<host>:3389 /u:<username> /p:<password> /cert:ignore
```
