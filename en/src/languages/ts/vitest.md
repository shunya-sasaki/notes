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

Install Vitest as a development dependency in your project using either npm or pnpm.

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

Add the following section to `package.json`:

```json
{
  "scripts": {
    "test": "vitest"
  }
}
```

### Run tests

Run the tests using npm:

```sh
npm run test
```

If you are using pnpm, run:

```sh
pnpm run test
```

## Configure Vitest

Create a `vitest.config.ts` file in the root of your project to configure Vitest:

```ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    // ...
  },
});
```
