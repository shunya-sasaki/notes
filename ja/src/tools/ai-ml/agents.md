# Agents.md

<!-- toc -->

- [What is Agents.md ?](#what-is-agentsmd-)
- [Example of sections](#example-of-sections)
- [Example](#example)

<!-- /toc -->

## What is Agents.md ?

## Example of sections

- プロジェクト概要
- ビルドおよびテストコマンド
- コードスタイルガイドライン
- テスト手順
- セキュリティに関する考慮事項

## Example

```markdown
# AGENTS.md

このドキュメントでは、このリポジトリで使用される AI エージェントアーキテクチャを定義します。
各エージェントは、コード生成、レビュー、ドキュメント作成、脆弱性分析など、
単一の明確に定義された責任をカプセル化し、
LLM とローカルツールに基づく再現可能なワークフローを通じて動作します。

## Project overview

このプロジェクトは CLI 操作のためのツールセットです。

## Build and test commands

- 'uv build' を実行して Python パッケージをビルドします。
- プロジェクトルートで 'uv run pytest' を実行してテストを行います。

### Dev environment

- 'uv add' を使用してこのプロジェクトの依存関係に Python パッケージを追加します。
- このリポジトリのクローン後または pyproject.toml の変更後に
  'uv sync' を実行して Python 環境を同期します。

## Code style guidelines

### Python style guides

#### Naming

| Type                       | Public             | Internal                         |
| -------------------------- | ------------------ | -------------------------------- |
| Packages                   | lower_with_under   |                                  |
| Modules                    | lower_with_under   | \_lower_with_under               |
| Classes                    | CapWords           | \_CapWords                       |
| Exceptions                 | CapWords           |                                  |
| Functions                  | lower_with_under() | \_lower_with_under()             |
| Global/Class Constants     | CAPS_WITH_UNDER    | \_CAPS_WITH_UNDER                |
| Global/Class Variables     | lower_with_under   | \_lower_with_under               |
| Instance Variables         | lower_with_under   | \_lower_with_under (protected)   |
| Method Names               | lower_with_under() | \_lower_with_under() (protected) |
| Function/Method Parameters | lower_with_under   |                                  |
| Local Variables            | lower_with_under   |                                  |

#### Docstrings

- docstring には Google スタイルを使用してください。

#### Packages

- 絶対インポートを使用してください。

### Git commit messages

- `git diff --cached` の結果に基づいて git コミットメッセージを作成してください。
- conventional commit フォーマットを使用し、コミットメッセージは以下のように構成します:

  '''
  <type>[optional scope]: <description>

  [optional body]

  [optional footer(s)]
  '''

- 1 行目はコミットタイトルで、簡潔にしてください。
- 1 行目の長さは最大 50 文字にしてください。
- 3 行目はオプションで、変更に関する追加のコンテキストや詳細を提供できます。
- 1 行目の type は以下のいずれかにしてください:
  - build: ビルドシステムまたは外部依存関係に影響する変更
  - ci: CI 設定ファイルやスクリプトの変更
  - docs: ドキュメントのみの変更
  - feat: 新機能
  - fix: バグ修正
  - perf: パフォーマンスを改善するコード変更
  - refactor: バグ修正でも新機能でもないコード変更
  - style: コードの意味に影響しない変更
  - test: 不足しているテストの追加または既存テストの修正

## Testing instructions

このプロジェクトにはテストは不要です。

## Security considerations

- スクリプトにパスワードやシークレットを書いてはいけません。
```
