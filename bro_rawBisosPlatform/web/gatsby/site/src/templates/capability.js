import * as React from "react"
import { Link } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/seo"
import { Answer, HereLink } from "../components/CapabilityTable"
import snapshot from "@content/data/capabilities.json"

function Row({ label, children }) {
  return (
    <tr className="border-b align-top">
      <th className="p-2 text-left font-semibold text-gray-700 whitespace-nowrap">{label}</th>
      <td className="p-2">{children}</td>
    </tr>
  )
}

const CapabilityPage = ({ pageContext }) => {
  const c = pageContext.capability
  const leafDir = `${snapshot.cbmBase}/${c.realm}/${c.capabilityType}/${c.name}`
  const group = `${c.realm}/${c.capabilityType}`
  return (
    <Layout>
      <div className="max-w-5xl mx-auto px-2">
        <p className="text-sm mb-2">
          <Link to={`/capabilities/${group}`} className="text-blue-700 hover:underline">{group}</Link>
        </p>
        <h1 className="text-3xl font-bold text-bystar-navy mb-2">{c.name}</h1>
        <p className="text-gray-700 mb-6">{c.description}</p>

        {c.url && (
          <p className="mb-6">
            <a
              href={c.url}
              className="inline-block px-6 py-3 bg-bystar-navy text-white rounded-lg font-bold no-underline hover:shadow-lg"
            >
              Open {c.hereName}.here
            </a>
          </p>
        )}

        <table className="w-full text-sm border-collapse mb-8">
          <tbody>
            <Row label="Gate">{c.gate} <span className="text-gray-500">(cbmProc.control)</span></Row>
            <Row label="Last outcome">
              {c.lastStatus ? <code>{c.lastStatus}</code> : <span className="text-gray-500">none yet</span>}
            </Row>
            <Row label=".here"><HereLink capability={c} /></Row>
            <Row label="Answers"><Answer capability={c} /> <span className="text-gray-500">at {snapshot.generatedAt}</span></Row>
            <Row label="Address">
              {c.hereIp ? <code>{c.hereIp}</code> : "---"}
              {c.portNu ? <span> --- nginx proxies to <code>127.0.0.1:{c.portNu}</code></span> : null}
            </Row>
            <Row label="Package">
              {c.repoUrl ? <a href={c.repoUrl} className="text-blue-700 hover:underline">{c.package}</a> : "/bisos/asc"}
            </Row>
            <Row label="CBS"><code className="break-all">{c.cbsSpec}</code></Row>
            <Row label="Leaf"><code className="break-all">{leafDir}/</code></Row>
          </tbody>
        </table>

        <h2 className="text-xl font-bold text-bystar-navy mb-2">Operating It</h2>
        <pre className="bg-gray-100 p-4 rounded text-xs overflow-x-auto">{`cd ${leafDir}
./cbmProc.spcs -i cbm_status         # the gate and the outcome log
./cbmProc.spcs -i cbm_materialize    # materialize, if enabled
${c.cbsSpec.split("/").pop()} -i examples   # the CBS itself`}</pre>
      </div>
    </Layout>
  )
}

export const Head = ({ pageContext }) => <Seo title={pageContext.capability.name} />

export default CapabilityPage
