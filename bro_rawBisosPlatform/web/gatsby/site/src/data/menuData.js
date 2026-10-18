// Menu hierarchy: the fixed pages, the layers (one top-level entry each) and Capabilities
// built from the snapshots. Capabilities from the CBM tree snapshot
// (content/data/capabilities.json, written by content/bin/platformCapabilities.py) as
// Capabilities > <realm>/<capabilityType> > <capability>.

import snapshot from "@content/data/capabilities.json"
import layersSnapshot from "@content/data/platformLayers.json"

// The layers top down, as the stack shows them (the snapshot lists them bottom up).
export const layersTopDown = [...layersSnapshot.layers].reverse()

export function groupKey(c) {
  return `${c.realm}/${c.capabilityType}`
}

export function capabilityGroups(capabilities) {
  const groups = new Map()
  for (const c of capabilities) {
    const key = groupKey(c)
    if (!groups.has(key)) groups.set(key, [])
    groups.get(key).push(c)
  }
  return groups
}

function capabilityMenu(capabilities) {
  return [...capabilityGroups(capabilities)].map(([key, members]) => ({
    label: key,
    path: `/capabilities/${key}`,
    children: members.map((c) => ({ label: c.name, path: c.slug.replace(/\/$/, "") })),
  }))
}

export const menuData = [
  {
    label: "Home",
    path: "/",
  },
  {
    label: "Platform Layers",
    path: "/platform",
  },
  // Each layer at the top level, so they are always in view rather than folded under the above.
  ...layersTopDown.map((l) => ({ label: l.title, path: `/platform/${l.id}` })),
  {
    label: "Capabilities",
    path: "/capabilities",
    children: capabilityMenu(snapshot.capabilities),
  },
  {
    label: "rawBisosCBMs",
    path: "/rawBisosCBMs",
  },
  {
    label: "Sitemap",
    path: "/sitemap",
  },
]
