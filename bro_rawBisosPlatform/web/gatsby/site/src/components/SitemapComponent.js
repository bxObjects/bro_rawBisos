import * as React from "react"
import { Link } from "gatsby"
import { menuData } from '../data/menuData'

function SitemapItem({ item, level = 0 }) {
  const hasChildren = item.children && item.children.length > 0
  const marginLeft = `${level * 2}rem`
  
  return (
    <div key={item.path}>
      <div style={{ marginLeft, paddingBottom: '0.5rem' }}>
        <Link to={item.path} style={styles.link}>
          {item.label}
        </Link>
        {hasChildren && (
          <span style={styles.childCount}>
            ({item.children.length} {item.children.length === 1 ? 'item' : 'items'})
          </span>
        )}
      </div>
      {hasChildren && (
        <div>
          {item.children.map((child) => (
            <SitemapItem key={child.path} item={child} level={level + 1} />
          ))}
        </div>
      )}
    </div>
  )
}

export default function SitemapComponent() {
  return (
    <div style={styles.container}>
      <h2>Site Map</h2>
      <p style={styles.description}>
        Complete hierarchy of all pages on this site. Click any link to navigate.
      </p>
      <div style={styles.tree}>
        {menuData.map((item) => (
          <SitemapItem key={item.path} item={item} level={0} />
        ))}
      </div>
    </div>
  )
}

const styles = {
  container: {
    padding: '2rem',
  },
  description: {
    color: '#666',
    marginBottom: '2rem',
    fontStyle: 'italic',
  },
  tree: {
    backgroundColor: '#f9f9f9',
    padding: '2rem',
    borderRadius: '8px',
    border: '1px solid #e0e0e0',
  },
  link: {
    color: '#0066cc',
    textDecoration: 'none',
    fontWeight: '500',
  },
  childCount: {
    color: '#999',
    fontSize: '0.85rem',
    marginLeft: '0.5rem',
  },
}
