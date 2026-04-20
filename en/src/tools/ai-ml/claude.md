# Claude Code

## MCP

You can add MCP servers with `claude mcp add`
and then use them with `claude mcp run`.
For example, you can add a server that runs Mermaid to generate diagrams
from text descriptions.

### mcp-mermaid

#### Setup

```sh
claude mcp add --transport stdio mcp-mermaid -- npx -y mcp-mermaid
```
