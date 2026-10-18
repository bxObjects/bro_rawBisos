import * as React from "react"
import { Link } from "gatsby"

// The platform's layers as a stack, top layer first. The snapshot (content/data/platformLayers.json,
// written by content/bin/platformLayers.py) lists them bottom up. Whatever items a layer has are shown, so
// a new fact needs only the generator.

const layerColor = {
  evolution: "border-green-700",
  bisos: "border-bystar-navy",
  os: "border-blue-600",
  box: "border-gray-500",
}

export function Stages({ stages }) {
  return (
    <div className="flex flex-wrap gap-2 mt-2">
      {stages.map((s, i) => (
        <span key={s.name} className="flex items-center gap-2">
          {i > 0 && <span className="text-gray-400">→</span>}
          <span
            title={s.test}
            className={
              "px-2 py-1 rounded text-xs " +
              (s.current
                ? "bg-green-700 text-white font-bold"
                : s.reached
                ? "bg-green-100 text-green-800"
                : "bg-gray-100 text-gray-500")
            }
          >
            {s.name}
          </span>
        </span>
      ))}
    </div>
  )
}

export function LayerItems({ items, withSource = false }) {
  return (
    <table className="w-full text-sm border-collapse mt-2">
      <tbody>
        {items.map((item) => (
          <tr key={item.label} className="border-b align-top">
            <th className="p-2 text-left font-semibold text-gray-700 whitespace-nowrap w-40">{item.label}</th>
            <td className="p-2">
              <span className="break-all">{item.value}</span>
              {item.detail && <div className="text-xs text-gray-500">{item.detail}</div>}
            </td>
            {withSource && <td className="p-2 text-xs text-gray-500">{item.source}</td>}
          </tr>
        ))}
      </tbody>
    </table>
  )
}

export default function LayerStack({ layers, full = false, capabilitiesCount }) {
  const topDown = [...layers].reverse()
  return (
    <div className="space-y-3">
      {capabilitiesCount !== undefined && (
        <Link
          to="/capabilities"
          className="block p-3 rounded-lg border-l-4 border-amber-600 bg-amber-50 no-underline hover:shadow-md"
        >
          <span className="font-bold text-bystar-navy">Capabilities</span>
          <span className="text-gray-700"> --- {capabilitiesCount} CBM leaves, on top of the layers below</span>
        </Link>
      )}
      {topDown.map((layer) => (
        <div key={layer.id} id={layer.id} className={`p-3 rounded-lg border-l-4 bg-gray-50 ${layerColor[layer.id] || "border-gray-400"}`}>
          <div className="flex flex-wrap justify-between items-baseline gap-2">
            <span>
              <Link to={`/platform/${layer.id}`} className="font-bold text-bystar-navy hover:underline">
                {layer.title}
              </Link>
              <span className="text-xs text-gray-500"> --- {layer.subtitle}</span>
            </span>
            <span className="text-gray-800">{layer.summary}</span>
          </div>
          {layer.stages && <Stages stages={layer.stages} />}
          {full && <LayerItems items={layer.items} withSource />}
        </div>
      ))}
    </div>
  )
}
