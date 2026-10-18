import * as React from "react"
import snapshot from "@content/data/capabilities.json"

export default function Footer() {
  return (
    <footer className="bg-gray-800 text-white px-4 md:px-8 py-8 text-center border-t-4 border-blue-600 mt-auto">
      <div className="max-w-6xl mx-auto text-sm">
        <p className="m-0">
          Snapshot of <code>{snapshot.cbmBase}</code> taken {snapshot.generatedAt}. Rebuild
          with <code>platform-assemble.cs -i gatsbyBuild</code>.
        </p>
        <p className="m-0 mt-2">
          Part of <a href="https://github.com/bxGenesis/start" className="text-blue-400 hover:text-blue-300">BISOS</a>,
          the ByStar Internet Services Operating System.
        </p>
      </div>
    </footer>
  )
}
