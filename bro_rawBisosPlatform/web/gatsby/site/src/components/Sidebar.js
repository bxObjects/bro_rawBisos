import * as React from "react"
import { useLocation } from "@reach/router"
import MenuItem from './MenuItem'
import { menuData } from '../data/menuData'

// Normalize path for comparison (remove trailing slash)
function normalizePath(path) {
  return path === "/" ? "/" : path.replace(/\/$/, "")
}

// Get all expanded paths based on current path
function getExpandedPaths(currentPath, items, expandedPaths = new Set()) {
  const normalizedCurrent = normalizePath(currentPath)
  
  for (let item of items) {
    const normalizedItemPath = normalizePath(item.path)
    
    // If current path matches this item or is in its children, expand it
    if (normalizedCurrent === normalizedItemPath || isPathInSubtree(normalizedCurrent, item.children || [])) {
      expandedPaths.add(normalizedItemPath)
    }
    
    // Recurse into children
    if (item.children) {
      getExpandedPaths(currentPath, item.children, expandedPaths)
    }
  }
  
  return expandedPaths
}

function isPathInSubtree(path, items) {
  if (!items) return false
  for (let item of items) {
    const normalizedItemPath = normalizePath(item.path)
    if (normalizedItemPath === path) {
      return true
    }
    if (item.children && isPathInSubtree(path, item.children)) {
      return true
    }
  }
  return false
}

export default function Sidebar() {
  const location = useLocation()
  const currentPath = normalizePath(location.pathname)
  const expandedPaths = getExpandedPaths(currentPath, menuData)
  
  return (
    <nav style={styles.nav}>
      <div style={styles.menuContainer}>
        {menuData.map((item) => (
          <MenuItem
            key={item.path}
            item={item}
            level={0}
            currentPath={currentPath}
            expandedPaths={expandedPaths}
          />
        ))}
      </div>
    </nav>
  )
}

const styles = {
  sidebar: {
    width: '100%',
  },
  nav: {
    width: '100%',
  },
  menuContainer: {
    display: 'flex',
    flexDirection: 'column',
  },
}