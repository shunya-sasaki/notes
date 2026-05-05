# Multipass

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&labelColor=gray&logoColor=white)

## 📝 What is Multipass?

## 🚀 Usage

### Set driver

```sh
multipass set local.driver=apple
```

| Driver     | macOS | Windows | Linux | Description                                                                                                                |
| ---------- | :---: | :-----: | :---: | -------------------------------------------------------------------------------------------------------------------------- |
| apple      |  ✅   |   ❌    |  ❌   | Uses macOS-native Virtualization.framework. Deeply integrated with the OS and provides the most stable networking.         |
| qemu       |  ✅   |   ❌    |  ✅   | General-purpose emulator. Default on macOS, but its complex network stack can cause API communication latency.             |
| hyperv     |  ❌   |   ✅    |  ❌   | Uses Windows' built-in Hyper-V. The recommended driver on Windows.                                                         |
| virtualbox |  ✅   |   ✅    |  ✅   | Requires installing an external application. Support is limited on Apple Silicon (M1 and later), so it is not recommended. |
| lxd        |  ❌   |   ❌    |  ✅   | Linux only. Runs as a system container (LXC), making it very lightweight and fast.                                         |
| libvirt    |  ❌   |   ❌    |  ✅   | Uses Linux's virtualization management API. Used when advanced configuration is required.                                  |

### Find images

```sh
multipass find
```

### Launch instance

```sh
multipass launch daily:26.04 --name INSTANSE_NAME
```

You can also specify the disk size and memory size when launching the instance.

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

After changing the disk size, you need to resize the partition and filesystem inside the instance.

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
