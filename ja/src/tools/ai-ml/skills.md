# Skills

<!-- toc -->

- [What are Skills?](#what-are-skills)
- [Skill layout](#skill-layout)
- [SKILL.md format](#skillmd-format)
- [Where to place skills](#where-to-place-skills)
  - [Directory conventions per CLI](#directory-conventions-per-cli)
- [Invoking a skill](#invoking-a-skill)

<!-- /toc -->

## What are Skills?

Skills は Claude Code のための再利用可能な機能であり、指示・スクリプト・
参照ファイルを 1 つのディレクトリにまとめたものです。
ユーザーのリクエストが Skill の description に一致すると、
Claude はその Skill を読み込み、指示に従います。

## Skill layout

Skill は `SKILL.md` ファイルと、それを補助する各種アセット
(スクリプト、テンプレート、参照ファイル) を含むディレクトリです。

```text
my-skill/
├── SKILL.md
├── scripts/
│   └── helper.sh
└── references/
    └── notes.md
```

## SKILL.md format

`SKILL.md` は、Skill の名前とマッチングに使われる短い description を
宣言する YAML フロントマターから始まり、その後に実際の指示を記述した
本文が続きます。

```markdown
---
name: my-skill
description: Short summary of what this skill does and when to use it.
---

# My Skill

Detailed instructions for Claude go here.
```

## Where to place skills

Skill は **プロジェクト** ディレクトリまたは **ホーム (グローバル)**
ディレクトリのいずれかに置けます。
プロジェクトスコープの Skill はリポジトリ内に配置され、通常はコミットして
共同作業者が同じ Skill セットを共有できるようにします。
ホームスコープの Skill はユーザーのホームディレクトリ配下に置かれ、
そのマシン上のすべてのプロジェクトから利用できます。

各 CLI エージェントは、それぞれのベンダー固有のディレクトリ配下から
Skill を探します。
いくつかのエージェントは加えて共通の `.agents/skills/` 規約にも対応しており、
1 つの Skill セットを重複なく複数のツールで再利用できます。

### Directory conventions per CLI

| Directory Scope | Path | ClaudeCode | Codex | Gemini CLI | GitHub Copilot CLI | OpenCode |
|---|---|:---:|:---:|:---:|:---:|:---:|
| **Project** | `.claude/skills/` | ✅ | ✅ | ❌ | ✅ | ✅ |
| **Project** | `.codex/skills/` | ❌ | ✅ | ❌ | ❌ | ❌ |
| **Project** | `.gemini/skills/` | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Project** | `.github/skills/` | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Project** | `.opencode/skills/` | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Project** | `.agents/skills/` | ❌ | ✅ | ✅ | ✅ | ✅ |
| **Home (Global)** | `~/.claude/skills/` | ✅ | ✅ | ❌ | ✅* | ✅ |
| **Home (Global)** | `~/.codex/skills/` | ❌ | ✅ | ❌ | ❌ | ❌ |
| **Home (Global)** | `~/.gemini/skills/` | ❌ | ❌ | ✅ | ❌ | ❌ |
| **Home (Global)** | `~/.copilot/skills/`**| ❌ | ❌ | ❌ | ✅ | ❌ |
| **Home (Global)** | `~/.config/opencode/skills/`| ❌ | ❌ | ❌ | ❌ | ✅ |
| **Home (Global)** | `~/.agents/skills/` | ❌ | ✅ | ✅ | ✅ | ✅ |

いくつか注目すべきパターンがあります。

- **ベンダー固有のディレクトリ** (`.claude/`、`.codex/`、`.gemini/`、
  `.github/`、`.opencode/`) は、それぞれの CLI からのみ読み込まれます。
  Skill を意図的に 1 つのエージェントに限定したい場合に使用します。
- **`.agents/` 規約** は Codex、Gemini CLI、GitHub Copilot CLI、
  OpenCode がプロジェクトスコープとホームスコープの両方で共有しています。
  複数のコピーを保守せずに済むよう、ツール横断の Skill はここに置きます。
- **Claude Code** はこの表のうち `.claude/` のパスのみを読み込み、
  `.agents/` ディレクトリは参照しません。
- **`.claude/` によるツール横断の再利用**: Codex、GitHub Copilot CLI、
  OpenCode も `.claude/skills/` と `~/.claude/skills/` を認識するため、
  ワークフローに Claude Code が含まれる場合、これらのパスは実用的な
  最大公約数の配置場所になります。
- **ホームのパスは形が異なる**: ほとんどのエージェントは `~/.<vendor>/skills/`
  に従いますが、OpenCode は XDG 形式の `~/.config/opencode/skills/` を使います。

## Invoking a skill

Claude はフロントマターの `description` に基づいて、一致する Skill を
自動的に呼び出します。
ユーザーが `/<skill-name>` と入力して明示的に Skill を起動することもできます。
