import * as React from "react"
import { Link } from "gatsby"
import { buildSearchIndex, search } from '../utils/searchIndex'
import { menuData } from '../data/menuData'

export default function SearchBox() {
  const [query, setQuery] = React.useState('')
  const [results, setResults] = React.useState([])
  const [searchData, setSearchData] = React.useState(null)
  const [showResults, setShowResults] = React.useState(false)
  const [isMouseOverResults, setIsMouseOverResults] = React.useState(false)

  // Build index on component mount
  React.useEffect(() => {
    const data = buildSearchIndex(menuData)
    setSearchData(data)
  }, [])

  // Search as user types
  React.useEffect(() => {
    if (searchData && query.trim().length > 0) {
      const searchResults = search(query, searchData)
      setResults(searchResults)
      setShowResults(true)
    } else {
      setResults([])
      setShowResults(false)
    }
  }, [query, searchData])

  const handleInputBlur = () => {
    // Only hide results if mouse is not over the results dropdown
    if (!isMouseOverResults) {
      setShowResults(false)
    }
  }

  return (
    <div style={styles.container}>
      <input
        type="text"
        placeholder="Search pages..."
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        onFocus={() => query.trim().length > 0 && setShowResults(true)}
        onBlur={handleInputBlur}
        style={styles.input}
      />
      
      {showResults && results.length > 0 && (
        <div 
          style={styles.resultsContainer}
          onMouseEnter={() => setIsMouseOverResults(true)}
          onMouseLeave={() => setIsMouseOverResults(false)}
        >
          <div style={styles.resultsHeader}>
            Found {results.length} result{results.length !== 1 ? 's' : ''}
          </div>
          <ul style={styles.resultsList}>
            {results.map((result) => (
              <li key={result.id} style={styles.resultItem}>
                <Link
                  to={result.path}
                  style={styles.resultLink}
                  onClick={() => {
                    setQuery('')
                    setShowResults(false)
                  }}
                >
                  {result.title}
                </Link>
              </li>
            ))}
          </ul>
        </div>
      )}
      
      {showResults && query.trim().length > 0 && results.length === 0 && (
        <div style={styles.noResults}>
          No results found for "{query}"
        </div>
      )}
    </div>
  )
}

const styles = {
  container: {
    position: 'relative',
    width: '100%',
    maxWidth: '400px',
  },
  input: {
    width: '100%',
    padding: '0.75rem',
    fontSize: '1rem',
    border: '1px solid #ddd',
    borderRadius: '4px',
    boxSizing: 'border-box',
  },
  resultsContainer: {
    position: 'absolute',
    top: '100%',
    left: 0,
    right: 0,
    backgroundColor: '#fff',
    border: '1px solid #ddd',
    borderTop: 'none',
    borderRadius: '0 0 4px 4px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
    maxHeight: '400px',
    overflowY: 'auto',
    zIndex: 1000,
  },
  resultsHeader: {
    padding: '0.5rem 1rem',
    backgroundColor: '#f5f5f5',
    borderBottom: '1px solid #ddd',
    fontSize: '0.85rem',
    color: '#666',
    fontWeight: 'bold',
  },
  resultsList: {
    listStyle: 'none',
    padding: 0,
    margin: 0,
  },
  resultItem: {
    borderBottom: '1px solid #f0f0f0',
    
    '&:last-child': {
      borderBottom: 'none',
    },
  },
  resultLink: {
    display: 'block',
    padding: '0.75rem 1rem',
    color: '#0066cc',
    textDecoration: 'none',
    transition: 'background-color 0.2s',
    
    '&:hover': {
      backgroundColor: '#f9f9f9',
    },
  },
  noResults: {
    position: 'absolute',
    top: '100%',
    left: 0,
    right: 0,
    backgroundColor: '#fff',
    border: '1px solid #ddd',
    borderTop: 'none',
    borderRadius: '0 0 4px 4px',
    padding: '1rem',
    textAlign: 'center',
    color: '#999',
    fontSize: '0.9rem',
  },
}
