# <iconify-icon icon="selfhst:zensical" style="vertical-align: middle;"></iconify-icon> Zensical

![Python](https://img.shields.io/badge/Python-3776AB?logo=python&labelColor=gray&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-000000?logo=rust&labelColor=gray&logoColor=white)
![Markdown](https://img.shields.io/badge/Markdown-000000?logo=markdown&labelColor=gray&logoColor=white)
![TOML](https://img.shields.io/badge/TOML-9C4121?logo=toml&labelColor=gray&logoColor=white)
![uv](https://img.shields.io/badge/uv-DE5FE9?logo=uv&labelColor=gray&logoColor=white)

この記事では、技術ドキュメント向けの静的サイトジェネレータである
Zensical について学びます。

<!-- toc -->

- [📝 What is Zensical?](#-what-is-zensical)
- [📦 Setup](#-setup)
  - [Install](#install)
- [🚀 Usage](#-usage)
  - [Initialize Zensical](#initialize-zensical)
  - [Preview the site](#preview-the-site)
  - [Build the site](#build-the-site)
- [⚙️ Configuration](#-configuration)
  - [Site metadata](#site-metadata)
  - [Navigation](#navigation)
  - [Theme features](#theme-features)
  - [Color palette](#color-palette)
  - [Markdown extensions](#markdown-extensions)

<!-- /toc -->

👉 [Official Zensical page](https://zensical.org/)
👉 [GitHub Repository](https://github.com/zensical/zensical)

## 📝 What is Zensical?

Zensical は、Material for MkDocs を開発したチームによって作られた、
ドキュメント向けの静的サイトジェネレータです。
Markdown ファイルを受け取り、テーマとテンプレートを適用して、
完全な静的サイトを出力します。

Zensical は Python と Rust のハイブリッドアプリケーションです。
Python が CLI、設定、Markdown のレンダリングを担当し、
Rust がビルドパイプライン、ファイルウォッチャー、プレビューサーバー、
テンプレートエンジンを担当します。

主な特徴:

- **MkDocs compatible** - ネイティブの `zensical.toml` を読み込みますが、
  既存の `mkdocs.yml` も読み込めるため、Material for MkDocs の
  プロジェクトを設定を書き直さずに移行できます。
- **Fast incremental builds** - Rust のビルドパイプラインが可能な限り
  キャッシュするため、変更されたファイルのみが再ビルドされます。
- **Live preview** - 組み込みのサーバーがソースを監視し、
  ブラウザを自動的にリロードします。
- **Material theme** - `modern` と `classic` のテーマバリアントが、
  Material for MkDocs の外観と機能を提供します。
- **Python Markdown extensions** - Python Markdown と
  PyMdown Extensions の拡張機能が従来どおりサポートされます。

> [!NOTE]
> Zensical は `mkdocs` コマンドを置き換えるため、
> `mkdocs serve` や `mkdocs build` の代わりに
> `zensical serve` と `zensical build` を使用します。
> `gh-deploy` と `get-deps` コマンドはサポートされていません。

## 📦 Setup

### Install

```sh
uv add zensical markdown-gfm-admonition
```

開発用にのみパッケージをインストールする場合は、次のコマンドを使用します。

```sh
uv add -d zensical markdown-gfm-admonition
```

## 🚀 Usage

### Initialize Zensical

```sh
uv run zensical new
```

このコマンドはカレントディレクトリにプロジェクトを作成します。
引数としてパスを渡すと、そのディレクトリにプロジェクトが作成され、
パスが存在しない場合は作成されます。

生成されるファイルは次のとおりです。

```diff
+ your-project/
+ ├── .github/
+ │   └── workflows/
+ │       └── docs.yml
+ ├── docs/
+ │   ├── index.md
+ │   └── markdown.md
+ └── zensical.toml
```

| Path                 | Description                                          |
| -------------------- | ---------------------------------------------------- |
| `zensical.toml`      | プロジェクトの設定ファイルです。                     |
| `docs/`              | サイトの Markdown ソースです。                       |
| `.github/workflows/` | GitHub Pages に公開するための GitHub Actions ワークフローです。 |

> [!NOTE]
> `new` コマンドは既存のファイルを決して上書きしません。
> `zensical.toml` がすでに存在する場合は失敗するため、
> 既存のプロジェクトで実行しても安全です。

> [!TIP]
> GFM の alert のレンダリングを有効にする場合は、次の記述を
> `zensical.toml` に追加します。
>
> _zensical.toml_
>
> ```toml
> [project.markdown_extensions.gfm_admonition]
> ```

### Preview the site

```sh
uv run zensical serve
```

プレビューサーバーはソースを監視し、ブラウザを自動的にリロードします。

| Option          | Short | Description                                            |
| --------------- | ----- | ------------------------------------------------------ |
| `--config-file` | `-f`  | 別の設定ファイルを使用します。                         |
| `--dev-addr`    | `-a`  | 別のアドレスにバインドします (例: `localhost:8080`)。  |
| `--open`        | `-o`  | デフォルトのブラウザでプレビューを開きます。           |

> [!NOTE]
> コマンドを実行した後、ウェブブラウザで `http://localhost:8000` に
> アクセスすることでサイトを確認できます。
> 組み込みのサーバーはプレビュー専用のため、
> サイトを公開するには Nginx などのウェブサーバーを使用してください。

### Build the site

```sh
uv run zensical build
```

このコマンドはカレントディレクトリから設定ファイルを探し、
すべてのコンテンツをコンパイルして、静的サイトを `site` ディレクトリに
出力します。

| Option          | Short | Description                              |
| --------------- | ----- | ---------------------------------------- |
| `--config-file` | `-f`  | 別の設定ファイルを使用します。           |
| `--clean`       | `-c`  | ビルド前にビルドキャッシュをクリアします。 |
| `--strict`      | `-s`  | strict モードを有効にします。            |

> [!TIP]
> Zensical は設定ファイルを `zensical.toml`、`mkdocs.yml`、
> `mkdocs.yaml` の順で探します。

## ⚙️ Configuration

Zensical のプロジェクトは `zensical.toml` ファイルで設定します。
すべての設定は `[project]` テーブルの下に配置します。

### Site metadata

_zensical.toml_

```toml
[project]
site_name = "Documentation"
site_url = "https://www.example.com/"
site_description = "Your project description"
site_author = "Your name"
copyright = "Copyright &copy; 2026 Your name"
docs_dir = "docs"
site_dir = "site"

repo_url = "https://github.com/user/repo"
repo_name = "user/repo"
edit_uri = "edit/main/docs/"
```

| Setting              | Description                                              |
| -------------------- | -------------------------------------------------------- |
| `site_name`          | サイトの名前です。この設定は必須です。                   |
| `site_url`           | サイトの正規 URL です。                                  |
| `site_description`   | HTML の head で使用される説明です。                      |
| `docs_dir`           | Markdown ソースのディレクトリです。デフォルトは `docs` です。 |
| `site_dir`           | 生成されるサイトのディレクトリです。デフォルトは `site` です。 |
| `use_directory_urls` | URL をディレクトリ形式でレンダリングするかどうかです。   |
| `dev_addr`           | プレビューサーバーのアドレスです。                       |

### Navigation

`nav` 設定はサイトの構造を定義します。
ファイルを直接列挙することも、テーブルでタイトルを設定することもできます。

_zensical.toml_

```toml
[project]
nav = [
  { "Home" = "index.md" },
  { "About" = [
    "about/index.md",
    "about/vision.md",
  ] },
  { "GitHub" = "https://github.com/user/repo" },
]
```

### Theme features

_zensical.toml_

```toml
[project.theme]
variant = "modern"
language = "en"
features = [
  "content.code.annotate",
  "content.code.copy",
  "navigation.footer",
  "navigation.indexes",
  "navigation.instant",
  "navigation.sections",
  "navigation.top",
  "search.highlight",
]
```

| Feature               | Description                                                  |
| --------------------- | ------------------------------------------------------------ |
| `navigation.instant`  | シングルページアプリのように XHR でページを読み込みます。    |
| `navigation.tabs`     | トップレベルのセクションをタブとして表示します。             |
| `navigation.sections` | サイドバーでセクションをグループとして表示します。           |
| `navigation.indexes`  | ページをセクションに直接紐付けます。                         |
| `navigation.path`     | 現在のページのパンくずリストを表示します。                   |
| `navigation.top`      | トップに戻るボタンを表示します。                             |
| `toc.follow`          | 目次を現在のアンカーまでスクロールします。                   |
| `toc.integrate`       | 目次をサイドバーに統合します。                               |

> [!TIP]
> `variant` 設定はテーマの外観を選択します。
> デフォルトは `modern` で、`classic` は
> Material for MkDocs の外観を再現します。

### Color palette

カラースキームを切り替えるには、パレットをテーブルの配列として定義します。

_zensical.toml_

```toml
[[project.theme.palette]]
media = "(prefers-color-scheme: light)"
scheme = "default"
toggle.icon = "lucide/sun"
toggle.name = "Switch to dark mode"

[[project.theme.palette]]
media = "(prefers-color-scheme: dark)"
scheme = "slate"
toggle.icon = "lucide/moon"
toggle.name = "Switch to light mode"
```

トグルが不要な場合は、パレットを単一のテーブルとして定義します。

_zensical.toml_

```toml
[project.theme.palette]
scheme = "default"
primary = "indigo"
accent = "indigo"
```

### Markdown extensions

Markdown の拡張機能は `[project.markdown_extensions]` の下で宣言します。
オプションのない拡張機能は空のテーブルとして記述し、
オプションはドット付きキーで記述します。

_zensical.toml_

```toml
[project.markdown_extensions]
abbr = {}
admonition = {}
attr_list = {}
def_list = {}
footnotes = {}
md_in_html = {}
toc.permalink = true
pymdownx.arithmatex.generic = true
pymdownx.details = {}
pymdownx.highlight.anchor_linenums = true
pymdownx.highlight.line_spans = "__span"
pymdownx.highlight.pygments_lang_class = true
pymdownx.inlinehilite = {}
pymdownx.tabbed.alternate_style = true
pymdownx.tasklist.custom_checkbox = true
pymdownx.superfences.custom_fences = [
  { name = "mermaid", class = "mermaid", format = "pymdownx.superfences.fence_code_format" },
]
```

> [!NOTE]
> Zensical はデフォルトの拡張機能セットを有効にしているため、
> 挙動を変更したい拡張機能だけを宣言すれば十分です。
