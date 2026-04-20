# Lazygit

<!-- toc -->

- [What is lazygit](#what-is-lazygit)
- [Configure lazygit](#configure-lazygit)
  - [Config file](#config-file)
  - [Enable git-delta](#enable-git-delta)

<!-- /toc -->

## What is lazygit

lazygit is a simple, terminal-based Git user interface that helps users manage Git repositories more efficiently.
It provides an interactive UI for common Git operations like staging, committing, branching,
viewing logs, resolving merge conflicts, and more, all from within the command line.
This tool is popular for its speed, ease of use, and ability to streamline Git workflows without needing to remember complex commands.

> [!NOTE]
> 👉 [GitHub Lazygit](https://github.com/jesseduffield/lazygit)

## Configure lazygit

### Config file

Default path for the global config file:

- Linux: `~/.config/lazygit/config.yml`
- MacOS: `~/Library/Application\ Support/lazygit/config.yml`
- Windows: `%LOCALAPPDATA%\lazygit\config.yml` (default location, but it will also be found in `%APPDATA%\lazygit\config.yml`

### Enable git-delta

```yaml
git:
  paging:
    pager: "delta --dark --paging=never"
```
