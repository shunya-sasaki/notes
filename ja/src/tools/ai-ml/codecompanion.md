# CodeCompanion

このドキュメントでは、CodeCompanion の機能と特徴について説明します。

## What is CodeCompanion?

CodeCompanion は、コードの提案、説明、デバッグ支援を提供することで
開発者を支援するツールです。
さまざまなプログラミング環境と統合して生産性を向上させ、
コーディングプロセスを効率化します。

## Workspace

> [!NOTE]
> [CodeCompanion: Creating Workspaces](https://codecompanion.olimorris.dev/extending/workspace.html)

### Workspace setting file

`codecompanion-workspace.json` というワークスペース設定ファイルを作成して
CodeCompanion を設定できます。
このファイルはプロジェクトのルートディレクトリに配置してください。

```diff
  PROJECT
  |- codecompanion-workspace.json
  `- README.md
```

以下はワークスペース設定ファイルの例です:

```json
{
  "name": "Project Document Name",
  "version": "1.0.0",
  "description": "Write a description of your project here (This is not used by LLM).",
  "groups": [
    {
      "name": "Group Name",
      "system_prompt": "You are an assistant dedicated to ${group_name}. \
      Group system prompt. \
      This is used to set the context for the group.",
      ",
      "data": []
    }
  ],
  "data": {
    "readme": {
      "type": "file",
      "path": "README.md",
      "description": "This `${filename}` file is used to provide an overview of the project."
    },
    "google-python-style-guide": {
      "type": "url",
      "path": "https://google.github.io/styleguide/pyguide.html",
      "description": "This is the Google Python Style Guide.",
      "opts": {
        "auto_restore_cache": true
      }
    }
  }
}
```
