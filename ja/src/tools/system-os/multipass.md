# Multipass

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&labelColor=gray&logoColor=white)

## 📝 What is Multipass?

## 🚀 Usage

### Set driver

```sh
multipass set local.driver=apple
```

| Driver     | macOS | Windows | Linux | 説明                                                                                                                       |
| ---------- | :---: | :-----: | :---: | -------------------------------------------------------------------------------------------------------------------------- |
| apple      |  ✅   |   ❌    |  ❌   | macOS ネイティブの Virtualization.framework を使用します。OS と深く統合されており、最も安定したネットワークを提供します。 |
| qemu       |  ✅   |   ❌    |  ✅   | 汎用エミュレータです。macOS のデフォルトですが、複雑なネットワークスタックにより API 通信のレイテンシが発生する場合があります。 |
| hyperv     |  ❌   |   ✅    |  ❌   | Windows 標準の Hyper-V を使用します。Windows での推奨ドライバです。                                                        |
| virtualbox |  ✅   |   ✅    |  ✅   | 外部アプリケーションのインストールが必要です。Apple Silicon (M1 以降) でのサポートが限定的なため、推奨されません。         |
| lxd        |  ❌   |   ❌    |  ✅   | Linux 専用です。システムコンテナ (LXC) として動作するため、非常に軽量で高速です。                                          |
| libvirt    |  ❌   |   ❌    |  ✅   | Linux の仮想化管理 API を使用します。高度な設定が必要な場合に使用します。                                                  |

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
