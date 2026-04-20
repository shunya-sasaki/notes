# Scoop: Command-Line Installer for Windows

In this document, we will explore Scoop, a command-line installer for Windows.

- [What is Scoop?](#what-is-scoop)
- [Key Features](#key-features)
- [How to Install Scoop](#how-to-install-scoop)

> [!NOTE]
> [Scoop official page](https://scoop.sh/)

## What is Scoop?

Scoop is a command-line installer for Windows.
It enables users to find, install, update, and uninstall software
and developer tools directly from the terminal.

## Key Features

- **Portability:** By default, Scoop installs programs into a user's home directory (`~/scoop`), making them portable and contained.
- **No UAC Popups:** Because it installs to the user directory, it generally doesn't require administrator privileges, avoiding annoying User Account Control (UAC) prompts.
- **Scriptable:** Being a command-line tool, it's easy to script and automate software installations.
- **Large Repository:** It has access to a wide variety of applications through its main "bucket" and additional community buckets.

## How to Install Scoop

Run the following commands in PowerShell to install Scoop.

```ps1
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```
