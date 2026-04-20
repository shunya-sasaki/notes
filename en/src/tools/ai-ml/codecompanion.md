# CodeCompanion

In this document, we will explore the features and functionalities of CodeCompanion,

## What is CodeCompanion?

CodeCompanion is a tool designed to assist developers by providing
code suggestions, explanations, and debugging help.
It integrates with various programming environments to enhance productivity
and streamline the coding process.

## Workspace

> [!NOTE]
> [CodeCompanion: Creating Workspaces](https://codecompanion.olimorris.dev/extending/workspace.html)

### Workspace setting file

You can create a workspace setting file `codecompanion-workspace.json`
to configure CodeCompanion.
You should place this file in the root directory of your project.

```diff
  PROJECT
  |- codecompanion-workspace.json
  `- README.md
```

The following is an example of a workspace setting file:

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
