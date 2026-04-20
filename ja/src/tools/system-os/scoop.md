# Scoop: Command-Line Installer for Windows

このドキュメントでは、Windows 向けコマンドラインインストーラーである Scoop について説明します。

- [What is Scoop?](#what-is-scoop)
- [Key Features](#key-features)
- [How to Install Scoop](#how-to-install-scoop)

> [!NOTE]
> [Scoop official page](https://scoop.sh/)

## What is Scoop?

Scoop は Windows 向けのコマンドラインインストーラーです。
ターミナルから直接ソフトウェアや開発ツールの検索、インストール、更新、
アンインストールを行えます。

## Key Features

- **Portability:** デフォルトでは、Scoop はユーザーのホームディレクトリ（`~/scoop`）にプログラムをインストールするため、ポータブルで自己完結的です。
- **No UAC Popups:** ユーザーディレクトリにインストールするため、通常は管理者権限が不要で、煩わしいユーザーアカウント制御（UAC）プロンプトが表示されません。
- **Scriptable:** コマンドラインツールであるため、ソフトウェアのインストールをスクリプト化して自動化することが容易です。
- **Large Repository:** メインの「bucket」と追加のコミュニティ bucket を通じて、幅広いアプリケーションにアクセスできます。

## How to Install Scoop

PowerShell で以下のコマンドを実行して Scoop をインストールします。

```ps1
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```
