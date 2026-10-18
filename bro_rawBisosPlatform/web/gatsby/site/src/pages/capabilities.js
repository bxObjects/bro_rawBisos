import * as React from "react"
import { Link } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/seo"
import CapabilityTable from "../components/CapabilityTable"
import { capabilityGroups } from "../data/menuData"
import snapshot from "@content/data/capabilities.json"

const CapabilitiesPage = () => (
  <Layout>
    <div className="max-w-5xl mx-auto px-2">
      <h1 className="text-3xl font-bold text-bystar-navy mb-4">Capabilities</h1>
      <p className="text-gray-700 mb-6 leading-relaxed">
        One table per <code>realm/capabilityType</code>, in the order the walk materializes them. The
        gate is the leaf's <code>cbmProc.control</code>: <em>enabled</em> is materialized with the
        tree, <em>available</em> is planted but not materialized automatically, <em>disabled</em> is
        skipped. <em>Answers</em> is what the <code>.here</code> URL returned when this snapshot was
        taken ({snapshot.generatedAt}).
      </p>
      {[...capabilityGroups(snapshot.capabilities)].map(([key, members]) => (
        <section key={key}>
          <h2 className="text-xl font-bold text-bystar-navy mb-2">
            <Link to={`/capabilities/${key}`} className="hover:underline">{key}</Link>
          </h2>
          <CapabilityTable capabilities={members} />
        </section>
      ))}
    </div>
  </Layout>
)

export const Head = () => <Seo title="Capabilities" />

export default CapabilitiesPage
