# OpenCode

OpenCode is an open-source AI coding agent built for the terminal.
It supports 75+ LLM providers including Claude, GPT, Gemini, and local models.

<!-- toc -->

- [📝 What is OpenCode?](#-what-is-opencode)
- [⚙️ Install](#-install)
- [🔧 Configuration](#-configuration)

<!-- /toc -->

👉 [Official OpenCode page](https://opencode.ai/)
👉 [GitHub Repository](https://github.com/opencode-ai/opencode)

## 📝 What is OpenCode?

OpenCode is a terminal-based AI assistant for developers written in Go.
It provides an interactive TUI (Terminal User Interface) built with the Bubble Tea framework
for engaging with multiple AI models to support coding, debugging, and development workflows.

Key features:

- **Multi-Provider Support** - Seamless switching between AI services (Anthropic, OpenAI, Google, Groq, AWS Bedrock, etc.)
- **Interactive TUI** - Vim-like editor with native text editing capabilities
- **Session Management** - Save and restore conversation contexts with SQLite persistence
- **Tool Integration** - Execute commands, search files, and modify code
- **LSP Integration** - Language Server Protocol for code intelligence
- **Plan / Build modes** - Toggle with `TAB` between suggestion-only and implementation modes
- **Non-Interactive Mode** - Run single prompts via `-p` flag with JSON output support

## ⚙️ Install

**Option 1. Install script**:

```sh
curl -fsSL https://opencode.ai/install | bash
```

---

**Option 2. Homebrew**:

```sh
brew install anomalyco/tap/opencode
```

---

**Option 3. npm**:

```sh
npm install -g opencode-ai
```

---

**Option 4. Go**:

```sh
go install github.com/opencode-ai/opencode@latest
```

---

## 🔧 Configuration

The configuration file is `opencode.json`.
OpenCode searches for the file in the following locations:

1. `./.opencode.json` (project local)
2. `$XDG_CONFIG_HOME/opencode/.opencode.json`
3. `$HOME/.opencode.json`

Example configuration:

```json
{
  "providers": {
    "anthropic": { "apiKey": "sk-...", "disabled": false },
    "openai": { "apiKey": "sk-...", "disabled": false }
  },
  "agents": {
    "coder": { "model": "claude-3.7-sonnet", "maxTokens": 5000 }
  },
  "shell": { "path": "/bin/bash", "args": ["-l"] },
  "autoCompact": true
}
```

API keys can also be set via environment variables:

```sh
export ANTHROPIC_API_KEY="sk-..."
export OPENAI_API_KEY="sk-..."
export GEMINI_API_KEY="..."
export GROQ_API_KEY="..."
```

Run `/connect` inside the TUI to launch the interactive authentication flow,
or `/init` to analyze the project and create an `AGENTS.md` file.
