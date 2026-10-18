import * as React from "react"

export default function MobileOverlay({ isOpen, onClick }) {
  if (!isOpen) return null

  return (
    <div
      className="fixed inset-0 bg-black bg-opacity-50 z-30 md:hidden"
      onClick={onClick}
      aria-hidden="true"
    />
  )
}
