// Static output, one directory per page (/model/ -> model/index.html), as nginx serves it from site/dist/.
import { defineConfig } from "astro/config"

export default defineConfig({
  output: "static",
  trailingSlash: "always",
  build: { format: "directory" },
  // Keep the whitespace between text and inline elements across line breaks (compression drops it).
  compressHTML: false,
})
