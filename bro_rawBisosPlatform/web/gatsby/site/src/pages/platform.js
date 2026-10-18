import * as React from "react"
import { Link } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/seo"
import LayerStack from "../components/LayerStack"
import layersSnapshot from "@content/data/platformLayers.json"
import snapshot from "@content/data/capabilities.json"

const PlatformPage = () => (
  <Layout>
    <div className="max-w-5xl mx-auto px-2">
      <h1 className="text-3xl font-bold text-bystar-navy mb-4">The Platform's Layers</h1>
      <p className="text-gray-700 mb-6 leading-relaxed">
        This platform as four layers, from the bottom: the <strong>Box</strong> (the hardware or
        virtualized resource), the <strong>OS</strong>, <strong>BISOS</strong> on it, and how far that
        BISOS has evolved (<strong>BISOS-Evolution</strong>). The{" "}
        <Link to="/capabilities" className="text-blue-700 hover:underline">capabilities</Link> run on
        top. Each value is detected when the site is built ({layersSnapshot.generatedAt}); the last
        column says where it came from.
      </p>
      <LayerStack layers={layersSnapshot.layers} full capabilitiesCount={snapshot.capabilities.length} />
    </div>
  </Layout>
)

export const Head = () => <Seo title="Platform Layers" />

export default PlatformPage
