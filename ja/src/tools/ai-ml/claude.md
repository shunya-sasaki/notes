# Claude Code

## MCP

`claude mcp add` で MCP サーバーを追加し、
`claude mcp run` で使用できます。
例えば、テキストの説明からダイアグラムを生成する Mermaid を実行するサーバーを追加できます。

### mcp-mermaid

#### Setup

```sh
claude mcp add --transport stdio mcp-mermaid -- npx -y mcp-mermaid
```
