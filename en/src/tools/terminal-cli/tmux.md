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

Tmux is a terminal multiplexer, which allows you to create and control multiple terminals from a single screen. It enables users to:

- Run multiple command-line programs simultaneously within a single terminal window.
- Detach from a session and reattach to it later from a different location or after a system restart.
- Split a single terminal into multiple panes, each running an independent shell.
- Share sessions with other users for collaborative work.

## Setup

### Install

```sh
brew install tmux
```

### Create configuration file

Create `~/.tmux.conf` and write settings.
The following is an example.

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

Run the following command to clone the plugin manager.

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Plugin settings

Add plugin settings to `~/.tmux.conf`.

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

| Command | Description                  |
| ------- | ---------------------------- |
| `tmux`  | Create and open tmux session |
