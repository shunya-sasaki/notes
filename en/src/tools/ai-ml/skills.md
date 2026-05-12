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

Skills are reusable capabilities for Claude Code that bundle instructions,
scripts, and reference files into a single directory.
When the user's request matches a skill's description,
Claude loads the skill and follows its instructions.

## Skill layout

A skill is a directory containing a `SKILL.md` file and any supporting
assets (scripts, templates, references).

```text
my-skill/
├── SKILL.md
├── scripts/
│   └── helper.sh
└── references/
    └── notes.md
```

## SKILL.md format

`SKILL.md` starts with YAML frontmatter that declares the skill's name
and a short description used for matching, followed by the body with
the actual instructions.

```markdown
---
name: my-skill
description: Short summary of what this skill does and when to use it.
---

# My Skill

Detailed instructions for Claude go here.
```

## Where to place skills

Skills can live in either a **project** directory or a **home (global)**
directory.
Project-scoped skills sit inside the repository and are typically
checked in so collaborators share the same set.
Home-scoped skills live under the user's home directory and are
available across every project on that machine.

Each CLI agent looks for skills under its own vendor-specific
directory.
Several agents additionally honor a shared `.agents/skills/`
convention, so a single set of skills can be reused across multiple
tools without duplication.

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

A few patterns are worth noting:

- **Vendor-specific directories** (`.claude/`, `.codex/`, `.gemini/`,
  `.github/`, `.opencode/`) are read only by their own CLI.
  Use them when a skill is intentionally scoped to one agent.
- **The `.agents/` convention** is shared by Codex, Gemini CLI, GitHub
  Copilot CLI, and OpenCode at both project and home scope.
  Put cross-tool skills here to avoid maintaining multiple copies.
- **Claude Code** reads only the `.claude/` paths in this table and
  does not pick up the `.agents/` directory.
- **Cross-tool reuse via `.claude/`**: Codex, GitHub Copilot CLI, and
  OpenCode also recognize `.claude/skills/` and `~/.claude/skills/`,
  which makes those paths a practical lowest-common-denominator
  location when Claude Code is part of the workflow.
- **Home paths differ in shape**: most agents follow `~/.<vendor>/skills/`,
  while OpenCode uses the XDG-style `~/.config/opencode/skills/`.

## Invoking a skill

Claude invokes a matching skill automatically based on the
`description` in the frontmatter.
Users can also trigger a skill explicitly by typing `/<skill-name>`.
