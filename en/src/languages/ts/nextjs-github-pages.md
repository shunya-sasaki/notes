# Next.js on GitHub Pages

## Configuration in Next.js project

In the project root, edit `next.config.ts` to add the `output`,
`basePath`, and `assetPrefix` options.

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

Go to **Settings** -> **Pages**.
