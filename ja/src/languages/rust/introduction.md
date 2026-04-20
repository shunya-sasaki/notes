# Rust Introdcution

<!-- toc -->

- [📝 What is Rust?](#-what-is-rust)
- [Rustup](#rustup)
  - [Install](#install)
  - [Install rust-analyzer (optional)](#install-rust-analyzer-optional)
  - [Update Rustup and Rust toolchain](#update-rustup-and-rust-toolchain)
- [Cargo](#cargo)
  - [Cargo commands](#cargo-commands)
- [Project structure](#project-structure)
- [Enum](#enum)
- [Tips](#tips)
  - [match sentense](#match-sentense)

<!-- /toc -->

## 📝 What is Rust?

Rust は安全性、速度、並行性に焦点を当てたシステムプログラミング言語です。ガベージコレクタを使用せずにメモリ安全性を提供するよう設計されており、パフォーマンスが重要なアプリケーションに適しています。

**特徴**:

- **Memory Safety**: コンパイル時にチェックされる所有権のルールシステムにより、ガベージコレクタなしでメモリ安全性を保証します。
- **Performance**: C や C++ に匹敵する高いパフォーマンスを実現します。
- **Concurrency**: スレッド安全性に対する強力なコンパイル時保証を提供し、データ競合のない並行プログラムの記述を容易にします。
- **Reliability**: 信頼性が高く堅牢なソフトウェアの構築を目的として設計されています。
- **Productivity**: 強力な型システム、統合パッケージマネージャー（Cargo）、充実したドキュメントなどの機能が開発者の生産性を向上させます。

## Rustup

Rustup は Rust のバージョンと関連ツールを管理するための公式ツールです。Rust の異なるバージョンのインストールや切り替え、ツールチェーンの管理を簡単に行えます。

### Install

---

**Option 1. Homebrew**:

```sh
brew install rustup
```

---

rustup をインストールした後、以下のコマンドで初期化します。

```sh
rustup default stable
```

> [!TIP]
> cargo のバイナリがインストールされるディレクトリを Path に追加するには、
> シェルの設定ファイル（例: `~/.bashrc`）に以下の行を追加してください:
>
> ```sh
> export PATH="$(dirname $(rustup which cargo)):$PATH"
> ```

### Install rust-analyzer (optional)

rust-analyzer は Rust 向けの人気のある言語サーバーで、コード補完、定義へのジャンプ、インラインエラーメッセージなどの機能を提供します。

rust-analyzer をインストールするには、以下のコマンドを実行します:

```sh
rustup component add rust-analyzer
```

### Update Rustup and Rust toolchain

Rustup と Rust ツールチェーンを最新の安定版に更新するには、以下のコマンドを実行します:

```sh
rustup update
```

## Cargo

Cargo は Rust のパッケージマネージャー兼ビルドシステムです。コードのビルド、依存関係のダウンロード、テストの実行など、Rust プロジェクトの管理プロセスを簡素化します。

### Cargo commands

#### new

新しい Rust プロジェクトを作成します。

```sh
cargo new <project_name>
```

#### build

現在の Rust プロジェクトをコンパイルします。

```sh
cargo build
```

#### run

現在の Rust プロジェクトをビルドして実行します。

```sh
cargo run
```

#### test

現在の Rust プロジェクトのテストを実行します。

```sh
cargo test
```

```rs
#[test]
fn test_sample {
  ...
}
```

```rs
#![cfg(test)]
mod tests {
  ...
}
```

#### doc

```sh
cargo doc --no-deps --open
```

#### package

```sh
cargo package
cargo login
cargo publish
```

## Project structure

Rust のモジュールシステムは時間とともに進化しており、Rust プロジェクトでモジュールを構成する方法には 2 つの一般的なスタイルがあります: `mod.rs` ファイルを使用する旧スタイルと、モジュール名に一致するファイル名を使用するモダンスタイルです。

これら 2 つのスタイルは同じプロジェクト内で共存できますが、一貫性のためにどちらか一方を選ぶことが一般的に推奨されます。
モダンスタイルはそのシンプルさと明確さから好まれることが多いです。

**Old style module structure**:

```diff
some-project
├── src/
│     ├── main.rs
│     └── sub/
│            ├── mod.rs
│            └── subsub.rs
└── Cargo.toml
```

**Modern style module structure**:

```diff
some-project
├── src/
│     ├── main.rs
│     ├── sub.rs
│     └── sub/
│            └── subsub.rs
└── Cargo.toml
```

## Enum

## Tips

### match sentense

- match 文の最後にはワイルドカードパターンを使用してください
