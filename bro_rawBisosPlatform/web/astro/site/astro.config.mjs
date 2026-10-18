// platform.here: static output, one directory per page (/platform/box/ -> platform/box/index.html),
// served by nginx from site/dist/.
import { defineConfig } from "astro/config"

export default defineConfig({
  site: "http://platform.here",
  output: "static",
  trailingSlash: "always",
  build: { format: "directory" },
  // Keep the whitespace between text and inline elements across line breaks (compression drops it).
  compressHTML: false,
})
