# TypeScript Style Guide

## Naming rurles

### Functions and Classes

| Item               | Style        |
| ------------------ | ------------ |
| Function           | `camelCase`  |
| Function component | `PascalCase` |
| Interface          | `PascalCase` |
| Hooks              | `PascalCase` |

### Directories

| Item           | Style        |
| -------------- | ------------ |
| Page directory | `kebab-case` |
| Component      | `PascalCase` |
| Other          | `lowercase`  |

### Files

| Item           | Style              |
| -------------- | ------------------ |
| Page file      | `page.tsx`         |
| Hooks file     | `useCamelCase.tsx` |
| Component file | `PascalCase.tsx`   |
| Interface file | `PascalCase.ts`    |
| Type file      | `PascalCase.ts`    |

### Common folder conventions

| Folder name  | Description                                                              |
| ------------ | ------------------------------------------------------------------------ |
| `components` | Reusable components that can be used across different pages or features. |
| `hooks`      | Custom React hooks that encapsulate reusable logic.                      |
| `lib`        | Third-party integrations and low-level helper libraries.                 |
| `utils`      | General-purpose utility and helper functions.                            |
| `styles`     | Global styles, CSS/SCSS files, and theme definitions.                    |
| `types`      | Shared TypeScript type and interface definitions.                        |
| `stores`     | State management stores (e.g., Zustand, Redux).                          |
| `constants`  | Application-wide constant values.                                        |
| `public`     | Static assets served publicly (images, fonts, icons, etc.).              |
| `api`        | API route handlers or API client functions.                              |
| `context`    | React context providers and consumers.                                   |
| `services`   | Business logic and external service integrations.                        |
| `middleware` | Middleware functions for request/response handling.                      |

## Function Definitions

Use arrow functions for defining functions, as they provide a more concise syntax.

**Yes**:

```typescript
const someFunction = () => {}
  const value = 42;
  return value;
};

const SomeComponent: React.FC = () => {
  return <div>Some Component</div>;
};
```

**No**:

```typescript
function someFunction() {
  const value = 42;
  return value;
}

function SomeComponent() {
  return <div>Some Component</div>;
}
```
