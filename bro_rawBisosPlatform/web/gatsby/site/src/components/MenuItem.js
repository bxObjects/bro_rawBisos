import * as React from "react"
import { Link } from "gatsby"

// Normalize path for comparison (remove trailing slash)
function normalizePath(path) {
  return path === "/" ? "/" : path.replace(/\/$/, "")
}

export default function MenuItem({ item, level = 0, currentPath, expandedPaths = new Set() }) {
  const normalizedCurrentPath = normalizePath(currentPath)
  const normalizedItemPath = normalizePath(item.path)
  
  const hasChildren = item.children && item.children.length > 0
  const isCurrentPage = normalizedCurrentPath === normalizedItemPath
  const isExpanded = expandedPaths.has(normalizedItemPath)
  const [toggledExpanded, setToggledExpanded] = React.useState(false)
  
  const displayExpanded = isExpanded || toggledExpanded
  const paddingLeft = `${level * 1.5}rem`
  
  return (
    <div key={item.path}>
      <div style={{ display: 'flex', alignItems: 'center', paddingLeft }}>
        {hasChildren && (
          <button
            onClick={() => setToggledExpanded(!toggledExpanded)}
            style={styles.expandButton}
            aria-label={displayExpanded ? "Collapse" : "Expand"}
          >
            {displayExpanded ? "▼" : "▶"}
          </button>
        )}
        {!hasChildren && <span style={styles.noChildrenSpacer}></span>}
        
        <Link
          to={item.path}
          style={{
            ...styles.navLink,
            ...(isCurrentPage ? styles.activeLink : {}),
          }}
        >
          {item.label}
        </Link>
      </div>
      
      {hasChildren && displayExpanded && (
        <div>
          {item.children.map((child) => (
            <MenuItem
              key={child.path}
              item={child}
              level={level + 1}
              currentPath={currentPath}
              expandedPaths={expandedPaths}
            />
          ))}
        </div>
      )}
    </div>
  )
}

const styles = {
  expandButton: {
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    padding: '0.25rem 0.5rem',
    color: '#0066cc',
    fontSize: '0.9rem',
    marginRight: '0.25rem',
  },
  noChildrenSpacer: {
    display: 'inline-block',
    width: '1.75rem',
  },
  navLink: {
    display: 'block',
    padding: '0.5rem',
    color: '#0066cc',
    textDecoration: 'none',
    borderRadius: '4px',
    flex: 1,
  },
  activeLink: {
    backgroundColor: '#e0e0ff',
    color: '#0033aa',
    fontWeight: 'bold',
  },
}
