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

| Category        | Plugin                              | Description                                          |
| --------------- | ----------------------------------- | ---------------------------------------------------- |
| Color           | catgoose/nvim-colorizer.lua         | カラーコードをインライン表示します                   |
| Colorscheme     | catppuccin/nvim                     | Catppuccin カラースキーム                            |
| Colorscheme     | EdenEast/nightfox.nvim              | Nightfox カラースキームコレクション                  |
| Colorscheme     | folke/tokyonight.nvim               | Tokyo Night カラースキーム                           |
| Colorscheme     | marko-cerovac/material.nvim         | Material Design カラースキーム                       |
| Colorscheme     | navarasu/onedark.nvim               | One Dark カラースキーム                              |
| Colorscheme     | rebelot/kanagawa.nvim               | Kanagawa カラースキーム                              |
| Colorscheme     | sainnhe/sonokai                     | Sonokai カラースキーム                               |
| Colorscheme     | scottmckendry/cyberdream.nvim       | Cyberdream カラースキーム                            |
| Comment         | folke/todo-comments.nvim            | TODO コメントをハイライトします                      |
| Completion      | hrsh7th/nvim-cmp                    | 自動補完エンジン                                     |
| Completion      | hrsh7th/cmp-buffer                  | バッファ補完ソース                                   |
| Completion      | hrsh7th/cmp-cmdline                 | コマンドライン補完ソース                             |
| Completion      | hrsh7th/cmp-nvim-lsp                | LSP 補完ソース                                       |
| Completion      | hrsh7th/cmp-path                    | パス補完ソース                                       |
| Completion      | L3MON4D3/LuaSnip                    | スニペットエンジン                                   |
| Completion      | onsails/lspkind-nvim                | 補完メニュー用の LSP kind アイコン                   |
| Completion      | petertriho/cmp-git                  | Git 補完ソース                                       |
| Completion      | saadparwaiz1/cmp_luasnip            | LuaSnip 補完ソース                                   |
| Copilot         | zbirenbaum/copilot.lua              | GitHub Copilot 統合                                  |
| Copilot         | zbirenbaum/copilot-cmp              | nvim-cmp 向け Copilot 補完ソース                     |
| Debugging       | jay-babu/mason-nvim-dap.nvim        | DAP 用 Mason 統合                                    |
| Debugging       | mfussenegger/nvim-dap               | Debug Adapter Protocol クライアント                  |
| Debugging       | rcarriga/nvim-dap-ui                | nvim-dap 用 UI                                       |
| Debugging       | theHamsta/nvim-dap-virtual-text     | デバッガー値の仮想テキスト                           |
| Diagnostics     | folke/trouble.nvim                  | 診断リストと quickfix ビューアー                     |
| Editing Support | kylechui/nvim-surround              | テキストオブジェクトの囲み操作                       |
| Editing Support | numToStr/Comment.nvim               | コードのコメント/コメント解除                        |
| Editing Support | phaazon/hop.nvim                    | Easymotion ライクなナビゲーション                    |
| Editing Support | windwp/nvim-autopairs               | 括弧と引用符の自動ペアリング                         |
| File Explorer   | mikavilpas/yazi.nvim                | Yazi ファイルマネージャー統合                        |
| Fuzzy Finder    | nvim-telescope/telescope.nvim       | ファジーファインダー                                 |
| Git             | lewis6991/gitsigns.nvim             | サインカラムの Git サイン                            |
| Indent          | lukas-reineke/indent-blankline.nvim | インデントガイドライン                               |
| Keybinding      | folke/which-key.nvim                | キーバインディングポップアップガイド                 |
| LSP             | jay-babu/mason-null-ls.nvim         | null-ls 用 Mason 統合                                |
| LSP             | mason-org/mason-lspconfig.nvim      | LSP サーバー用 Mason 統合                            |
| LSP             | mason-org/mason.nvim                | LSP/DAP/リンター/フォーマッター用パッケージマネージャー |
| LSP             | neovim/nvim-lspconfig               | LSP 設定                                             |
| LSP             | nvimtools/none-ls.nvim              | 診断とフォーマット用の Null-ls                       |
| LSP             | nvimtools/none-ls-extras.nvim       | 追加の null-ls ソース                                |
| Preview         | hedyhli/markdown-toc.nvim           | Markdown 目次生成器                                  |
| Statusline      | nvim-lualine/lualine.nvim           | ステータスラインとタブライン                         |
| Statusline      | nvim-tree/nvim-web-devicons         | ファイルタイプアイコン                               |
| Syntax          | nvim-treesitter/nvim-treesitter     | Treesitter シンタックスハイライト                    |
| Terminal        | akinsho/toggleterm.nvim             | ターミナルウィンドウの切り替え                       |
| UI              | folke/noice.nvim                    | 拡張コマンドラインと UI                              |
| UI              | folke/snacks.nvim                   | UI ユーティリティコレクション                        |
| UI              | rcarriga/nvim-notify                | 通知マネージャー                                     |
| Utility         | MunifTanjim/nui.nvim                | UI コンポーネントライブラリ                          |
| Utility         | nvim-lua/plenary.nvim               | Lua ユーティリティライブラリ                         |
| Utility         | nvim-mini/mini.nvim                 | ミニマルプラグインコレクション                       |
| Utility         | nvim-neotest/nvim-nio               | 非同期 IO ライブラリ                                 |
