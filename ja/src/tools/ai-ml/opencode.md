# OpenCode

OpenCode はターミナル向けに構築されたオープンソースの AI コーディングエージェントです。
Claude、GPT、Gemini、ローカルモデルを含む 75 以上の LLM プロバイダーをサポートしています。

<!-- toc -->

- [📝 What is OpenCode?](#-what-is-opencode)
- [⚙️ Install](#-install)
- [🔧 Configuration](#-configuration)

<!-- /toc -->

👉 [Official OpenCode page](https://opencode.ai/)
👉 [GitHub Repository](https://github.com/opencode-ai/opencode)

## 📝 What is OpenCode?

OpenCode は Go で書かれたターミナルベースの開発者向け AI アシスタントです。
Bubble Tea フレームワークで構築されたインタラクティブな TUI（Terminal User Interface）を提供し、
複数の AI モデルとのやり取りを通じてコーディング、デバッグ、開発ワークフローをサポートします。

主な特徴:

- **Multi-Provider Support** - AI サービス間のシームレスな切り替え（Anthropic、OpenAI、Google、Groq、AWS Bedrock など）
- **Interactive TUI** - Vim ライクなエディターとネイティブテキスト編集機能
- **Session Management** - SQLite 永続化によるセッション会話コンテキストの保存と復元
- **Tool Integration** - コマンド実行、ファイル検索、コード変更
- **LSP Integration** - コードインテリジェンスのための Language Server Protocol
- **Plan / Build modes** - `TAB` で提案のみモードと実装モードを切り替え
- **Non-Interactive Mode** - `-p` フラグによる単発プロンプト実行と JSON 出力サポート

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

設定ファイルは `opencode.json` です。
OpenCode は以下の場所でファイルを検索します:

1. `./.opencode.json`（プロジェクトローカル）
2. `$XDG_CONFIG_HOME/opencode/.opencode.json`
3. `$HOME/.opencode.json`

設定例:

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

API キーは環境変数でも設定できます:

```sh
export ANTHROPIC_API_KEY="sk-..."
export OPENAI_API_KEY="sk-..."
export GEMINI_API_KEY="..."
export GROQ_API_KEY="..."
```

TUI 内で `/connect` を実行してインタラクティブな認証フローを起動するか、
`/init` を実行してプロジェクトを分析し `AGENTS.md` ファイルを作成します。
