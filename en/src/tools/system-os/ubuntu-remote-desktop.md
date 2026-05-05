# Ubuntu Remote Desktop

This article explains how to set up remote desktop access on Ubuntu
using the built-in `gnome-remote-desktop` service,
which provides RDP support for modern Ubuntu versions (24.04 and later).

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&labelColor=gray&logoColor=white)

## 📝 Overview

Modern Ubuntu (24.04 and later) ships `gnome-remote-desktop`, which exposes
the desktop over **RDP** instead of the legacy VNC-based GNOME sharing.
You can connect from any RDP client such as Microsoft Remote Desktop,
Remmina, or FreeRDP.

## 🚀 Setup

### Option A — Desktop session

Use this when you also log in locally on the machine.

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
> - `--user`: Operate on the per-user service,
>   which runs in the context of the logged-in user.
> - `--now`: Start the service immediately,
>   in addition to enabling it at login.

#### Configure RDP credentials

```sh
grdctl rdp set-credentials <username> <password>
grdctl rdp enable
```

> [!NOTE]
> The password for RDP does't have to be the same as the user's login password.
> Changing your sytem password does not change the RDP password and vice versa.

#### Generate a self-signed TLS certificate

RDP requires a TLS certificate.

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

You can do the same from the GUI:
**Settings → System → Remote Desktop → Remote Login**.

### Option B — Headless server

Use this on a machine with no monitor or no logged-in user.
The system-wide service starts its own GNOME session on connect.

```sh
sudo apt install -y gnome-remote-desktop
sudo systemctl enable --now gnome-remote-desktop.service

sudo grdctl --system rdp set-credentials <username> <password>
sudo grdctl --system rdp enable
sudo grdctl --system status

sudo ufw allow 3389/tcp
```

## 🔌 Connecting

- **macOS / Windows** — Microsoft Remote Desktop app
- **Linux** — Remmina, or FreeRDP from the command line:

```sh
xfreerdp /v:<host>:3389 /u:<username> /p:<password> /cert:ignore
```
