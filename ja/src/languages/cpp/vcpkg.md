# vcpkg: C++ pakcage manager

![c++](https://img.shields.io/badge/c++-gray?logo=cplusplus&labelColor=0059cc&logoColor=white)
![cmake](https://img.shields.io/badge/cmake-gray?logo=cmake&labelColor=064f8c&logoColor=white)

このドキュメントでは、C++ プロジェクト向けパッケージマネージャーである **vcpkg** の使い方を説明します。

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
> vcpkg の詳細については以下を参照してください。
> 👉 [vcpkg official page](https://vcpkg.io/en/)

## 📦 Requirements

- C++ コンパイラ（例: g++, clang）
- ninja
- git

## ⚙️ Install

**Option 1. Homebrew**:

```sh
brew install vcpkg
```

シェルの設定ファイル（例: `.zshrc`）に `VCPKG_ROOT` を追加します。

```sh
export VCPKG_ROOT="$HOME/vcpkg"
```

## 🔰 CMake Project configuration

### Initialize configurations

以下のコマンドを実行して、プロジェクトの vcpkg 設定を初期化します。

```sh
vcpkg init --application
```

コマンドを実行すると、`vcpkg.json` が作成されます。

```diff
  PROJECT
  |- cmake/
  |- src/
  |- CMakeLists.txt
  |- README.md
+ `- vcpkg.json
```

### Create preset file

以下のようにプリセットファイル `CMakePresets.json` を作成します。

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
> 例えば、パッケージ `spdlog` を追加するには、コマンド `vcpkg add port spdlog` を実行します。

### Link package

プロジェクトにパッケージを追加した後、`CMakeLists.txt` に `find_package` と
`target_link_libraries` を追加します。

```diff
+ find_package(spdlog REQUIRED)
  add_executable(Main)
+ target_link_libraries(Main PRIVATE spdlog::spdlog)
  target_sources(Main PRIVATE main.cpp)
  target_compile_definitions(Main PRIVATE VERSION="${FULL_VERSION}")
```

### Build

以下のコマンドを実行して、`CMakePresets.json` で作成したプリセットを使用して
CMake を実行します。

```sh
cmake --preset=<preset name>
```

> [!TIP]
> 例えば、`debug` プリセットを使用して CMake を実行するには、以下のコマンドを入力します。
>
> ```sh
> cmake --preset=debug
> ```

設定の実行後、以下のようにビルドコマンドを実行します。

```sh
cmake --build build
```
