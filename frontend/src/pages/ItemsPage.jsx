import { useEffect, useMemo, useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'
import { fetchAllItems, getOptimizedIconUrl } from '../api'
import CategoryTree from '../components/CategoryTree'
import OptimizedItemImage from '../components/OptimizedItemImage'
import { flattenCategoryTree, itemBelongsToCategory } from '../utils/category'
import { translateCategoryPath } from '../utils/categoryI18n'

const FALLBACK_ICON = 'http://localhost:8000/static/auction/media/no_item_icon.png'

function ItemsPage() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState('')
  const [items, setItems] = useState([])
  const [categoryTree, setCategoryTree] = useState([])
  const [selectedCategory, setSelectedCategory] = useState(searchParams.get('category')?.trim() || 'all')
  const [searchValue, setSearchValue] = useState('')

  useEffect(() => {
    const categoryFromUrl = searchParams.get('category')?.trim() || 'all'
    setSelectedCategory(categoryFromUrl)
  }, [searchParams])

  useEffect(() => {
    let isActive = true

    const run = async () => {
      setIsLoading(true)
      setError('')
      try {
        const data = await fetchAllItems()
        if (!isActive) return

        setItems(data.items || [])
        setCategoryTree(flattenCategoryTree(data.categories || []))
      } catch (loadError) {
        if (!isActive) return
        setError(loadError.message || 'Ошибка загрузки предметов')
      } finally {
        if (isActive) setIsLoading(false)
      }
    }

    run()
    return () => {
      isActive = false
    }
  }, [])

  const filteredItems = useMemo(() => {
    const query = searchValue.trim().toLowerCase()

    return items.filter((item) => {
      const categoryMatch = itemBelongsToCategory(item.category, selectedCategory)
      if (!categoryMatch) return false

      if (!query) return true

      return (
        item.name.toLowerCase().includes(query)
        || item.category.toLowerCase().includes(query)
        || item.item_id.toLowerCase().includes(query)
      )
    })
  }, [items, selectedCategory, searchValue])

  if (isLoading) {
    return <div className="text-center py-5 text-secondary">Загрузка предметов...</div>
  }

  if (error) {
    return <div className="alert alert-danger">{error}</div>
  }

  return (
    <div className="row g-4">
      <div className="col-12 col-lg-3 col-xl-2">
        <CategoryTree
          categories={categoryTree}
          selectedCategory={selectedCategory}
          onSelect={setSelectedCategory}
        />
      </div>

      <div className="col-12 col-lg-9 col-xl-10">
        <div className="glass-panel p-3 p-md-4">
          <div className="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
            <h4 className="mb-0">Предметы</h4>
            <span className="badge rounded-pill text-bg-dark border border-secondary-subtle">
              Найдено: {filteredItems.length}
            </span>
          </div>

          <div className="items-local-search">
            <div className="input-group input-group">
              <input
                className="form-control search-input"
                value={searchValue}
                onChange={(event) => setSearchValue(event.target.value)}
                placeholder="Поиск в текущей категории"
              />
              <button className="btn btn-accent" type="button">Поиск</button>
            </div>
            <div className="small text-secondary mt-2">
              Поиск выполняется только в выбранной категории и ее подкатегориях.
            </div>
          </div>

          <div className="items-grid mt-4">
            {filteredItems.map((item, index) => (
              <Link key={item.item_id} to={`/items/${item.item_id}`} className="item-card text-decoration-none">
                <div className="item-card-row">
                  <OptimizedItemImage
                    src={getOptimizedIconUrl(item.category, item.item_id, 56)}
                    alt={item.name}
                    fallbackSrc={FALLBACK_ICON}
                    frameClassName="item-icon-frame"
                    frameStyle={{ borderColor: item.color }}
                    imgClassName="item-icon"
                    loading={index < 8 ? 'eager' : 'lazy'}
                    fetchPriority={index < 4 ? 'high' : 'low'}
                  />
                  <div className="item-meta">
                    <div className="item-title">{item.name}</div>
                    <div className="item-subtitle">{translateCategoryPath(item.category)}</div>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}

export default ItemsPage
