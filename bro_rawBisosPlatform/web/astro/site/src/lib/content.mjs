// The site's content: the snapshots that ../content/bin/* write into ../content/data/, read at build
// time. The build refuses to run without them, naming the script to run.

import fs from "node:fs"
import path from "node:path"

export const contentDir = process.env.SITE_CONTENT || path.resolve(process.cwd(), "../content")

function snapshot(name, script) {
  const file = path.join(contentDir, "data", name)
  if (!fs.existsSync(file)) {
    throw new Error(`${file} is missing: run content/bin/${script} first (cbm/platform-assemble.cs -i siteBuild does it)`)
  }
  return JSON.parse(fs.readFileSync(file, "utf8"))
}

export const capabilitiesSnapshot = snapshot("capabilities.json", "platformCapabilities.py")
export const layersSnapshot = snapshot("platformLayers.json", "platformLayers.py")

export const capabilities = capabilitiesSnapshot.capabilities
// The snapshot lists the layers bottom up; the site shows them top down, as a stack.
export const layersTopDown = [...layersSnapshot.layers].reverse()

export const groupKey = (c) => `${c.realm}/${c.capabilityType}`

export function capabilityGroups() {
  const groups = new Map()
  for (const c of capabilities) {
    const key = groupKey(c)
    if (!groups.has(key)) groups.set(key, [])
    groups.get(key).push(c)
  }
  return groups
}

export const gates = ["enabled", "available", "disabled"]
