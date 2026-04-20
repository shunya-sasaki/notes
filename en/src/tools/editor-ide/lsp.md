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

The **Language Server Protocol (LSP)** is a JSON-RPC-based protocol
that standardizes the communication between code editors (clients)
and language servers. It was originally developed by Microsoft for Visual Studio Code and is now an open standard.

Before LSP, every editor had to implement language support
(autocompletion, go-to-definition, diagnostics, etc.)
individually for each programming language.
This created an **M × N problem** — M editors × N languages = M×N integrations.

LSP solves this by introducing a common interface:

- A **language server** provides language features
  (completion, hover, diagnostics, formatting, etc.)
- An **editor/client** sends requests to the server and renders the results
- Communication happens over **JSON-RPC** (typically via stdio or TCP)

This reduces the problem to **M + N** — each editor implements the LSP client once, and each language implements the server once.

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

LSP defines several code actions that editors can run automatically on save to keep code clean and consistent.

| Action           | Method / Code Action      | Description                                      |
| ---------------- | ------------------------- | ------------------------------------------------ |
| Format           | `textDocument/formatting` | Reformat the entire document (whitespace, style) |
| Fix All          | `source.fixAll`           | Auto-fix all diagnostics that have a safe fix    |
| Organize Imports | `source.organizeImports`  | Sort, group, and remove unused imports           |

- **Format** — invoked via `textDocument/formatting`. Delegates to an external formatter in most servers (e.g. `ruff`, `prettier`, `dprint`).
- **Fix All** — a code action (`source.fixAll`). Applies all auto-fixable lint diagnostics at once. Tools like `biome`, `ruff`, and `eslint` expose this.
- **Organize Imports** — a code action (`source.organizeImports`). Sorts imports alphabetically, groups them by convention, and removes unused ones.

Editors typically run these actions on save. For example in Neovim (nvim-lspconfig):

## 🔍 Linting

**Linting** is the process of statically analyzing source code to detect potential bugs, style violations, and suspicious patterns — without actually running the code.

In LSP, linting results are delivered as **diagnostics** via the `textDocument/publishDiagnostics` notification. The language server pushes diagnostics to the editor, which displays them inline (squiggly underlines, gutter icons, etc.).

### Diagnostic severity

| Severity      | Meaning                                              | Example                           |
| ------------- | ---------------------------------------------------- | --------------------------------- |
| `Error`       | Code is broken and will not compile or run correctly | Syntax error, type mismatch       |
| `Warning`     | Code works but is likely a mistake or bad practice   | Unused variable, unreachable code |
| `Information` | Suggestion for improvement                           | Deprecated API usage              |
| `Hint`        | Minor stylistic or conventional suggestion           | Naming convention violation       |

### What diagnostics provide

Each diagnostic contains the following information:

| Field      | Description                                      |
| ---------- | ------------------------------------------------ |
| `range`    | Exact location (start/end line and column)       |
| `severity` | Error, Warning, Information, or Hint             |
| `code`     | Rule identifier (e.g. `no-unused-vars`, `E0308`) |
| `source`   | Tool that produced it (e.g. `ruff`, `eslint`)    |
| `message`  | Human-readable description of the issue          |

## 💡 Completion

**Completion** provides context-aware suggestions as you type, powered by `textDocument/completion`.

The editor sends a completion request to the language server, which returns a list of candidate items. Each item includes a label, kind, and optional detail/documentation.

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

| Trigger            | Description                                                |
| ------------------ | ---------------------------------------------------------- |
| Typing             | Completion appears automatically as you type identifiers   |
| Trigger characters | Special characters (e.g. `.`, `::`, `/`) invoke completion |
| Manual invocation  | Explicitly triggered by shortcut (e.g. `Ctrl+Space`)       |

### Resolve

When a completion item is selected, the editor may send a `completionItem/resolve` request to fetch additional details (documentation, additional text edits) lazily, keeping the initial response lightweight.

## 🔧 Tools

In this section, we list various language servers and formatters
that support LSP, along with their capabilities and installation instructions.

### Capabilities

The following table summarizes the capabilities of each tool:

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
> dprint supports multiple languages
> (JavaScript, TypeScript, JSON, CSS, HTML, Markdown, etc.).

#### Recommended combinations

The following table shows recommended tool combinations for each language.
When multiple tools are listed, they complement each other
(e.g. `ruff` handles formatting/linting while `ty` provides type-aware diagnostics and completion).

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
> - For Python, you can use `basedpyright` instead of `ty` for diagnostics and completion.
>   `basedpyright` is a more mature option with Pylance-like features.
> - For C#, `csharp-ls` is a lightweight alternative to `roslyn-ls`.
> - For JS/TS, `dprint` can be used as an alternative formatter to `biome`.

### Installs

You can install these tools using various package managers.
The following table summarizes the installation options for each tool:

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

- ✅: Can be installed via this package manager
- ⚠️: Can be installed via this package manager,
  but may require additional configuration (e.g. manual path setup, install binary)
- ❌: Cannot be installed via this package manager

> [!NOTE]
>
> Package manager availability by OS:
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
> - _roslyn-ls_ is bundled with the _C# Dev Kit_ extension in VS Code,
>   so you can install it via the VS Code Marketplace.
> - _vtsls_ is an LSP wrapper extracted from VS Code's built-in TypeScript support,
>   designed to provide the same features for other editors.\
>   It is not available as a VS Code extension itself.
> - _Pylance_ is a closed-source Python language server exclusive to VS Code.\
>   _basedpyright_ is an enhanced community fork of the open-source _pyright_,
>   aiming to bring Pylance-like advanced features to standard LSP clients.
> - _vscode-html-language-server_ and _vscode-css-language-server_ are
>   part of the _vscode-langservers-extracted_ package.

### Commands

To start the language server, run the following command in your terminal.

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
> As generally, you run LSP servers via either your editor's built-in LSP client or a plugin
> (e.g. nvim-lspconfig).

## Editor settings

### Neovim

Neovim has built-in LSP client support since version 0.5, allowing you to connect
to any LSP server and use its features directly in the editor.

#### nvim-lspconfig

I recommend you to use [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).
It helps you easily configure and manage LSP servers in Neovim.

If you use [lazy.nvim](https://github.com/folke/lazy.nvim),
create a lua file (e.g., `lua/plugins/lsp.lua`) with the following content:

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

To enable an LSP server, you have to run `vim.lsp.enable(<lsp name>)`.

And you can write the lsp settings in `after/lsp/<lsp name>.lua` (e.g., `after/lsp/ruff.lua`).
The content of `after/lsp/ruff.lua` can be:

```lua
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
}
```

> [!TIP]
> For detailed configuration options, view
> [all configs](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md).
> You can see how to write the setting files for LSP servers.

#### Auto format on save in Neovim

In neovim, you enable auto format on save to
write `vim.api.nvim_create_autocmd` command in your setting files (e.g., _init.lua_).

You can run `textDocument/formatting` with the command `vim.lsp.buf.format` and
run `source.fixAll` with `vim.lsp.buf.code_action("source.fixAll")`,
`source.organizeImports` with `vim.lsp.buf.code_action("source.organizeImports")` in Neovim.

But unfortunately, `vim.lsp.buf.code_action` command runs asynchronously,
so you can't run `source.fixAll` and `source.organizeImports` in the same autocmd.

_❌ NG_

```lua
-- NOTE:
-- In the following code, `vim.lsp.format` runs synchronously,
-- but vim.lsp.buf.code_action runs asynchronously.
-- This causes the code actions to not complete before formatting,
-- resulting in the format action running on un-fixed code.

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

To fix this, you can use `Client:request_sync` command.
The following code runs the code actions synchronously,
so the format action runs on fixed code.

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

In VS Code, you can install LSP servers as extensions from the marketplace.
The extension will automatically start the language server
when you open a file of the corresponding type.

#### Configuration for LSP in VS Code

To configure LSP features in VS Code, you can add settings to your _settings.json_ file.
For example, to enable linting diagnostics and completion for Python using `ruff` and `ty`,

```json
{
  "ruff.enable": true,
  "ty.enable": true,
  "python.languageServer": "Pylance",
  "python.analysis.typeCheckingMode": "basic"
}
```

#### Format on save in VS Code

To enable format on save in VS Code, add the settings to your _settings.json_.
To enable format, you can set `editor.formatOnSave` to `true`
and specify the code actions to run on save for each language.

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
> If you'd like to enable auto format for a specific language,
> you can write `editor.formatOnSave` setting in the language-specific
> section as follows:
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

To enable LSP features in Zed, you can install the corresponding language server extensions
from the Zed marketplace. Once installed, the language server will automatically start when you open a file of the corresponding type.

You can also use the tools that are installed on your system with Zed's built-in LSP support.

#### Configuration for LSP in Zed

To configure LSP features in Zed, you can add settings to your _settings.json_ file.
For example, to enable linting diagnostics and completion for Python using `ruff` and `ty`,

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

To enable LSP tools for languages, you can edit the `languages` section in _settings.json_ as follows:

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
> In Zed, some language servers are enabled by default.
> For example, `ruff` and `basedpyright` are enabled for Python.
> If you'd like to disable the default language servers,
> you can set the `lsp` field with `!<lsp name>` in the
> language-specific section as follows:
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

To enable format on save in Zed, you can add the following settings to
`languages` section in your _settings.json_ file.

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
