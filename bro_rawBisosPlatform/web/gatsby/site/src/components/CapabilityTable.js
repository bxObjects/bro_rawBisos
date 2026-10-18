import * as React from "react"
import { Link } from "gatsby"

const gates = ["enabled", "available", "disabled"]

const gateStyle = {
  enabled: "text-green-700",
  available: "text-amber-600",
  disabled: "text-gray-500",
}

// What the .here URL answered when the snapshot was taken.
export function Answer({ capability }) {
  const { url, httpStatus } = capability
  if (!url) return <span className="text-gray-400">no .here</span>
  if (capability.isThisSite) return <span className="text-green-700">this site</span>
  if (httpStatus === null || httpStatus === undefined) {
    return <span className="text-red-700 font-semibold">no answer</span>
  }
  const ok = httpStatus < 400
  return <span className={ok ? "text-green-700" : "text-red-700 font-semibold"}>{httpStatus}</span>
}

export function HereLink({ capability }) {
  if (!capability.url) return <span className="text-gray-400">---</span>
  return (
    <a href={capability.url} className="text-blue-700 hover:underline">
      {capability.hereName}.here
    </a>
  )
}

export default function CapabilityTable({ capabilities }) {
  return (
    <div className="overflow-x-auto mb-8">
      <table className="w-full text-sm border-collapse">
        <thead>
          <tr className="bg-gray-100 text-left">
            <th className="p-2 border-b">Capability</th>
            {gates.map((g) => (
              <th key={g} className="p-2 border-b text-center capitalize">{g}</th>
            ))}
            <th className="p-2 border-b">.here</th>
            <th className="p-2 border-b">Answers</th>
            <th className="p-2 border-b">Package</th>
          </tr>
        </thead>
        <tbody>
          {capabilities.map((c) => (
            <tr key={c.slug} className="border-b align-top">
              <td className="p-2">
                <Link to={c.slug} className="font-semibold text-bystar-navy hover:underline">{c.name}</Link>
                <div className="text-xs text-gray-600">{c.description}</div>
              </td>
              {gates.map((g) => (
                <td key={g} className={`p-2 text-center ${gateStyle[g]}`}>
                  {c.gate === g ? "●" : ""}
                </td>
              ))}
              <td className="p-2 whitespace-nowrap"><HereLink capability={c} /></td>
              <td className="p-2 text-center"><Answer capability={c} /></td>
              <td className="p-2">
                {c.repoUrl
                  ? <a href={c.repoUrl} className="text-blue-700 hover:underline">{c.package}</a>
                  : <span className="text-gray-400">/bisos/asc</span>}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
