import * as React from "react"
import { Link } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/seo"
import { Answer } from "../components/CapabilityTable"
import LayerStack from "../components/LayerStack"
import layersSnapshot from "@content/data/platformLayers.json"
import snapshot from "@content/data/capabilities.json"

const IndexPage = () => {
  const reachable = snapshot.capabilities.filter((c) => c.url)
  const { enabled, available, disabled } = snapshot.counts
  return (
    <Layout>
      <div className="max-w-5xl mx-auto px-2">
        <h1 className="text-3xl font-bold text-bystar-navy mb-4">This Platform's Capabilities</h1>
        <p className="text-gray-700 mb-6 leading-relaxed">
          <strong>{snapshot.host}</strong> is a Raw-BISOS platform. Its capabilities are the CBM leaves
          planted under <code>{snapshot.cbmBase}</code>: {snapshot.capabilities.length} of them,{" "}
          <span className="text-green-700">{enabled} enabled</span>,{" "}
          <span className="text-amber-600">{available} available</span> and{" "}
          <span className="text-gray-500">{disabled} disabled</span>. Every hereWeb capability is
          reachable as <code>http://&lt;name&gt;.here</code> on this host. See{" "}
          <Link to="/capabilities" className="text-blue-700 hover:underline">Capabilities</Link> for the
          tables and <Link to="/rawBisosCBMs" className="text-blue-700 hover:underline">rawBisosCBMs</Link>{" "}
          for the concepts.
        </p>

        <h2 className="text-2xl font-bold text-bystar-navy mb-4">
          <Link to="/platform" className="hover:underline">The Layers</Link>
        </h2>
        <div className="mb-8">
          <LayerStack layers={layersSnapshot.layers} capabilitiesCount={snapshot.capabilities.length} />
        </div>

        <h2 className="text-2xl font-bold text-bystar-navy mb-4">The .here Sites</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
          {reachable.map((c) => (
            <a
              key={c.slug}
              href={c.url}
              className="block p-4 bg-gray-50 rounded-lg border-l-4 border-bystar-navy hover:shadow-md no-underline"
            >
              <div className="flex justify-between items-baseline">
                <span className="text-lg font-bold text-bystar-navy">{c.hereName}.here</span>
                <span className="text-xs"><Answer capability={c} /></span>
              </div>
              <div className="text-sm text-gray-600 mt-1">{c.description}</div>
              <div className="text-xs text-gray-500 mt-2">gate: {c.gate}</div>
            </a>
          ))}
        </div>

        <p className="text-sm text-gray-600">
          Logins follow the rawBisos convention: user <code>admin</code>, password the service's name
          (for example <code>admin / grafana</code>). Insecure by design; securing a host is a separate
          layer.
        </p>
      </div>
    </Layout>
  )
}

export const Head = () => <Seo title="Home" />

export default IndexPage
