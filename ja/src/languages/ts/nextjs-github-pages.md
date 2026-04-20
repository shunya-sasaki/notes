# Next.js on GitHub Pages

## Configuration in Next.js project

プロジェクトルートで `next.config.ts` を編集し、`output`、
`basePath`、`assetPrefix` オプションを追加します。

```diff
  import type { NextConfig } from "next";

  const nextConfig: NextConfig = {
    /* config options here */
+   output: "export",
+   basePath: process.env.NODE_ENV === "development" ? "" : "/your-page",
+   assetPrefix: process.env.NODE_ENV === "development" ? "" : "/your-page",
  };

  export default nextConfig;
```

## Configuration on GitHub repository

**Settings** -> **Pages** に移動します。
