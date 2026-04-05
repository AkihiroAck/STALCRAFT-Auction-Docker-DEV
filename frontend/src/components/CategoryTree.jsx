import { translateCategorySegment } from '../utils/categoryI18n'

function CategoryTree({ categories, selectedCategory, onSelect }) {
  return (
    <aside className="glass-panel category-panel p-3">
      <h6 className="panel-title mb-3">Категории</h6>
      <div className="category-list">
        <button
          type="button"
          className={`category-item ${selectedCategory === 'all' ? 'active' : ''}`}
          onClick={() => onSelect('all')}
        >
          <span>Все</span>
        </button>

        {categories.map((category) => (
          <button
            key={category.id}
            type="button"
            className={`category-item ${selectedCategory === category.fullPath ? 'active' : ''}`}
            style={{ paddingLeft: `${10 + category.depth * 14}px` }}
            onClick={() => onSelect(category.fullPath)}
          >
            <span>{translateCategorySegment(category.name)}</span>
            <span className="badge bg-secondary-subtle text-light-emphasis ms-2">{category.count}</span>
          </button>
        ))}
      </div>
    </aside>
  )
}

export default CategoryTree
