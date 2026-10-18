import * as React from "react"

export default function HamburgerMenu({ isOpen, onClick }) {
  return (
    <button
      onClick={onClick}
      style={{
        position: 'fixed',
        top: '1rem',
        right: '1rem',
        zIndex: 50,
        padding: '0.5rem',
        backgroundColor: 'white',
        border: '1px solid #d1d5db',
        borderRadius: '0.375rem',
        cursor: 'pointer'
      }}
      className="md:hidden"
      aria-label="Toggle menu"
    >
      <div style={{ width: '1.5rem', height: '1.5rem', display: 'flex', flexDirection: 'column', justifyContent: 'space-around' }}>
        <span
          style={{
            height: '2px',
            width: '1.5rem',
            backgroundColor: '#1f2937',
            transform: isOpen ? 'rotate(45deg) translateY(8px)' : 'rotate(0)',
            transition: 'all 0.2s'
          }}
        />
        <span
          style={{
            height: '2px',
            width: '1.5rem',
            backgroundColor: '#1f2937',
            opacity: isOpen ? 0 : 1,
            transition: 'all 0.2s'
          }}
        />
        <span
          style={{
            height: '2px',
            width: '1.5rem',
            backgroundColor: '#1f2937',
            transform: isOpen ? 'rotate(-45deg) translateY(-8px)' : 'rotate(0)',
            transition: 'all 0.2s'
          }}
        />
      </div>
    </button>
  )
}
