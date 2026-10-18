import * as React from "react"
import { Link } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/seo"

// A summary of bxGenesis/start/rawBisosCBMs/README.org, which stays the source.
const readmeUrl = "https://github.com/bxGenesis/start/blob/main/rawBisosCBMs/README.org"

function Section({ title, children }) {
  return (
    <section className="mb-8">
      <h2 className="text-2xl font-bold text-bystar-navy mb-3">{title}</h2>
      <div className="text-gray-700 leading-relaxed space-y-3">{children}</div>
    </section>
  )
}

const layering = `+----------------------------------------------------------------------+
| 3. Niching + CapabilityBPOs  (later)                                 |
|    a real server's configuration and scale, over the generic CBS     |
+----------------------------------------------------------------------+
| 2. Generic CBM pip packages  (bisos.kafka, bisos.grafana, ...)       |
|    the base layer: each capability installed, minimal, as x.here     |
+----------------------------------------------------------------------+
| 1. Raw-BISOS platform  (raw-bisos.sh, from a Fresh-Debian)           |
|    /bisos, bystar, Blee, the venvs, bro_rawBisos as /bisos/platform  |
+----------------------------------------------------------------------+`

const RawBisosCbmsPage = () => (
  <Layout>
    <div className="max-w-4xl mx-auto px-2">
      <h1 className="text-3xl font-bold text-bystar-navy mb-2">rawBisosCBMs</h1>
      <p className="text-gray-700 mb-6">
        How the capabilities of a Raw-BISOS platform are built. A summary of the{" "}
        <a href={readmeUrl} className="text-blue-700 hover:underline">rawBisosCBMs README</a>, which
        remains the source.
      </p>

      <Section title="The Layering">
        <pre className="bg-gray-100 p-4 rounded text-xs overflow-x-auto">{layering}</pre>
        <p>
          <code>raw-bisos.sh</code> turns a Fresh-Debian into Raw-BISOS and ends at the platform; no
          capability is materialized by it. Each capability is then packaged once, generically, as a{" "}
          <code>bisos.&lt;name&gt;</code> pip package: a starting point to be configured, brought up in a
          minimal, out-of-the-box form that every raw platform gets the same way. What makes a
          deployment real (scale, site settings, security) is to come from CapabilityBPOs applied by
          niching.
        </p>
      </Section>

      <Section title="What a CBM Is">
        <ul className="list-disc pl-6 space-y-1">
          <li><strong>CBA</strong> --- Capability Bundle Abstraction: the framework, <code>bisos.capability</code>.</li>
          <li><strong>CBS</strong> --- Capability Bundle Specification: one capability's sboms, systemd units and assembly (<code>&lt;name&gt;-cbs.pcs</code>).</li>
          <li><strong>CBM</strong> --- Capability Bundle Materialization: a CBS turned into running state on this host.</li>
        </ul>
        <p>
          A CBM <em>leaf</em> lives at <code>/bisos/platform/sys/cbm/&lt;realm&gt;/&lt;capabilityType&gt;/&lt;name&gt;/</code>{" "}
          and points at a CBS (<code>cbmProc.spcs</code>), with a gate (<code>cbmProc.control</code>) and an
          outcome log (<code>cbmProc.status</code>). The gate is <em>enabled</em> (materialized with the
          tree), <em>available</em> (planted, not materialized automatically) or <em>disabled</em>{" "}
          (skipped). The <Link to="/capabilities" className="text-blue-700 hover:underline">Capabilities</Link>{" "}
          tables show exactly this.
        </p>
      </Section>

      <Section title="The .here Convention">
        <p>
          Every hereWeb capability is reachable as <code>http://&lt;name&gt;.here</code>: a fake domain in{" "}
          <code>/etc/hosts</code> on a <code>127.0.22.x</code> address that <code>bisos.banna</code>{" "}
          assigns once to the capability's port, served by nginx proxying to the program on{" "}
          <code>127.0.0.1</code>. Nothing listens beyond loopback, and every raw platform gets the same
          names, addresses and ports: an out-of-the-box experience, and regression-testable.
        </p>
        <p>
          Logins follow the rawBisos convention: user <code>admin</code>, password the service's name.
          Insecure by design; securing a host is a separate layer.
        </p>
      </Section>

      <Section title="Regression">
        <p>CBM regression is managed by <code>bisos.capability</code>:</p>
        <pre className="bg-gray-100 p-4 rounded text-xs overflow-x-auto">{`sysCbmManage.cs -i fullyMaterialize

# which walks, for collective/hereWeb:
ftoBranchProc.spcs -i fto_forwardToLeaves --cmndName=cbm_status
ftoBranchProc.spcs -i fto_forwardToLeaves --cmndName=cbm_materialize`}</pre>
        <p>
          Each enabled leaf invokes its CBS with <code>cbs_materialize</code> and appends the outcome to
          its <code>cbmProc.status</code>, in the order of <code>branchesOrdered</code>. This site is the
          last leaf of that walk, so it is rebuilt after every other capability and its snapshot shows
          their outcome. Read the status lines rather than the exit status: a failed Cmnd still exits 0.
        </p>
      </Section>
    </div>
  </Layout>
)

export const Head = () => <Seo title="rawBisosCBMs" />

export default RawBisosCbmsPage
