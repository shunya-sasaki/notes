# Lazygit

<!-- toc -->

- [What is lazygit](#what-is-lazygit)
- [Configure lazygit](#configure-lazygit)
  - [Config file](#config-file)
  - [Enable git-delta](#enable-git-delta)

<!-- /toc -->

## What is lazygit

lazygit はシンプルなターミナルベースの Git ユーザーインターフェースで、Git リポジトリをより効率的に管理できます。
ステージング、コミット、ブランチ操作、ログの閲覧、マージコンフリクトの解決など、
一般的な Git 操作のためのインタラクティブな UI を提供します。
このツールは、その速度、使いやすさ、複雑なコマンドを覚えることなく
Git ワークフローを効率化できることで人気があります。

> [!NOTE]
> 👉 [GitHub Lazygit](https://github.com/jesseduffield/lazygit)

## Configure lazygit

### Config file

グローバル設定ファイルのデフォルトパス:

- Linux: `~/.config/lazygit/config.yml`
- MacOS: `~/Library/Application\ Support/lazygit/config.yml`
- Windows: `%LOCALAPPDATA%\lazygit\config.yml`（デフォルトの場所ですが、`%APPDATA%\lazygit\config.yml` でも検出されます）

### Enable git-delta

```yaml
git:
  paging:
    pager: "delta --dark --paging=never"
```
