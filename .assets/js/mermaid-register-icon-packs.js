mermaid.regsiterIconPack([
  {
    name: "locos",
    loader: () =>
      fetch("https://unpkg.com/@iconify-json/logos/icons.json").then((res) =>
        res.json(),
      ),
  },
  {
    name: "devicon",
    loader: () =>
      fetch("https://unpkg.com/@iconify-json/devicon/icons.json").then((res) =>
        res.json(),
      ),
  },
  {
    name: "simple-icons",
    loader: () =>
      fetch("https://unpkg.com/@iconify-json/devicon/icons.json").then((res) =>
        res.json(),
      ),
  },
  {
    name: "material-symbols",
    loader: () =>
      fetch("https://unpkg.com/@iconify-json/devicon/icons.json").then((res) =>
        res.json(),
      ),
  },
  {
    name: "mdi",
    loader: () =>
      fetch("https://unpkg.com/@iconify-json/mdi/icons.json").then((res) =>
        res.json(),
      ),
  },
  {
    name: "fas",
    loader: () =>
      fetch("https://unpkg.com/@iconify-json/fa7-solid/icons.json").then((res) =>
        res.json(),
      ),
  },
  {
    name: "fab",
    loader: () =>
      fetch("https://unpkg.com/@iconify-json/fa7-brands/icons.json").then((res) =>
        res.json(),
      ),
  },
]);
