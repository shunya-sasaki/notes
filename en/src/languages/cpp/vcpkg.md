# vcpkg: C++ pakcage manager

![c++](https://img.shields.io/badge/c++-gray?logo=cplusplus&labelColor=0059cc&logoColor=white)
![cmake](https://img.shields.io/badge/cmake-gray?logo=cmake&labelColor=064f8c&logoColor=white)

This document demonstrates the usage of **vcpkg**, a package manager for C++ projects.

<!-- toc -->

- [📦 Requirements](#-requirements)
- [⚙️ Install](#️-install)
- [🔰 CMake Project configuration](#-cmake-project-configuration)
  - [Initialize configurations](#initialize-configurations)
  - [Create preset file](#create-preset-file)
- [🚀 Usage](#-usage)
  - [Add package](#add-package)
  - [Link package](#link-package)
  - [Build](#build)

<!-- /toc -->

> [!NOTE]
> Check the following for details of vcpkg.
> 👉 [vcpkg official page](https://vcpkg.io/en/)

## 📦 Requirements

- c++ compilers (e.g. g++, clang)
- ninja
- git

## ⚙️ Install

**Option 1. Homebrew**:

```sh
brew install vcpkg
```

Add `VPKG_ROOT` to your shell confiuguration file (e.g. `.zshrc`).

```sh
export VCPKG_ROOT="$HOME/vcpkg"
```

## 🔰 CMake Project configuration

### Initialize configurations

Run the following command to initialize vcpkg configurations of the project.

```sh
vcpkg init --application
```

After running the command, `vcpkg.json` will be created.

```diff
  PROJECT
  |- cmake/
  |- src/
  |- CMakeLists.txt
  |- README.md
+ `- vcpkg.json
```

### Create preset file

Create preset file `CMakePresets.json` as the following.

```json
{
  "version": 2,
  "configurePresets": [
    {
      "name": "release",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build",
      "cacheVariables": {
        "CMAKE_TOOLCHAIN_FILE": "$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake",
        "CMAKE_BUILD_TYPE": "Release"
      }
    },
    {
      "name": "debug",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build",
      "cacheVariables": {
        "CMAKE_TOOLCHAIN_FILE": "$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake",
        "CMAKE_BUILD_TYPE": "Debug"
      }
    }
  ]
}
```

## 🚀 Usage

### Add package

```sh
vcpkg add port <package name>
```

> [!TIP]
> For example, to add package `spdlog`, run the command `vcpkg add port spdlog`.

### Link package

After adding package to the project, add `find_package` and
`target_link_libraries` to `CMakeLists.txt`.

```diff
+ find_package(spdlog REQUIRED)
  add_executable(Main)
+ target_link_libraries(Main PRIVATE spdlog::spdlog)
  target_sources(Main PRIVATE main.cpp)
  target_compile_definitions(Main PRIVATE VERSION="${FULL_VERSION}")
```

### Build

Run the following command to execute CMake with the preset
that you created in `CMakePresets.json`.

```sh
cmake --preset=<preset name>
```

> [!TIP]
> For instance, to execute CMake using the `debug` preset, enter the following command.
>
> ```sh
> cmake --preset=debug
> ```

After executing configurations, run the build command as followings.

```sh
cmake --build build
```
