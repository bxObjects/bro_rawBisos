import lunr from 'lunr'

// Flatten menu hierarchy into searchable documents
function flattenMenuData(items, documents = []) {
  for (let item of items) {
    documents.push({
      id: item.path,
      title: item.label,
      path: item.path,
      body: item.label,
    })
    
    if (item.children) {
      flattenMenuData(item.children, documents)
    }
  }
  
  return documents
}

// Build lunr index from menu data
export function buildSearchIndex(menuData) {
  const documents = flattenMenuData(menuData)
  
  const idx = lunr(function () {
    this.ref('id')
    this.field('title', { boost: 10 })
    this.field('body')
    
    documents.forEach((doc) => {
      this.add(doc)
    })
  })
  
  return {
    index: idx,
    documents: documents,
  }
}

// Search function
export function search(query, searchData) {
  if (!query || query.trim().length === 0) {
    return []
  }
  
  const results = searchData.index.search(query)
  
  return results.map((result) => {
    const doc = searchData.documents.find((d) => d.id === result.ref)
    return {
      ...doc,
      score: result.score,
    }
  })
}
