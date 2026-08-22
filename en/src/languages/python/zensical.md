# <iconify-icon icon="selfhst:zensical" style="vertical-align: middle;"></iconify-icon> Zensical

![Python](https://img.shields.io/badge/Python-3776AB?logo=python&labelColor=gray&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-000000?logo=rust&labelColor=gray&logoColor=white)
![Markdown](https://img.shields.io/badge/Markdown-000000?logo=markdown&labelColor=gray&logoColor=white)
![TOML](https://img.shields.io/badge/TOML-9C4121?logo=toml&labelColor=gray&logoColor=white)
![uv](https://img.shields.io/badge/uv-DE5FE9?logo=uv&labelColor=gray&logoColor=white)

In this article, we will learn about Zensical, a static site generator
for technical documentation.

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

Zensical is a static site generator for documentation,
built by the team behind Material for MkDocs.
It takes Markdown files, applies a theme and templates,
and outputs a complete static site.

Zensical is a hybrid Python and Rust application.
Python handles the CLI, the configuration and the Markdown rendering,
while Rust handles the build pipeline, the file watcher, the preview server
and the template engine.

Key features:

- **MkDocs compatible** - Reads a native `zensical.toml`,
  but also an existing `mkdocs.yml`, so a Material for MkDocs project
  can be migrated without rewriting its setup.
- **Fast incremental builds** - The Rust build pipeline caches
  as much as possible, so only the changed files are rebuilt.
- **Live preview** - The built-in server watches the sources
  and reloads the browser automatically.
- **Material theme** - The `modern` and `classic` theme variants
  provide the look and the features of Material for MkDocs.
- **Python Markdown extensions** - The extensions of Python Markdown
  and PyMdown Extensions are supported as before.

> [!NOTE]
> Zensical replaces the `mkdocs` command,
> so use `zensical serve` and `zensical build`
> instead of `mkdocs serve` and `mkdocs build`.
> The `gh-deploy` and `get-deps` commands are not supported.

## 📦 Setup

### Install

```sh
uv add zensical markdown-gfm-admonition
```

If you install the packages for develop only, use the following command:

```sh
uv add -d zensical markdown-gfm-admonition
```

## 🚀 Usage

### Initialize Zensical

```sh
uv run zensical new
```

The command creates the project in the current directory.
If you pass a path as an argument, the project is created in that directory,
and the path is created when it does not exist.

The generated files are the following:

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

| Path                 | Description                                         |
| -------------------- | --------------------------------------------------- |
| `zensical.toml`      | Configuration file of the project.                  |
| `docs/`              | Markdown sources of the site.                       |
| `.github/workflows/` | GitHub Actions workflow to publish to GitHub Pages. |

> [!NOTE]
> The `new` command never overwrites existing files.
> It fails when a `zensical.toml` already exists,
> so it is safe to run in an existing project.

> [!TIP]
> If you enable rendering GFM alert, add the following sentenses to the `zensical.toml`.
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

The preview server watches the sources and reloads the browser automatically.

| Option          | Short | Description                                     |
| --------------- | ----- | ----------------------------------------------- |
| `--config-file` | `-f`  | Use another configuration file.                 |
| `--dev-addr`    | `-a`  | Bind to another address, e.g. `localhost:8080`. |
| `--open`        | `-o`  | Open the preview in the default browser.        |

> [!NOTE]
> After running the command, you can access the site at
> `http://localhost:8000` in your web browser.
> The built-in server is intended for preview only,
> so use a web server such as Nginx to publish the site.

### Build the site

```sh
uv run zensical build
```

The command searches the current directory for a configuration file,
compiles all content and outputs the static site to the `site` directory.

| Option          | Short | Description                         |
| --------------- | ----- | ----------------------------------- |
| `--config-file` | `-f`  | Use another configuration file.     |
| `--clean`       | `-c`  | Clear the build cache before build. |
| `--strict`      | `-s`  | Enable strict mode.                 |

> [!TIP]
> Zensical looks for the configuration file in the order of
> `zensical.toml`, `mkdocs.yml` and `mkdocs.yaml`.

## ⚙️ Configuration

A Zensical project is configured with a `zensical.toml` file.
All settings are placed under the `[project]` table.

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

| Setting              | Description                                           |
| -------------------- | ----------------------------------------------------- |
| `site_name`          | Name of the site. This setting is required.           |
| `site_url`           | Canonical URL of the site.                            |
| `site_description`   | Description used in the HTML head.                    |
| `docs_dir`           | Directory of the Markdown sources. Default is `docs`. |
| `site_dir`           | Directory of the generated site. Default is `site`.   |
| `use_directory_urls` | Whether URLs are rendered as directories.             |
| `dev_addr`           | Address of the preview server.                        |

### Navigation

The `nav` setting defines the structure of the site.
You can list the files directly, or set the titles with tables.

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

| Feature               | Description                                        |
| --------------------- | -------------------------------------------------- |
| `navigation.instant`  | Load the pages with XHR like a single page app.    |
| `navigation.tabs`     | Render the top level sections as tabs.             |
| `navigation.sections` | Render the sections as groups in the sidebar.      |
| `navigation.indexes`  | Attach a page directly to a section.               |
| `navigation.path`     | Show the breadcrumbs of the current page.          |
| `navigation.top`      | Show the back-to-top button.                       |
| `toc.follow`          | Scroll the table of contents to the active anchor. |
| `toc.integrate`       | Merge the table of contents into the sidebar.      |

> [!TIP]
> The `variant` setting selects the look of the theme.
> The default is `modern`, and `classic` reproduces
> the appearance of Material for MkDocs.

### Color palette

To toggle the color scheme, define the palette as an array of tables.

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

If you do not need the toggle, define the palette as a single table.

_zensical.toml_

```toml
[project.theme.palette]
scheme = "default"
primary = "indigo"
accent = "indigo"
```

### Markdown extensions

Markdown extensions are declared under `[project.markdown_extensions]`.
An extension without options is written as an empty table,
and the options are written with a dotted key.

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
> Zensical enables a default set of extensions,
> so you only need to declare the extensions
> whose behavior you want to change.
