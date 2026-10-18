import * as React from "react"

import Layout from "../components/Layout"
import Seo from "../components/seo"
import CapabilityTable from "../components/CapabilityTable"
import { groupKey } from "../data/menuData"
import snapshot from "@content/data/capabilities.json"

const CapabilityGroupPage = ({ pageContext }) => {
  const { group } = pageContext
  const members = snapshot.capabilities.filter((c) => groupKey(c) === group)
  const [realm, capabilityType] = group.split("/")
  return (
    <Layout>
      <div className="max-w-5xl mx-auto px-2">
        <h1 className="text-3xl font-bold text-bystar-navy mb-4">{group}</h1>
        <p className="text-gray-700 mb-6">
          Realm <strong>{realm}</strong>, capability type <strong>{capabilityType}</strong>: the leaves
          under <code>{snapshot.cbmBase}/{group}/</code>, in walk order.
        </p>
        <CapabilityTable capabilities={members} />
      </div>
    </Layout>
  )
}

export const Head = ({ pageContext }) => <Seo title={pageContext.group} />

export default CapabilityGroupPage
