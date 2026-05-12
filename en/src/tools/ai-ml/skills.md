# Skills

<!-- toc -->

- [What are Skills?](#what-are-skills)
- [Skill layout](#skill-layout)
- [SKILL.md format](#skillmd-format)
- [Where to place skills](#where-to-place-skills)
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

- Project-level: `.claude/skills/<skill-name>/SKILL.md`
- User-level: `~/.claude/skills/<skill-name>/SKILL.md`

Project-level skills are checked into the repository and shared with
collaborators; user-level skills are personal and available across
all projects.

## Invoking a skill

Claude invokes a matching skill automatically based on the
`description` in the frontmatter.
Users can also trigger a skill explicitly by typing `/<skill-name>`.
