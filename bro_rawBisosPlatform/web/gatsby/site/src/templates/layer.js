import * as React from "react"
import { Link } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/seo"
import { LayerItems, Stages } from "../components/LayerStack"
import { layersTopDown } from "../data/menuData"
import layersSnapshot from "@content/data/platformLayers.json"

function Neighbour({ label, layer }) {
  if (!layer) return <span />
  return (
    <Link to={`/platform/${layer.id}`} className="text-blue-700 hover:underline">
      {label}: {layer.title}
    </Link>
  )
}

const LayerPage = ({ pageContext }) => {
  const i = layersTopDown.findIndex((l) => l.id === pageContext.layerId)
  const layer = layersTopDown[i]
  return (
    <Layout>
      <div className="max-w-5xl mx-auto px-2">
        <p className="text-sm mb-2">
          <Link to="/platform" className="text-blue-700 hover:underline">Platform Layers</Link>
        </p>
        <h1 className="text-3xl font-bold text-bystar-navy mb-1">{layer.title}</h1>
        <p className="text-gray-600 mb-4">{layer.subtitle}</p>
        <p className="text-xl text-gray-800 mb-4">{layer.summary}</p>
        {layer.stages && <Stages stages={layer.stages} />}
        <LayerItems items={layer.items} withSource />
        <p className="text-xs text-gray-500 mt-4">Detected {layersSnapshot.generatedAt}.</p>
        <div className="flex justify-between mt-6 text-sm">
          <Neighbour label="Above" layer={layersTopDown[i - 1]} />
          <Neighbour label="Below" layer={layersTopDown[i + 1]} />
        </div>
      </div>
    </Layout>
  )
}

export const Head = ({ pageContext }) => {
  const layer = layersSnapshot.layers.find((l) => l.id === pageContext.layerId)
  return <Seo title={layer.title} />
}

export default LayerPage
