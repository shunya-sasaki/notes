# LSP: Language Server Protocol

<!-- toc -->

- [📖 What is LSP](#-what-is-lsp)
  - [Key capabilities](#key-capabilities)
- [🎨 Formatting](#-formatting)
- [🔍 Linting](#-linting)
  - [Diagnostic severity](#diagnostic-severity)
  - [What diagnostics provide](#what-diagnostics-provide)
- [💡 Completion](#-completion)
  - [Completion item kinds](#completion-item-kinds)
  - [Trigger mechanisms](#trigger-mechanisms)
  - [Resolve](#resolve)
- [🔧 Tools](#-tools)
  - [Capabilities](#capabilities)
  - [Installs](#installs)
  - [Commands](#commands)
- [Editor settings](#editor-settings)
  - [Neovim](#neovim)
  - [VS Code](#vs-code)
  - [Zed](#zed)
- [References](#references)

<!-- /toc -->

## 📖 What is LSP

**Language Server Protocol (LSP)** は、コードエディター（クライアント）と
言語サーバー間の通信を標準化する JSON-RPC ベースのプロトコルです。
もともと Microsoft が Visual Studio Code 向けに開発したもので、現在はオープンスタンダードになっています。

LSP 以前は、すべてのエディターが各プログラミング言語の言語サポート
（自動補完、定義へのジャンプ、診断など）を
個別に実装する必要がありました。
これにより **M × N の問題** が生じていました — M 個のエディター × N 個の言語 = M×N の統合が必要でした。

LSP は共通のインターフェースを導入することでこの問題を解決します:

- **言語サーバー** が言語機能を提供します
  （補完、ホバー、診断、フォーマットなど）
- **エディター/クライアント** がサーバーにリクエストを送信し、結果をレンダリングします
- 通信は **JSON-RPC** を介して行われます（通常は stdio または TCP 経由）

これにより問題は **M + N** に削減されます — 各エディターは LSP クライアントを一度実装し、各言語はサーバーを一度実装するだけで済みます。

```text
┌────────────┐         JSON-RPC         ┌──────────────────┐
│   Editor   │ ◄──────────────────────► │  Language Server │
│  (Client)  │   stdio / TCP / pipe     │  (e.g. clangd)   │
└────────────┘                          └──────────────────┘
```

### Key capabilities

| Category     | Examples                                            |
| ------------ | --------------------------------------------------- |
| Navigation   | Go to definition, find references, document symbols |
| Intelligence | Completion, hover, signature help                   |
| Diagnostics  | Errors, warnings, hints                             |
| Editing      | Formatting, rename, code actions                    |

👉 [Official Specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/)

## 🎨 Formatting

LSP では、保存時にエディターが自動的に実行できるコードアクションがいくつか定義されており、コードをクリーンで一貫性のある状態に保ちます。

| Action           | Method / Code Action      | Description                                              |
| ---------------- | ------------------------- | -------------------------------------------------------- |
| Format           | `textDocument/formatting` | ドキュメント全体を再フォーマットします（空白、スタイル） |
| Fix All          | `source.fixAll`           | 安全な修正がある全ての診断を自動修正します               |
| Organize Imports | `source.organizeImports`  | インポートのソート、グループ化、未使用の削除を行います   |

- **Format** — `textDocument/formatting` で呼び出されます。ほとんどのサーバーでは外部フォーマッター（例: `ruff`、`prettier`、`dprint`）に委譲します。
- **Fix All** — コードアクション（`source.fixAll`）です。自動修正可能なすべての lint 診断を一度に適用します。`biome`、`ruff`、`eslint` などのツールがこれを公開しています。
- **Organize Imports** — コードアクション（`source.organizeImports`）です。インポートをアルファベット順にソートし、規約に従ってグループ化し、未使用のものを削除します。

エディターは通常、保存時にこれらのアクションを実行します。例えば Neovim（nvim-lspconfig）の場合:

## 🔍 Linting

**Linting** とは、ソースコードを静的に解析して潜在的なバグ、スタイル違反、疑わしいパターンを検出するプロセスです — コードを実際に実行せずに行います。

LSP では、lint の結果は `textDocument/publishDiagnostics` 通知を通じて**診断**として配信されます。言語サーバーがエディターに診断をプッシュし、エディターがそれらをインラインで表示します（波線の下線、ガターアイコンなど）。

### Diagnostic severity

| Severity      | Meaning                                                        | Example                           |
| ------------- | -------------------------------------------------------------- | --------------------------------- |
| `Error`       | コードが壊れており、正しくコンパイルまたは実行できません       | Syntax error, type mismatch       |
| `Warning`     | コードは動作しますが、おそらくミスまたは悪い慣行です           | Unused variable, unreachable code |
| `Information` | 改善のための提案です                                           | Deprecated API usage              |
| `Hint`        | マイナーなスタイルまたは規約に関する提案です                   | Naming convention violation       |

### What diagnostics provide

各診断には以下の情報が含まれます:

| Field      | Description                                                |
| ---------- | ---------------------------------------------------------- |
| `range`    | 正確な位置（開始/終了の行と列）                            |
| `severity` | Error、Warning、Information、または Hint                   |
| `code`     | ルール識別子（例: `no-unused-vars`、`E0308`）              |
| `source`   | 生成したツール（例: `ruff`、`eslint`）                     |
| `message`  | 問題の人間が読める説明                                     |

## 💡 Completion

**Completion** は、`textDocument/completion` によって駆動される、入力中にコンテキストに応じた提案を提供する機能です。

エディターが言語サーバーに補完リクエストを送信し、サーバーが候補アイテムのリストを返します。各アイテムにはラベル、種類、オプションの詳細/ドキュメントが含まれます。

### Completion item kinds

| Kind            | Description               | Example          |
| --------------- | ------------------------- | ---------------- |
| `Text`          | Plain text suggestion     | Template snippet |
| `Method`        | Instance method           | `.to_string()`   |
| `Function`      | Free function             | `println!()`     |
| `Constructor`   | Constructor               | `Vec::new()`     |
| `Field`         | Struct/class field        | `.name`          |
| `Variable`      | Local or global variable  | `count`          |
| `Class`         | Class or struct name      | `HashMap`        |
| `Interface`     | Interface or trait        | `Iterator`       |
| `Module`        | Module or namespace       | `std::io`        |
| `Property`      | Object property           | `.length`        |
| `Keyword`       | Language keyword          | `if`, `match`    |
| `Snippet`       | Snippet with placeholders | `for ... in ...` |
| `Enum`          | Enum type                 | `Option`         |
| `EnumMember`    | Enum variant              | `Some`, `None`   |
| `Constant`      | Constant value            | `MAX_SIZE`       |
| `TypeParameter` | Generic type parameter    | `T`, `E`         |

### Trigger mechanisms

| Trigger            | Description                                                              |
| ------------------ | ------------------------------------------------------------------------ |
| Typing             | 識別子を入力すると自動的に補完が表示されます                             |
| Trigger characters | 特定の文字（例: `.`、`::`、`/`）で補完が呼び出されます                   |
| Manual invocation  | ショートカット（例: `Ctrl+Space`）で明示的にトリガーされます             |

### Resolve

補完アイテムが選択されると、エディターは `completionItem/resolve` リクエストを送信して追加の詳細（ドキュメント、追加のテキスト編集）を遅延取得する場合があります。これにより、初期レスポンスを軽量に保ちます。

## 🔧 Tools

このセクションでは、LSP をサポートするさまざまな言語サーバーとフォーマッターを
その機能とインストール手順とともに一覧します。

### Capabilities

以下の表は各ツールの機能をまとめたものです:

| Name                  | Languages      | Format | Fix All | Organize Imports | Diagnostics | Completion |
| --------------------- | -------------- | :----: | :-----: | :--------------: | :---------: | :--------: |
| basedpyright          | Python         |   ❌   |   ❌    |        ✅        |     ✅      |     ✅     |
| bashls                | Shell/Bash     |   ❌   |   ❌    |        ❌        |     ✅      |     ✅     |
| biome                 | JS/TS/JSON/CSS |   ✅   |   ✅    |        ✅        |     ✅      |     ❌     |
| clangd                | C/C++          |   ✅   |   ❌    |        ✅        |     ✅      |     ✅     |
| cmake-language-server | CMake          |   ❌   |   ❌    |        ❌        |     ✅      |     ✅     |
| csharp-ls             | C#             |   ✅   |   ✅    |        ✅        |     ✅      |     ✅     |
| cssls                 | CSS            |   ✅   |   ❌    |        ❌        |     ✅      |     ✅     |
| dprint                | Multiple       |   ✅   |   ❌    |        ❌        |     ❌      |     ❌     |
| fortls                | Fortran        |   ❌   |   ❌    |        ❌        |     ✅      |     ✅     |
| hls                   | Haskell        |   ✅   |   ❌    |        ✅        |     ✅      |     ✅     |
| html                  | HTML           |   ✅   |   ❌    |        ❌        |     ✅      |     ✅     |
| markdown-oxide        | Markdown       |   ❌   |   ❌    |        ❌        |     ✅      |     ✅     |
| nixd                  | Nix            |   ✅   |   ❌    |        ❌        |     ✅      |     ✅     |
| oxfmt                 | JS/TS/JSON/CSS |   ✅   |   ❌    |        ✅        |     ❌      |     ❌     |
| oxlint                | JS/TS          |   ❌   |   ✅    |        ❌        |     ✅      |     ❌     |
| powershell_es         | PowerShell     |   ✅   |   ❌    |        ❌        |     ✅      |     ✅     |
| pyright               | Python         |   ❌   |   ❌    |        ✅        |     ✅      |     ✅     |
| roslyn-ls             | C#             |   ✅   |   ✅    |        ✅        |     ✅      |     ✅     |
| ruff                  | Python         |   ✅   |   ✅    |        ✅        |     ✅      |     ❌     |
| rust-analyzer         | Rust           |   ✅   |   ❌    |        ✅        |     ✅      |     ✅     |
| stylua                | Lua            |   ✅   |   ❌    |        ❌        |     ❌      |     ❌     |
| tailwindcss           | CSS            |   ❌   |   ❌    |        ❌        |     ✅      |     ✅     |
| taplo                 | TOML           |   ✅   |   ❌    |        ❌        |     ✅      |     ✅     |
| ty                    | Python         |   ❌   |   ❌    |        ❌        |     ✅      |     ✅     |
| vtsls                 | JS/TS          |   ✅   |   ✅    |        ✅        |     ✅      |     ✅     |

> [!NOTE]
> dprint は複数の言語をサポートしています
> （JavaScript、TypeScript、JSON、CSS、HTML、Markdown など）。

#### Recommended combinations

以下の表は各言語に推奨されるツールの組み合わせを示しています。
複数のツールが記載されている場合、それらは互いを補完します
（例: `ruff` がフォーマット/リンティングを処理し、`ty` が型認識の診断と補完を提供します）。

| Language   | Fix All   | Organize Imports | Format        | Diagnostics         | Completion     |
| ---------- | --------- | ---------------- | ------------- | ------------------- | -------------- |
| C#         | roslyn-ls | roslyn-ls        | roslyn-ls     | roslyn-ls           | roslyn-ls      |
| C/C++      | —         | clangd           | clangd        | clangd              | clangd         |
| CMake      | —         | —                | —             | cmake-ls            | cmake-ls       |
| CSS        | —         | —                | cssls         | cssls + tailwindcss | tailwindcss    |
| Fortran    | —         | —                | —             | fortls              | fortls         |
| HTML       | —         | —                | html          | html                | html           |
| Haskell    | —         | hls              | hls           | hls                 | hls            |
| JS/TS      | biome     | biome            | biome         | biome + vtsls       | vtsls          |
| JS/TS      | oxfmt     | oxlint           | oxfmt         | oxlint              | vtsls          |
| JSON       | biome     | —                | biome         | biome               | —              |
| Lua        | —         | —                | stylua        | —                   | —              |
| Markdown   | —         | —                | —             | markdown-oxide      | markdown-oxide |
| Nix        | —         | —                | nixd          | nixd                | nixd           |
| PowerShell | —         | —                | powershell_es | powershell_es       | powershell_es  |
| Python     | ruff      | ruff             | ruff          | ty                  | ty             |
| Rust       | —         | rust-analyzer    | rust-analyzer | rust-analyzer       | rust-analyzer  |
| Shell/Bash | —         | —                | —             | bashls              | bashls         |
| TOML       | —         | —                | taplo         | taplo               | taplo          |

> [!NOTE]
>
> - Python では、診断と補完に `ty` の代わりに `basedpyright` を使用できます。
>   `basedpyright` は Pylance ライクな機能を持つより成熟したオプションです。
> - C# では、`csharp-ls` は `roslyn-ls` の軽量な代替手段です。
> - JS/TS では、`dprint` を `biome` の代替フォーマッターとして使用できます。

### Installs

これらのツールはさまざまなパッケージマネージャーを使用してインストールできます。
以下の表は各ツールのインストールオプションをまとめたものです:

| Name                          | VS Code | Scoop | APT | Snap | Homebrew | Nix | npm | uv  | cargo | dotnet | mise |
| ----------------------------- | :-----: | :---: | :-: | :--: | :------: | :-: | :-: | :-: | :---: | :----: | :--: |
| basedpyright                  |   ✅    |  ❌   | ❌  |  ❌  |    ✅    | ✅  | ✅  | ✅  |  ❌   |   ❌   |  ✅  |
| bashls (bash language server) |   ✅    |  ❌   | ❌  |  ✅  |    ✅    | ✅  | ✅  | ❌  |  ❌   |   ❌   |  ✅  |
| biome                         |   ✅    |  ✅   | ❌  |  ❌  |    ✅    | ✅  | ✅  | ❌  |  ✅   |   ❌   |  ✅  |
| clangd                        |   ✅    |  ✅   | ✅  |  ✅  |    ✅    | ✅  | ❌  | ❌  |  ❌   |   ❌   |  ❌  |
| cmake-language-server         |    ⚠️    |  ❌   | ❌  |  ✅  |    ✅    | ✅  | ❌  | ✅  |  ❌   |   ❌   |  ✅  |
| csharp-ls                     |   ✅    |  ❌   | ❌  |  ❌  |    ✅    | ✅  | ❌  | ❌  |  ❌   |   ✅   |  ✅  |
| dprint                        |    ⚠️    |  ✅   | ❌  |  ❌  |    ✅    | ✅  | ✅  | ✅  |  ✅   |   ❌   |  ✅  |
| fortls                        |    ⚠️    |  ❌   | ❌  |  ❌  |    ✅    | ✅  | ❌  | ✅  |  ❌   |   ❌   |  ✅  |
| haskell-language-server       |   ✅    |  ✅   | ❌  |  ❌  |    ✅    | ✅  | ❌  | ❌  |  ❌   |   ❌   |  ❌  |
| markdown-oxide                |   ✅    |  ✅   | ❌  |  ❌  |    ✅    | ✅  | ❌  | ❌  |  ✅   |   ❌   |  ✅  |
| nixd                          |   ✅    |  ❌   | ❌  |  ❌  |    ❌    | ✅  | ❌  | ❌  |  ❌   |   ❌   |  ❌  |
| oxfmt                         |   ✅    |  ❌   | ❌  |  ❌  |    ✅    | ✅  | ✅  | ❌  |  ❌   |   ❌   |  ❌  |
| oxlint                        |   ✅    |  ❌   | ❌  |  ❌  |    ✅    | ✅  | ✅  | ❌  |  ✅   |   ❌   |  ❌  |
| powershelleditorservice       |   ✅    |  ✅   | ❌  |  ❌  |    ❌    | ✅  | ❌  | ❌  |  ❌   |   ❌   |  ❌  |
| pyright                       |   ✅    |  ❌   | ❌  |  ❌  |    ✅    | ✅  | ✅  | ✅  |  ❌   |   ❌   |  ✅  |
| roslyn-ls                     |   ✅    |  ❌   | ❌  |  ❌  |    ✅    | ✅  | ❌  | ❌  |  ❌   |   ✅   |  ✅  |
| ruff                          |   ✅    |  ✅   | ❌  |  ✅  |    ✅    | ✅  | ❌  | ✅  |  ❌   |   ❌   |  ✅  |
| rust-analyzer                 |   ✅    |  ✅   | ❌  |  ❌  |    ✅    | ✅  | ❌  | ❌  |  ❌   |   ❌   |  ✅  |
| stylua                        |    ⚠️    |  ✅   | ❌  |  ❌  |    ✅    | ✅  | ❌  | ❌  |  ✅   |   ❌   |  ✅  |
| tailwindcss-language-server   |   ✅    |  ❌   | ❌  |  ❌  |    ✅    | ✅  | ✅  | ❌  |  ❌   |   ❌   |  ✅  |
| taplo                         |   ✅    |  ✅   | ❌  |  ❌  |    ✅    | ✅  | ✅  | ❌  |  ✅   |   ❌   |  ✅  |
| ty                            |   ✅    |  ✅   | ❌  |  ❌  |    ✅    | ✅  | ❌  | ✅  |  ❌   |   ❌   |  ✅  |
| vscode-css-language-server    |   ✅    |  ❌   | ❌  |  ❌  |    ✅    | ✅  | ✅  | ❌  |  ❌   |   ❌   |  ✅  |
| vscode-html-language-server   |   ✅    |  ❌   | ❌  |  ✅  |    ✅    | ✅  | ✅  | ❌  |  ❌   |   ❌   |  ✅  |
| vtsls                         |   ✅    |  ❌   | ❌  |  ✅  |    ✅    | ✅  | ✅  | ❌  |  ❌   |   ❌   |  ✅  |

- ✅: このパッケージマネージャーでインストール可能
- ⚠️: このパッケージマネージャーでインストール可能ですが、
  追加の設定（例: 手動のパス設定、バイナリのインストール）が必要な場合があります
- ❌: このパッケージマネージャーではインストールできません

> [!NOTE]
>
> OS 別のパッケージマネージャーの利用可否:
>
> | Package Manager     | OS                    | Description                                 |
> | ------------------- | --------------------- | ------------------------------------------- |
> | APT (Debian/Ubuntu) | Linux (Debian/Ubuntu) | System package manager                      |
> | Homebrew            | MacOS / Linux         | Package manager for macOS and Linux         |
> | Nix                 | Linux / MacOS         | Declarative package manager                 |
> | Scoop               | Windows               | Command-line installer for Windows          |
> | Snap                | Linux                 | Universal Linux package manager             |
> | VS Code             | Cross platform        | Extension marketplace for VS Code           |
> | cargo               | Cross platform        | Rust package manager                        |
> | dotnet              | Cross platform        | .NET package manager                        |
> | mise                | Cross platform        | Polyglot environment / tool version manager |
> | npm                 | Cross platform        | Node.js package manager                     |
> | uv                  | Cross platform        | Python package installer (by Astral)        |

> [!TIP]
>
> - _roslyn-ls_ は VS Code の _C# Dev Kit_ 拡張機能にバンドルされているため、
>   VS Code Marketplace からインストールできます。
> - _vtsls_ は VS Code の組み込み TypeScript サポートから抽出された LSP ラッパーで、
>   他のエディターに同じ機能を提供するために設計されています。\
>   VS Code 拡張機能としては利用できません。
> - _Pylance_ は VS Code 専用のクローズドソース Python 言語サーバーです。\
>   _basedpyright_ はオープンソースの _pyright_ の拡張コミュニティフォークで、
>   標準 LSP クライアントに Pylance ライクな高度な機能を提供することを目指しています。
> - _vscode-html-language-server_ と _vscode-css-language-server_ は
>   _vscode-langservers-extracted_ パッケージの一部です。

### Commands

言語サーバーを起動するには、ターミナルで以下のコマンドを実行します。

| Name                            | Command                                                      |
| ------------------------------- | ------------------------------------------------------------ |
| basedpyright                    | `basedpyright-langserver --stdio`                            |
| bashls                          | `bash-language-server start`                                 |
| biome                           | `biome lsp-proxy`                                            |
| clangd                          | `clangd`                                                     |
| cmake-language-server           | `cmake-language-server`                                      |
| csharp-ls                       | `csharp-ls`                                                  |
| dprint                          | `dprint lsp`                                                 |
| fortls                          | `fortls`                                                     |
| haskell-language-server-wrapper | `haskell-language-server-wrapper --lsp`                      |
| markdown-oxide                  | `markdown-oxide`                                             |
| nixd                            | `nixd`                                                       |
| oxfmt                           | `oxfmt --lsp`                                                |
| oxlint                          | `oxlint --lsp`                                               |
| powerhsell_es                   | `pwsh ***/PowerShellEditorServices/Start-EditorServices.ps1` |
| pyright                         | `pyright-langserver --stdio`                                 |
| ruff                            | `ruff server`                                                |
| rust-analyzer                   | `rust-analyzer`                                              |
| stylua                          | `stylua-lsp`                                                 |
| tailwindcss                     | `tailwindcss-language-server --stdio`                        |
| taplo                           | `taplo lsp stdio`                                            |
| ty                              | `ty server`                                                  |
| vscode-css-language-server      | `vscode-css-language-server --stdio`                         |
| vscode-html-language-server     | `vscode-html-language-server --stdio`                        |
| vtsls                           | `vtsls --stdio`                                              |

> [!TIP]
> 一般的に、LSP サーバーはエディターの組み込み LSP クライアントまたはプラグイン
> （例: nvim-lspconfig）を通じて実行します。

## Editor settings

### Neovim

Neovim はバージョン 0.5 以降、組み込みの LSP クライアントサポートを持っており、
任意の LSP サーバーに接続してその機能をエディター内で直接使用できます。

#### nvim-lspconfig

[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) の使用をお勧めします。
Neovim での LSP サーバーの設定と管理を簡単にしてくれます。

[lazy.nvim](https://github.com/folke/lazy.nvim) を使用している場合は、
lua ファイル（例: `lua/plugins/lsp.lua`）を以下の内容で作成します:

```lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" }, -- If you use blink.cmp for completion
    config = function()
      -- Json
      vim.lsp.enable("biome")
      vim.lsp.enable("vtsls")
      vim.lsp.enable("tailwindcss")
      -- Python
      vim.lsp.enable("ruff")
      vim.lsp.enable("ty")
      })
    end,
  },
}
```

LSP サーバーを有効にするには、`vim.lsp.enable(<lsp name>)` を実行します。

LSP の設定は `after/lsp/<lsp name>.lua`（例: `after/lsp/ruff.lua`）に記述できます。
`after/lsp/ruff.lua` の内容は以下のようになります:

```lua
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
}
```

> [!TIP]
> 詳細な設定オプションについては、
> [all configs](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md) を参照してください。
> LSP サーバーの設定ファイルの書き方を確認できます。

#### Auto format on save in Neovim

Neovim では、設定ファイル（例: _init.lua_）に `vim.api.nvim_create_autocmd` コマンドを記述することで、保存時の自動フォーマットを有効にできます。

`textDocument/formatting` はコマンド `vim.lsp.buf.format` で実行でき、
`source.fixAll` は `vim.lsp.buf.code_action("source.fixAll")` で、
`source.organizeImports` は `vim.lsp.buf.code_action("source.organizeImports")` で Neovim で実行できます。

ただし残念ながら、`vim.lsp.buf.code_action` コマンドは非同期で実行されるため、
同じ autocmd 内で `source.fixAll` と `source.organizeImports` を実行することはできません。

_❌ NG_

```lua
-- NOTE:
-- 以下のコードでは、`vim.lsp.format` は同期的に実行されますが、
-- vim.lsp.buf.code_action は非同期で実行されます。
-- これにより、コードアクションがフォーマット前に完了せず、
-- 修正されていないコードに対してフォーマットアクションが実行されます。

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "python",
  },
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.code_action("source.fixAll") -- run asynchronously
        vim.lsp.buf.code_action("source.organizeImports") -- run asynchronously
        vim.lsp.format({
          async = false
          })
      end,
    })
  end,
})
```

これを修正するには、`Client:request_sync` コマンドを使用します。
以下のコードはコードアクションを同期的に実行するため、
フォーマットアクションは修正済みのコードに対して実行されます。

_✅ OK_

```lua
-- helper functions ============================================================
local function full_document_range(bufnr)
	local last_line = vim.api.nvim_buf_line_count(bufnr) - 1
	local last_text = (vim.api.nvim_buf_get_lines(bufnr, last_line, last_line + 1, true)[1] or "")
	return {
		start = { line = 0, character = 0 },
		["end"] = { line = last_line, character = #last_text },
	}
end

function call_format_synchronously(lsp_name)
	vim.lsp.buf.format({
		async = false,
		filter = function(client)
			return client.name == lsp_name
		end,
	})
end

function call_code_action_synchronously(lsp_name, code_action)
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = lsp_name })
	if #clients == 0 then
		return
	end
	local params = vim.lsp.util.make_range_params(0, clients[1].offset_encoding)
	params.context = {
		only = { code_action },
		diagnostics = {},
	}
	params.range = full_document_range(bufnr)
	local timeout_ms = 3000
	local response = clients[1]:request_sync("textDocument/codeAction", params, timeout_ms, bufnr)

	if not response or not response.result then
		vim.notify("No response from " .. lsp_name .. " for organizing imports", vim.log.levels.WARN)
		return
	end

	local action = nil
	for _, res in ipairs(response.result or {}) do
		if res.isPreferred then
			action = res
			break
		end
	end
	if not action then
		return
	end
	local resolved = clients[1]:request_sync("codeAction/resolve", action, timeout_ms, bufnr)

	if resolved and resolved.result then
		action = resolved.result
	end
	if action.edit then
		vim.lsp.util.apply_workspace_edit(action.edit, clients[1].offset_encoding)
	elseif action.command then
		clients[1]:execute_command(action.command)
	end
end

-- define autocmds ============================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "python",
  },
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        call_code_action_synchronously("ruff", "source.fixAll.ruff")
        call_code_action_synchronously("ruff", "source.organizeImports.ruff")
        call_format_synchronously("ruff")
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "typescript",
    "typescriptreact",
  },
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        utils.call_code_action_synchronously("biome", "source.fixAll.biome")
        utils.call_code_action_synchronously("biome", "source.organizeImports.biome")
        utils.call_format_synchronously("biome")
      end,
    })
  end,
})
```

### VS Code

VS Code では、マーケットプレイスから拡張機能として LSP サーバーをインストールできます。
拡張機能は、対応する種類のファイルを開くと自動的に言語サーバーを起動します。

#### Configuration for LSP in VS Code

VS Code で LSP 機能を設定するには、_settings.json_ ファイルに設定を追加します。
例えば、`ruff` と `ty` を使用して Python のリンティング診断と補完を有効にするには:

```json
{
  "ruff.enable": true,
  "ty.enable": true,
  "python.languageServer": "Pylance",
  "python.analysis.typeCheckingMode": "basic"
}
```

#### Format on save in VS Code

VS Code で保存時フォーマットを有効にするには、_settings.json_ に設定を追加します。
フォーマットを有効にするには、`editor.formatOnSave` を `true` に設定し、
各言語で保存時に実行するコードアクションを指定します。

```json
{
  "editor.formatOnSave": true,
  "[python]": {
    "editor.codeActionsOnSave": {
      "source.fixAll.ruff": true,
      "source.organizeImports.ruff": true
    }
  },
  "[javascript]": {
    "editor.codeActionsOnSave": {
      "source.fixAll.biome": true,
      "source.organizeImports.biome": true
    }
  },
  "[typescript]": {
    "editor.codeActionsOnSave": {
      "source.fixAll.biome": true,
      "source.organizeImports.biome": true
    }
  }
}
```

> [!TIP]
> 特定の言語に対して自動フォーマットを有効にしたい場合は、
> 以下のように言語固有のセクションに `editor.formatOnSave` 設定を記述できます:
>
> ```json
> "[python]": {
>   "editor.formatOnSave": true,
>   "editor.codeActionsOnSave": {
>     "source.fixAll.ruff": true,
>     "source.organizeImports.ruff": true
>   }
> }
> ```

### Zed

Zed で LSP 機能を有効にするには、Zed マーケットプレイスから対応する言語サーバー拡張機能をインストールします。インストール後、対応する種類のファイルを開くと言語サーバーが自動的に起動します。

システムにインストールされているツールを Zed の組み込み LSP サポートで使用することもできます。

#### Configuration for LSP in Zed

Zed で LSP 機能を設定するには、_settings.json_ ファイルに設定を追加します。
例えば、`ruff` と `ty` を使用して Python のリンティング診断と補完を有効にするには:

```json
{
  "lsp": {
    "ruff": {
      "binary": {
        "path": "ruff",
        "arguments": ["server"]
      }
    },
    "ty": {
      "binary": {
        "path": "ty",
        "arguments": ["server"]
      }
    }
  }
}
```

言語に対して LSP ツールを有効にするには、_settings.json_ の `languages` セクションを以下のように編集します:

```json
{
  "languages": {
    "python": {
      "lsp": ["ruff", "ty"]
    }
  }
}
```

> [!TIP]
> Zed では、一部の言語サーバーがデフォルトで有効になっています。
> 例えば、Python では `ruff` と `basedpyright` が有効です。
> デフォルトの言語サーバーを無効にしたい場合は、
> 言語固有のセクションで `!<lsp name>` を使用して `lsp` フィールドを設定します:
>
> ```json
> {
>   "languages": {
>     "python": {
>       "lsp": ["!basedpyright", "ruff", "ty"]
>     }
> }
> ```

#### Format on save in Zed

Zed で保存時フォーマットを有効にするには、_settings.json_ ファイルの
`languages` セクションに以下の設定を追加します。

```json
{
  "languages": {
    "Python": {
      "language_servers": ["!basedpyright", "ruff", "ty"]
      "format_on_save": "on",
      "formatter": "language_server",
      "code_action_format": {
        "source.fixAll.ruff": true,
        "source.organizeImports.ruff": true
      },
    }
  }
}
```

## References
