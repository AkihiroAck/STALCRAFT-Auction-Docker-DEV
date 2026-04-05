export function flattenCategoryTree(tree, prefix = '') {
  const result = []

  for (const node of tree) {
    const fullPath = prefix ? `${prefix}/${node.name}` : node.name
    result.push({
      id: fullPath,
      name: node.name,
      fullPath,
      count: node.count,
      depth: fullPath.split('/').length - 1,
    })

    result.push(...flattenCategoryTree(node.children || [], fullPath))
  }

  return result
}

export function itemBelongsToCategory(itemCategory, selectedCategory) {
  if (!selectedCategory || selectedCategory === 'all') return true
  return itemCategory === selectedCategory || itemCategory.startsWith(`${selectedCategory}/`)
}
