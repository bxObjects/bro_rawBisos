// Reads ../content/tree --- the content tree, in the model of the ByStar Plone 3 ContentTree --- at
// build time. The same rules as bisos.webCap's contentTree_csu (which also validates the tree, builds
// pageLcnt bodies with HeVeA, places files nodes and imports Plone 3 ContentTrees).
//
// A node is a directory; its parameters are one file each:
//   objectType      folder | page | pageLcnt | files | custom | app (auxNode/auxLeaf/rawFiles: old slider, skipped)
//                   link: a tab that leads out (linkUrl), e.g. to another .here site
//                   app: the tree gives the tab, title and place; the page is a fixed page at that path
//                   (site/src/pages/<path>.astro), e.g. a React island, rendered in this layout
//   folderTitle     a folder's label (tabs, sidebar, breadcrumbs)
//   pageTitle       a page's heading and <title>;  pageDescription  its summary
//   pubState        publish: built; anything else: left out
//   excludeFromNav  true: built, but not in the navigation
//   layoutLeftPortlets  (a page) none: no left tree; all: a left tree; absent: the automatic rule
//   body            contentBody.html, else content.html, else contentPreface.html
//   nodesOrdered    a folder's children in navigation order, one per line (the rest by name)
//   contentLang     en | fa | fr ...; inherited; fa/ar/he/ur pages are right-to-left
//   at the root:    defaultPage (its page is also served at /), siteTitle, siteTagline
// A folder's own page is its index_html/ leaf.

import fs from "node:fs"
import path from "node:path"

export const treeDir = process.env.CONTENT_TREE || path.resolve(process.cwd(), "../content/tree")
export const siteStyleDir = path.resolve(treeDir, "../siteStyle")

const rtlLangs = new Set(["fa", "ar", "he", "ur"])
const bodyFiles = ["contentBody.html", "content.html", "contentPreface.html"]

function param(dir, name) {
  const file = path.join(dir, name)
  return fs.existsSync(file) ? fs.readFileSync(file, "utf8").trim() : undefined
}

// A body may be a whole HTML document (HeVeA's) or a fragment: keep its <style> rules and <body>.
function readBody(dir) {
  const name = bodyFiles.find((n) => fs.existsSync(path.join(dir, n)))
  if (!name) return { html: "", css: "" }
  const doc = fs.readFileSync(path.join(dir, name), "utf8")
  const css = [...doc.matchAll(/<style[^>]*>([\s\S]*?)<\/style>/gi)].map((m) => m[1]).join("\n")
  const body = doc.match(/<body[^>]*>([\s\S]*?)<\/body>/i)
  return { html: body ? body[1] : doc.replace(/<style[^>]*>[\s\S]*?<\/style>/gi, ""), css }
}

function pageOf(dir) {
  if (!fs.existsSync(dir) || param(dir, "pubState") !== "publish") return undefined
  return {
    title: param(dir, "pageTitle") || "",
    description: param(dir, "pageDescription") || "",
    leftNav: param(dir, "layoutLeftPortlets"), // none | all | undefined (as the Plone 3 trees set it)
    ...readBody(dir),
  }
}

function childNames(dir) {
  const names = fs
    .readdirSync(dir, { withFileTypes: true })
    .filter((d) => d.isDirectory() && d.name !== "index_html" && fs.existsSync(path.join(dir, d.name, "objectType")))
    .map((d) => d.name)
    .sort()
  const ordered = (param(dir, "nodesOrdered") || "").split(/\s+/).filter((n) => names.includes(n))
  return [...ordered, ...names.filter((n) => !ordered.includes(n))]
}

function readNode(dir, urlPath, parentLang, parent) {
  const lang = param(dir, "contentLang") || parentLang
  const objectType = param(dir, "objectType") || "folder"
  const node = {
    name: path.basename(dir),
    urlPath, // "/" or "/model/nodeTypes/"
    objectType,
    lang,
    dir: rtlLangs.has(lang) ? "rtl" : "ltr",
    inNav: param(dir, "excludeFromNav") !== "true",
    parent,
    children: [],
  }
  if (objectType === "folder") node.page = pageOf(path.join(dir, "index_html"))
  else if (objectType === "page" || objectType === "pageLcnt") node.page = pageOf(dir)
  else if (objectType === "app") node.page = pageOf(dir) && { ...pageOf(dir), isApp: true }
  else if (objectType === "link") node.linkUrl = param(dir, "linkUrl")
  node.title = param(dir, "folderTitle") || node.page?.title || node.name
  for (const name of childNames(dir)) {
    const childDir = path.join(dir, name)
    if (param(childDir, "pubState") !== "publish") continue
    const child = readNode(childDir, `${urlPath}${name}/`, lang, node)
    if (child.objectType === "folder" || child.page || child.linkUrl) node.children.push(child)
  }
  return node
}

let cached
export function contentTree() {
  if (!cached) {
    if (!fs.existsSync(treeDir)) throw new Error(`${treeDir} is missing: the site's pages come from content/tree/`)
    const root = readNode(treeDir, "/", param(treeDir, "contentLang") || "en", undefined)
    root.title = param(treeDir, "siteTitle") || "Site"
    root.tagline = param(treeDir, "siteTagline") || ""
    root.defaultNode = root.children.find((c) => c.name === param(treeDir, "defaultPage"))
    cached = root
  }
  return cached
}

// Every node with a page, depth first.
export function pageNodes(node = contentTree()) {
  return [...(node.page ? [node] : []), ...node.children.flatMap((c) => pageNodes(c))]
}

export function ancestors(node) {
  const list = []
  for (let n = node; n; n = n.parent) list.unshift(n)
  return list
}

export const navChildren = (node) => node.children.filter((c) => c.inNav)

// Where a navigation entry leads: its page, or for a link node its linkUrl (opened in a new tab).
export const hrefOf = (node) => node.linkUrl || node.urlPath
export const linkAttrs = (node) => (node.linkUrl ? { target: "_blank", rel: "noopener" } : {})

// The node at a site path ("/csPlayer/"), for a fixed page that renders an app node.
export function nodeAt(urlPath, node = contentTree()) {
  if (node.urlPath === urlPath) return node
  for (const child of node.children) {
    const found = nodeAt(urlPath, child)
    if (found) return found
  }
  return undefined
}

export function logoHtml() {
  const file = path.join(siteStyleDir, "logo.html")
  return fs.existsSync(file) ? fs.readFileSync(file, "utf8") : ""
}
