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

| Folder name  | Description                                                                        |
| ------------ | ---------------------------------------------------------------------------------- |
| `components` | 異なるページや機能間で再利用可能なコンポーネントです。                             |
| `hooks`      | 再利用可能なロジックをカプセル化するカスタム React フックです。                     |
| `lib`        | サードパーティとの統合や低レベルのヘルパーライブラリです。                          |
| `utils`      | 汎用的なユーティリティおよびヘルパー関数です。                                     |
| `styles`     | グローバルスタイル、CSS/SCSS ファイル、テーマ定義です。                             |
| `types`      | 共有の TypeScript 型およびインターフェース定義です。                                |
| `stores`     | 状態管理ストア（例: Zustand, Redux）です。                                         |
| `constants`  | アプリケーション全体の定数値です。                                                 |
| `public`     | 公開される静的アセット（画像、フォント、アイコンなど）です。                       |
| `api`        | API ルートハンドラーまたは API クライアント関数です。                               |
| `context`    | React コンテキストプロバイダーおよびコンシューマーです。                            |
| `services`   | ビジネスロジックおよび外部サービスとの統合です。                                   |
| `middleware`  | リクエスト/レスポンス処理のためのミドルウェア関数です。                             |

## Function Definitions

関数の定義にはアロー関数を使用してください。より簡潔な構文を提供します。

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
