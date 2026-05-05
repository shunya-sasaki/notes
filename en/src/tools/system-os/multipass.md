# Multipass

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&labelColor=gray&logoColor=white)

## 📝 What is Multipass?

## 🚀 Usage

### Set driver

```sh
multipass set local.driver=qemu
```

| Driver     | macOS | Windows | Linux | Description                                                                                                                          |
| ---------- | :---: | :-----: | :---: | ------------------------------------------------------------------------------------------------------------------------------------ |
| qemu       |  ✅   |   ❌    |  ✅   | General-purpose emulator. Default on macOS and Linux. On Apple Silicon it wraps Apple's Hypervisor.framework.                        |
| hyperv     |  ❌   |   ✅    |  ❌   | Uses Windows' built-in Hyper-V. Default on Windows. Requires Windows Pro (or higher) edition.                                        |
| virtualbox |  ✅   |   ✅    |  ✅   | Requires installing VirtualBox separately. Support on Apple Silicon (M1 and later) is limited and depends on the VirtualBox version. |

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
