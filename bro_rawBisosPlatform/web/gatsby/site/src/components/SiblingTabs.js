import * as React from "react"
import { Link } from "gatsby"
import { menuData } from '../data/menuData'

// Normalize path for comparison (remove trailing slash)
function normalizePath(path) {
  return path === "/" ? "/" : path.replace(/\/$/, "")
}

// Find the parent and siblings of the current path
function findParentAndSiblings(currentPath, items, parent = null) {
  const normalizedCurrent = normalizePath(currentPath)
  
  for (let item of items) {
    const normalizedItemPath = normalizePath(item.path)
    
    if (normalizedItemPath === normalizedCurrent) {
      // Found current item
      const siblings = parent ? parent.children : items
      return { siblings, parent }
    }
    
    if (item.children) {
      const result = findParentAndSiblings(currentPath, item.children, item)
      if (result) {
        return result
      }
    }
  }
  
  return null
}

export default function SiblingTabs({ currentPath }) {
  const result = findParentAndSiblings(currentPath, menuData)
  
  if (!result) {
    return null
  }
  
  const { siblings, parent } = result
  
  // If no siblings or only one item, don't show tabs
  if (!siblings || siblings.length <= 1) {
    return null
  }
  
  const normalizedCurrent = normalizePath(currentPath)
  
  // Build the tabs list: parent (if exists) + all siblings
  const tabs = parent ? [parent, ...siblings] : siblings
  
  return (
    <div style={styles.container}>
      <div style={styles.tabsWrapper}>
        {tabs.map((item) => {
          const normalizedItemPath = normalizePath(item.path)
          const isActive = normalizedItemPath === normalizedCurrent
          const isParent = parent && normalizePath(parent.path) === normalizedItemPath
          
          return (
            <Link
              key={item.path}
              to={item.path}
              style={{
                ...styles.tab,
                ...(isActive ? styles.activeTab : {}),
                ...(isParent && !isActive ? styles.parentTab : {}),
              }}
            >
              {item.label}
            </Link>
          )
        })}
      </div>
    </div>
  )
}

const styles = {
  container: {
    backgroundColor: '#f5f5f5',
    borderBottom: '1px solid #ddd',
    padding: '0.5rem 0',
  },
  tabsWrapper: {
    display: 'flex',
    gap: '0.5rem',
    padding: '0 1rem',
    flexWrap: 'wrap',
    alignItems: 'center',
  },
  tab: {
    display: 'inline-block',
    padding: '0.5rem 1rem',
    backgroundColor: '#fff',
    color: '#0066cc',
    textDecoration: 'none',
    border: '1px solid #ddd',
    borderRadius: '4px 4px 0 0',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
  },
  activeTab: {
    backgroundColor: '#0066cc',
    color: '#fff',
    borderColor: '#0066cc',
    fontWeight: 'bold',
  },
  parentTab: {
    backgroundColor: '#f0f0f0',
    color: '#333',
    borderColor: '#999',
    fontStyle: 'italic',
  },
}
