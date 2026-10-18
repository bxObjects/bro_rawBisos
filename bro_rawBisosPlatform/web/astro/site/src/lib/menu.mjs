// The site's navigation, which is also the site map: the top-level entries are the tabs; an entry with
// children is a section with a left tree --- Platform Layers (its leaves: the layers, top down) and
// Capabilities (realm/capabilityType groups and their leaves, from the snapshot). The Site Map itself is
// a site action in the header, not a tab. The astro-starter-bystar model.

import { layersTopDown, capabilityGroups } from "./content.mjs"

export const menu = [
  { label: "Home", path: "/" },
  {
    label: "Platform Layers",
    path: "/platform/",
    children: layersTopDown.map((l) => ({ label: l.title, path: `/platform/${l.id}/` })),
  },
  {
    label: "Capabilities",
    path: "/capabilities/",
    children: [...capabilityGroups()].map(([key, members]) => ({
      label: key,
      path: `/capabilities/${key}/`,
      children: members.map((c) => ({ label: c.name, path: c.slug })),
    })),
  },
  { label: "rawBisosCBMs", path: "/rawBisosCBMs/" },
]

// True when path is the item's page or below it: its group stays open.
export const onPath = (item, path) => path === item.path || (item.path !== "/" && path.startsWith(item.path))

// The tab a page belongs to: the top-level entry whose path is the longest prefix of the page's.
export function sectionOf(path) {
  return menu
    .filter((item) => (item.path === "/" ? path === "/" : path.startsWith(item.path)))
    .sort((a, b) => b.path.length - a.path.length)[0]
}
