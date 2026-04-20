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

Rust is a systems programming language focused on safety, speed, and concurrency. It is designed to provide memory safety without using a garbage collector, making it suitable for performance-critical applications.

**Features**:

- **Memory Safety**: Guarantees memory safety without a garbage collector by using a system of ownership with a set of rules that the compiler checks at compile time.
- **Performance**: Achieves high performance comparable to C and C++.
- **Concurrency**: Provides strong compile-time guarantees for thread safety, making it easier to write concurrent programs without data races.
- **Reliability**: Designed for building reliable and robust software.
- **Productivity**: Features like a powerful type system, an integrated package manager (Cargo), and extensive documentation enhance developer productivity.

## Rustup

Rustup is the official tool for managing Rust versions and associated tools. It allows you to easily install and switch between different versions of Rust and manage toolchains.

### Install

---

**Option 1. Homebrew**:

```sh
brew install rustup
```

---

After installing rustup, initialize it with the following command.

```sh
rustup default stable
```

> [!TIP]
> To add the directory where cargo binaries are installed to your Path,
> add the following line to your shell configuration file (e.g. `~/.bashrc`):
>
> ```sh
> export PATH="$(dirname $(rustup which cargo)):$PATH"
> ```

### Install rust-analyzer (optional)

rust-analyzer is a popular language server for Rust that provides features like code completion, go to definition, and inline error messages.

To install rust-analyzer, run the following command:

```sh
rustup component add rust-analyzer
```

### Update Rustup and Rust toolchain

To update Rustup and the Rust toolchain to the latest stable version, run the following command:

```sh
rustup update
```

## Cargo

Cargo is Rust's package manager and build system. It simplifies the process of managing Rust projects, including building code, downloading dependencies, and running tests.

### Cargo commands

#### new

Create a new Rust project.

```sh
cargo new <project_name>
```

#### build

Compile the current Rust project.

```sh
cargo build
```

#### run

Build and run the current Rust project.

```sh
cargo run
```

#### test

Run tests for the current Rust project.

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

Rust module system has evolved over time, and there are two common styles for organizing modules in a Rust project: the old style using `mod.rs` files and the modern style using file names that match module names.

This two styles can coexist in the same project, but it's generally recommended to choose one style for consistency.
The modern style is often preferred for its simplicity and clarity.

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

- Use wilde card patttern at last in match sentenses
