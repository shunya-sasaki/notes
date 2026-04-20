# Tmux

<!-- toc -->

- [What is Tmux?](#what-is-tmux)
- [Setup](#setup)
  - [Install](#install)
  - [Create configuration file](#create-configuration-file)
  - [Install plugins](#install-plugins)
  - [Plugin settings](#plugin-settings)
- [🚀 Usage](#-usage)

<!-- /toc -->

## What is Tmux?

Tmux はターミナルマルチプレクサで、単一の画面から複数のターミナルを作成・制御できます。以下のことが可能です:

- 単一のターミナルウィンドウ内で複数のコマンドラインプログラムを同時に実行できます。
- セッションからデタッチし、別の場所やシステム再起動後に再アタッチできます。
- 単一のターミナルを複数のペインに分割し、それぞれ独立したシェルを実行できます。
- 他のユーザーとセッションを共有して共同作業ができます。

## Setup

### Install

```sh
brew install tmux
```

### Create configuration file

`~/.tmux.conf` を作成して設定を記述します。
以下は例です。

```sh
# change prefix key
set -g prefix C-a

# enable mouse operator
set-option -g mouse on

# move pane shortcuts
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# resize pane shortcuts
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# reload config
bind r source-file ~/.tmux.conf \; display "Reloaded the config file!"

# color
set -g default-terminal "xterm-256color"

# split pane shortcutsw
bind | split-window -h -c '#{pane_current_path}'
bind - split-window -v -c '#{pane_current_path}'

# copy mode key binds
if-shell -b '[ "$(uname)" = "Darwin" ]' {
  set -s copy-command "pbcopy"
}
if-shell -b '[ "$(uname)" = "Linux" ]' {
  set -s copy-command "xsel --clipboard --input"
}
setw -g mode-keys vi
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind -T copy-mode-vi V send-keys -X select-line
bind -T copy-mode-vi Esc send-keys -X clear-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel
bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel

# Plugins =====================================================================
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# tmux-power ------------------------------------------------------------------
set -g @plugin 'wfxr/tmux-power'
set -g @tmux_power_theme '#5f87ff'

run '~/.tmux/plugins/tpm/tpm'

# pane color ==================================================================
set -g pane-active-border-style fg=colour69,bg=colour235
set -g pane-border-style fg=colour69,bg=colour235

# disable automatic window resize
setw -g aggressive-resize off
```

### Install plugins

以下のコマンドを実行してプラグインマネージャーをクローンします。

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Plugin settings

`~/.tmux.conf` にプラグイン設定を追加します。

```sh
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'github_username/plugin_name#branch'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

```

## 🚀 Usage

| Command | Description                        |
| ------- | ---------------------------------- |
| `tmux`  | tmux セッションを作成して開きます  |
