/**
 * Pages generated from the site's content: one per CBM leaf and one per platform layer, from the
 * snapshots the scripts in ../content/bin write into ../content/data.
 *
 * See: https://www.gatsbyjs.com/docs/reference/config-files/gatsby-node/
 */

const path = require("path")
const fs = require("fs")

// The site's content lives beside site/, in content/; pages import it as "@content/...".
const contentDir = path.resolve(__dirname, "../content")
const snapshotFile = path.join(contentDir, "data/capabilities.json")
const layersFile = path.join(contentDir, "data/platformLayers.json")

/**
 * @type {import('gatsby').GatsbyNode['onPreInit']}
 */
exports.onPreInit = ({ reporter }) => {
  for (const [file, generator] of [
    [snapshotFile, "content/bin/platformCapabilities.py"],
    [layersFile, "content/bin/platformLayers.py"],
  ]) {
    if (!fs.existsSync(file)) {
      reporter.panic(
        `${file} is missing: run ${generator} first (cbm/platform-assemble.cs -i gatsbyBuild does it)`
      )
    }
  }
}

/**
 * @type {import('gatsby').GatsbyNode['onCreateWebpackConfig']}
 */
exports.onCreateWebpackConfig = ({ actions }) => {
  actions.setWebpackConfig({
    resolve: { alias: { "@content": contentDir } },
  })
}

/**
 * @type {import('gatsby').GatsbyNode['createPages']}
 */
exports.createPages = async ({ actions }) => {
  const { createPage } = actions
  const snapshot = JSON.parse(fs.readFileSync(snapshotFile, "utf8"))
  const groups = new Set()
  for (const capability of snapshot.capabilities) {
    groups.add(`${capability.realm}/${capability.capabilityType}`)
    createPage({
      path: capability.slug,
      component: path.resolve(__dirname, "src/templates/capability.js"),
      context: { capability },
    })
  }
  // One page per layer of the platform, from platformLayers.json.
  const layersSnapshot = JSON.parse(fs.readFileSync(layersFile, "utf8"))
  for (const layer of layersSnapshot.layers) {
    createPage({
      path: `/platform/${layer.id}/`,
      component: path.resolve(__dirname, "src/templates/layer.js"),
      context: { layerId: layer.id },
    })
  }
  for (const group of groups) {
    createPage({
      path: `/capabilities/${group}/`,
      component: path.resolve(__dirname, "src/templates/capabilityGroup.js"),
      context: { group },
    })
  }
}
