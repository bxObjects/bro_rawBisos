import * as React from "react"
import { Link } from "gatsby"
import snapshot from "@content/data/capabilities.json"

export default function Header() {
  return (
    <header className="bg-gray-800 text-white px-4 md:px-8 py-4 md:py-8 border-b-4 border-blue-600">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-2xl md:text-4xl m-0 font-bold">
          <Link to="/" className="text-white no-underline">platform.here</Link>
        </h1>
        <p className="text-sm md:text-base m-0 mt-2 opacity-90">
          The capabilities of the Raw-BISOS platform <strong>{snapshot.host}</strong>
        </p>
      </div>
    </header>
  )
}
