# Multipass

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&labelColor=gray&logoColor=white)

## 📝 What is Multipass?

## 🚀 Usage

### Set driver

```sh
multipass set local.driver=qemu
```

| Driver     | macOS | Windows | Linux | 説明                                                                                                                                |
| ---------- | :---: | :-----: | :---: | ----------------------------------------------------------------------------------------------------------------------------------- |
| qemu       |  ✅   |   ❌    |  ✅   | 汎用エミュレータです。macOS と Linux のデフォルトです。Apple Silicon では Apple の Hypervisor.framework をラップして使用します。    |
| hyperv     |  ❌   |   ✅    |  ❌   | Windows 標準の Hyper-V を使用します。Windows のデフォルトです。Windows Pro 以上のエディションが必要です。                           |
| virtualbox |  ✅   |   ✅    |  ✅   | VirtualBox を別途インストールする必要があります。Apple Silicon (M1 以降) でのサポートは限定的で、VirtualBox のバージョンに依存します。 |

### Find images

```sh
multipass find
```

### Launch instance

```sh
multipass launch daily:26.04 --name INSTANSE_NAME
```

インスタンスの起動時にディスクサイズやメモリサイズを指定することもできます。

```sh
multipass launch daily:26.04 --name INSTANSE_NAME -c 4 d 126G -m 8G
```

### List instances

```sh
multipass list
```

### Delete instance

```sh
mulitpass delete INSTANSE_NAME
multipass purge
```

### Login to instance

```sh
multipass shell ubuntu-2604-env
```

### Change disk size

```sh
multipass stop ubuntu-2604-env
multipass set local.ubuntu-2604-env.disk=30G
multipass start ubuntu-2604-env
```

ディスクサイズを変更した後は、インスタンス内でパーティションとファイルシステムをリサイズする必要があります。

```sh
sudo parted /dev/sda resizepart 1 100%
sudo resize2fs /dev/sda1
```

### Change memory size

```sh
multipass stop ubuntu-2604-env
multipass set local.ubuntu-2604-env.memory=8G
multipass start ubuntu-2604-env
```
