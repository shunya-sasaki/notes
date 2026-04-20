# Vitest

![vite](https://img.shields.io/badge/vite-gray?logo=vite&labelColor=gray&logoColor=white)

<!-- toc -->

- [Install](#install)
- [Writing tests](#writing-tests)
  - [Create test files](#create-test-files)
  - [Add test script](#add-test-script)
  - [Run tests](#run-tests)
- [Configure Vitest](#configure-vitest)

<!-- /toc -->

## Install

Vitest を開発依存関係としてプロジェクトにインストールします。npm または pnpm を使用できます。

---

**Option 1: Using npm**:

```sh
npm install --save-dev vitest
```

---

**Options 2: Using pnpm**:

```sh
pnpm add -D vitest
```

---

## Writing tests

### Create test files

_sum.ts_:

```ts
export sum = (a: number, b: number) => {
  return a + b;
}
```

_sum.test.ts_:

```ts
import { expect, test } from "vitest";
import { sum } from "./sum.js";

test("adds 1 + 2 to equal 3", () => {
  expect(sum(1, 2)).toBe(3);
});
```

### Add test script

`package.json` に以下のセクションを追加します:

```json
{
  "scripts": {
    "test": "vitest"
  }
}
```

### Run tests

npm を使用してテストを実行します:

```sh
npm run test
```

pnpm を使用している場合は、以下を実行します:

```sh
pnpm run test
```

## Configure Vitest

プロジェクトのルートに `vitest.config.ts` ファイルを作成して Vitest を設定します:

```ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    // ...
  },
});
```
