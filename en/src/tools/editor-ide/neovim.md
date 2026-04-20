# Neovim

![Neovim](https://img.shields.io/badge/Neovim-57A143?logo=neovim&labelColor=gray&logoColor=white)

## 📦 Install

**Option 1: Install via Homebrew (macOS)**:

```sh
brew install neovim
```

**Option 2: Install via Apt (Linux/Ubuntu)**:

```sh
apt install neovim
```

**Option 3: Install via Scoop (Windows)**:

```ps1
scoop install main/neovim
```

**Option 4: Install via Nix Home Manager**:

```nix
{ pkgs }:

with pkgs; [
  neovim
]
```

## 🛠️ Plugins

| Category        | Plugin                              | Description                                    |
| --------------- | ----------------------------------- | ---------------------------------------------- |
| Color           | catgoose/nvim-colorizer.lua         | Display color codes inline                     |
| Colorscheme     | catppuccin/nvim                     | Catppuccin color scheme                        |
| Colorscheme     | EdenEast/nightfox.nvim              | Nightfox color scheme collection               |
| Colorscheme     | folke/tokyonight.nvim               | Tokyo Night color scheme                       |
| Colorscheme     | marko-cerovac/material.nvim         | Material Design color scheme                   |
| Colorscheme     | navarasu/onedark.nvim               | One Dark color scheme                          |
| Colorscheme     | rebelot/kanagawa.nvim               | Kanagawa color scheme                          |
| Colorscheme     | sainnhe/sonokai                     | Sonokai color scheme                           |
| Colorscheme     | scottmckendry/cyberdream.nvim       | Cyberdream color scheme                        |
| Comment         | folke/todo-comments.nvim            | Highlight TODO comments                        |
| Completion      | hrsh7th/nvim-cmp                    | Autocompletion engine                          |
| Completion      | hrsh7th/cmp-buffer                  | Buffer completion source                       |
| Completion      | hrsh7th/cmp-cmdline                 | Cmdline completion source                      |
| Completion      | hrsh7th/cmp-nvim-lsp                | LSP completion source                          |
| Completion      | hrsh7th/cmp-path                    | Path completion source                         |
| Completion      | L3MON4D3/LuaSnip                    | Snippet engine                                 |
| Completion      | onsails/lspkind-nvim                | LSP kind icons for completion menu             |
| Completion      | petertriho/cmp-git                  | Git completion source                          |
| Completion      | saadparwaiz1/cmp_luasnip            | LuaSnip completion source                      |
| Copilot         | zbirenbaum/copilot.lua              | GitHub Copilot integration                     |
| Copilot         | zbirenbaum/copilot-cmp              | Copilot completion source for nvim-cmp         |
| Debugging       | jay-babu/mason-nvim-dap.nvim        | Mason integration for DAP                      |
| Debugging       | mfussenegger/nvim-dap               | Debug Adapter Protocol client                  |
| Debugging       | rcarriga/nvim-dap-ui                | UI for nvim-dap                                |
| Debugging       | theHamsta/nvim-dap-virtual-text     | Virtual text for debugger values               |
| Diagnostics     | folke/trouble.nvim                  | Diagnostic list and quickfix viewer            |
| Editing Support | kylechui/nvim-surround              | Surround text objects                          |
| Editing Support | numToStr/Comment.nvim               | Comment/uncomment code                         |
| Editing Support | phaazon/hop.nvim                    | Easymotion-like navigation                     |
| Editing Support | windwp/nvim-autopairs               | Auto-pairing brackets and quotes               |
| File Explorer   | mikavilpas/yazi.nvim                | Yazi file manager integration                  |
| Fuzzy Finder    | nvim-telescope/telescope.nvim       | Fuzzy finder                                   |
| Git             | lewis6991/gitsigns.nvim             | Git signs in sign column                       |
| Indent          | lukas-reineke/indent-blankline.nvim | Indentation guide lines                        |
| Keybinding      | folke/which-key.nvim                | Keybinding popup guide                         |
| LSP             | jay-babu/mason-null-ls.nvim         | Mason integration for null-ls                  |
| LSP             | mason-org/mason-lspconfig.nvim      | Mason integration for LSP servers              |
| LSP             | mason-org/mason.nvim                | Package manager for LSP/DAP/linters/formatters |
| LSP             | neovim/nvim-lspconfig               | LSP configuration                              |
| LSP             | nvimtools/none-ls.nvim              | Null-ls for diagnostics and formatting         |
| LSP             | nvimtools/none-ls-extras.nvim       | Additional null-ls sources                     |
| Preview         | hedyhli/markdown-toc.nvim           | Markdown table of contents generator           |
| Statusline      | nvim-lualine/lualine.nvim           | Statusline and tabline                         |
| Statusline      | nvim-tree/nvim-web-devicons         | File type icons                                |
| Syntax          | nvim-treesitter/nvim-treesitter     | Treesitter syntax highlighting                 |
| Terminal        | akinsho/toggleterm.nvim             | Toggle terminal windows                        |
| UI              | folke/noice.nvim                    | Enhanced command line and UI                   |
| UI              | folke/snacks.nvim                   | Collection of UI utilities                     |
| UI              | rcarriga/nvim-notify                | Notification manager                           |
| Utility         | MunifTanjim/nui.nvim                | UI component library                           |
| Utility         | nvim-lua/plenary.nvim               | Lua utility library                            |
| Utility         | nvim-mini/mini.nvim                 | Minimal plugin collection                      |
| Utility         | nvim-neotest/nvim-nio               | Asynchronous IO library                        |
