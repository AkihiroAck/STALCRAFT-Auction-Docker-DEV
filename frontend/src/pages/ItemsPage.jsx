import { useEffect, useMemo, useRef, useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'
import {
  Circle,  // иконка по умолчанию для категорий без сопоставленной иконки

  CircleStar,
  Shield,
  Crosshair,
  Wrench,
  Backpack,
  Archive,
  Boxes,
  BottleWine,
  Utensils,
  Bomb,
  BriefcaseMedical,
  SquareAsterisk,
  Package,
  Infinity,

  List,  // для блока "Все предметы"
  Scale,  // для индикатора наличия продаж (аукцион)
} from 'lucide-react'
import { fetchAllItems, getOptimizedIconUrl } from '../api'
import OptimizedItemImage from '../components/OptimizedItemImage'
import { flattenCategoryTree, itemBelongsToCategory } from '../utils/category'
import { translateCategorySegment } from '../utils/categoryI18n'

const FALLBACK_ICON = 'http://localhost:8000/static/auction/media/no_item_icon.png'
const RARITY_ORDER = {
  RANK_LEGEND: 7,
  RANK_UNIQUE: 6,
  RANK_MASTER: 5,
  RANK_VETERAN: 4,
  RANK_STALKER: 3,
  RANK_NEWBIE: 2,
  DEFAULT: 1,
  QUEST_ITEM: 0,
}

const CATEGORY_ICON_MAP = {
  artefact: CircleStar,
  armor: Shield,
  weapon: Crosshair,
  attachment: Wrench,
  backpacks: Backpack,
  containers: Archive,
  bullet: Boxes,
  drink: BottleWine,
  food: Utensils,
  grenade: Bomb,
  medicine: BriefcaseMedical,
  weapon_modules: SquareAsterisk,
  misc: Package,
  other: Infinity,
}

function renderCategoryIcon(categoryName) {
  const IconComponent = CATEGORY_ICON_MAP[categoryName] || Circle
  return <IconComponent size={18} strokeWidth={2} aria-hidden="true" />
}

function ItemsPage() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState('')
  const [items, setItems] = useState([])
  const [categoryTree, setCategoryTree] = useState([])
  const [selectedCategory, setSelectedCategory] = useState(searchParams.get('category')?.trim() || 'all')
  const [selectedClass, setSelectedClass] = useState('all')
  const [showAllItemsList, setShowAllItemsList] = useState(false)
  const [mainCategoryFilter, setMainCategoryFilter] = useState('all')
  const [mainSubcategoryFilter, setMainSubcategoryFilter] = useState('all')
  const [searchValue, setSearchValue] = useState('')
  const previousTopCategoryRef = useRef('all')

  useEffect(() => {
    const rawCategory = searchParams.get('category')?.trim() || 'all'
    const categoryParts = rawCategory.split('/').filter(Boolean)
    const nextTopCategory = categoryParts[0] || 'all'

    if (previousTopCategoryRef.current !== nextTopCategory) {
      setSearchValue('')
    }
    previousTopCategoryRef.current = nextTopCategory

    if (!categoryParts.length || rawCategory === 'all') {
      setSelectedCategory('all')
      setSelectedClass('all')
    } else if (categoryParts.length === 1) {
      setSelectedCategory(categoryParts[0])
      setSelectedClass('all')
    } else {
      setSelectedCategory(categoryParts[0])
      setSelectedClass(categoryParts[1])
    }

    setShowAllItemsList(false)
    setMainCategoryFilter('all')
    setMainSubcategoryFilter('all')
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

  const topLevelCategories = useMemo(
    () => categoryTree.filter((category) => category.depth === 0),
    [categoryTree]
  )

  const showCategoryBlocks = selectedCategory === 'all' && !showAllItemsList

  const categoryItems = useMemo(() => {
    return items.filter((item) => itemBelongsToCategory(item.category, selectedCategory))
  }, [items, selectedCategory])

  const categoryClassOptions = useMemo(() => {
    if (selectedCategory === 'all') return []

    const nextSegments = new Set()
    for (const item of categoryItems) {
      const remainder = item.category.startsWith(`${selectedCategory}/`)
        ? item.category.slice(selectedCategory.length + 1)
        : ''
      const nextSegment = remainder.split('/').filter(Boolean)[0]
      if (nextSegment) nextSegments.add(nextSegment)
    }

    return Array.from(nextSegments).sort((a, b) => a.localeCompare(b, 'ru'))
  }, [categoryItems, selectedCategory])

  const classScopedItems = useMemo(() => {
    if (selectedCategory === 'all' || selectedClass === 'all') return categoryItems

    return categoryItems.filter((item) => {
      if (!item.category.startsWith(`${selectedCategory}/`)) return false
      const remainder = item.category.slice(selectedCategory.length + 1)
      const nextSegment = remainder.split('/').filter(Boolean)[0]
      return nextSegment === selectedClass
    })
  }, [categoryItems, selectedCategory, selectedClass])

  const mainSubcategoryOptions = useMemo(() => {
    if (mainCategoryFilter === 'all') return []

    const options = new Set()
    for (const item of items) {
      const parts = item.category.split('/').filter(Boolean)
      if (parts[0] !== mainCategoryFilter) continue
      if (parts[1]) options.add(parts[1])
    }

    return Array.from(options).sort((a, b) => a.localeCompare(b, 'ru'))
  }, [items, mainCategoryFilter])

  const mainScopedItems = useMemo(() => {
    return items.filter((item) => {
      const parts = item.category.split('/').filter(Boolean)
      if (mainCategoryFilter !== 'all' && parts[0] !== mainCategoryFilter) return false
      if (mainSubcategoryFilter !== 'all' && parts[1] !== mainSubcategoryFilter) return false
      return true
    })
  }, [items, mainCategoryFilter, mainSubcategoryFilter])

  const handleSelectCategory = (categoryPath) => {
    if (!categoryPath || categoryPath === 'all') {
      navigate('/items?category=all')
      return
    }

    navigate(`/items?category=${encodeURIComponent(categoryPath)}`)
  }

  const handleOpenAllItemsList = () => {
    setShowAllItemsList(true)
    setMainCategoryFilter('all')
    setMainSubcategoryFilter('all')
  }

  const filteredItems = useMemo(() => {
    const query = searchValue.trim().toLowerCase()

    const sourceItems = selectedCategory === 'all' ? mainScopedItems : classScopedItems

    const nextItems = sourceItems.filter((item) => {
      if (!query) return true

      return (
        item.name.toLowerCase().includes(query)
        || item.category.toLowerCase().includes(query)
        || item.item_id.toLowerCase().includes(query)
      )
    })

    nextItems.sort((a, b) => {
      const rarityA = RARITY_ORDER[a.rank] ?? -1
      const rarityB = RARITY_ORDER[b.rank] ?? -1
      if (rarityA !== rarityB) return rarityB - rarityA
      return a.name.localeCompare(b.name, 'ru')
    })

    return nextItems
  }, [classScopedItems, mainScopedItems, searchValue, selectedCategory])

  const isAllItemsMode = !showCategoryBlocks && selectedCategory === 'all'

  if (isLoading) {
    return <div className="text-center py-5 text-secondary">Загрузка предметов...</div>
  }

  if (error) {
    return <div className="alert alert-danger">{error}</div>
  }

  return (
    <div className={`glass-panel p-3 p-md-4 ${!showCategoryBlocks ? 'items-page-fixed' : ''}`}>
      <div className="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
        <h4 className="mb-0">Список предметов</h4>
        <span className="badge rounded-pill text-bg-dark border border-secondary-subtle">
          {showCategoryBlocks ? `Категорий: ${topLevelCategories.length}` : `Найдено: ${filteredItems.length}`}
        </span>
      </div>

      {!showCategoryBlocks && selectedCategory !== 'all' && (
        <div className="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
          <div className="small text-secondary category-breadcrumb">
            <button type="button" className="btn btn-link p-0 text-secondary text-decoration-none" onClick={() => handleSelectCategory('all')}>
              Список предметов
            </button>
            {' > '}
            <span>{translateCategorySegment(selectedCategory.split('/').at(-1) || '', selectedCategory)}</span>
          </div>
        </div>
      )}

      {!showCategoryBlocks && selectedCategory === 'all' && (
        <div className="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2">
          <div className="small text-secondary category-breadcrumb">
            <button type="button" className="btn btn-link p-0 text-secondary text-decoration-none" onClick={() => {
              setShowAllItemsList(false)
              setMainCategoryFilter('all')
              setMainSubcategoryFilter('all')
            }}>
              Список предметов
            </button>
            {' > '}
            <span>Все предметы</span>
          </div>
        </div>
      )}

      {isAllItemsMode && (
        <div className="items-local-search mb-3">
          <div className="input-group input-group">
            <input
              className="form-control search-input"
              value={searchValue}
              onChange={(event) => setSearchValue(event.target.value)}
              placeholder="Поиск по всем предметам"
            />
            <button
              className="btn btn-outline-secondary"
              type="button"
              onClick={() => setSearchValue('')}
              disabled={!searchValue}
              title="Очистить поиск"
              aria-label="Очистить поиск"
            >
              Очистить
            </button>
            <button className="btn btn-accent" type="button">Поиск</button>
          </div>
        </div>
      )}

      {isAllItemsMode && (
        <div className="class-filter-panel mb-3">
          <div className="class-filter-title">Фильтр по категориям и подкатегориям</div>
          <div className="class-filter-chips">
            <button
              type="button"
              className={`class-filter-chip ${mainCategoryFilter === 'all' ? 'active' : ''}`}
              onClick={() => {
                setMainCategoryFilter('all')
                setMainSubcategoryFilter('all')
              }}
            >
              Все категории
            </button>
            {topLevelCategories.map((category) => (
              <button
                key={category.id}
                type="button"
                className={`class-filter-chip ${mainCategoryFilter === category.name ? 'active' : ''}`}
                onClick={() => {
                  setMainCategoryFilter(category.name)
                  setMainSubcategoryFilter('all')
                  setSearchValue('')
                }}
                title={translateCategorySegment(category.name, category.fullPath)}
              >
                {translateCategorySegment(category.name, category.fullPath)}
              </button>
            ))}
          </div>

          {mainCategoryFilter !== 'all' && (
            <div className="class-filter-chips mt-2">
              <button
                type="button"
                className={`class-filter-chip ${mainSubcategoryFilter === 'all' ? 'active' : ''}`}
                onClick={() => setMainSubcategoryFilter('all')}
              >
                Все подкатегории
              </button>
              {mainSubcategoryOptions.map((subName) => {
                const fullPath = `${mainCategoryFilter}/${subName}`
                return (
                  <button
                    key={subName}
                    type="button"
                    className={`class-filter-chip ${mainSubcategoryFilter === subName ? 'active' : ''}`}
                    onClick={() => setMainSubcategoryFilter(subName)}
                    title={translateCategorySegment(subName, fullPath)}
                  >
                    {translateCategorySegment(subName, fullPath)}
                  </button>
                )
              })}
            </div>
          )}
        </div>
      )}

      {!isAllItemsMode && !showCategoryBlocks && (
        <div className="items-local-search">
          <div className="input-group input-group">
            <input
              className="form-control search-input"
              value={searchValue}
              onChange={(event) => setSearchValue(event.target.value)}
              placeholder={showCategoryBlocks ? 'Поиск по всем предметам' : 'Поиск в текущей категории'}
            />
            <button
              className="btn btn-outline-secondary"
              type="button"
              onClick={() => setSearchValue('')}
              disabled={!searchValue}
              title="Очистить поиск"
              aria-label="Очистить поиск"
            >
              Очистить
            </button>
            <button className="btn btn-accent" type="button">Поиск</button>
          </div>
        </div>
      )}

      {showCategoryBlocks ? (
        <div className="category-block-grid mt-4">
          <button
            type="button"
            className="category-block-card category-block-card-primary"
            onClick={handleOpenAllItemsList}
          >
            <span className="category-block-icon" aria-hidden="true"><List size={18} strokeWidth={2} /></span>
            <span className="category-block-content">
              <span className="category-block-title">Все предметы</span>
              <span className="category-block-count">Полный список с фильтрами</span>
            </span>
          </button>

          {topLevelCategories.map((category) => (
            <button
              key={category.id}
              type="button"
              className="category-block-card"
              onClick={() => handleSelectCategory(category.fullPath)}
            >
              <span className="category-block-icon" aria-hidden="true">{renderCategoryIcon(category.name)}</span>
              <span className="category-block-content">
                <span className="category-block-title">{translateCategorySegment(category.name, category.fullPath)}</span>
                <span className="category-block-count">{category.count} предметов</span>
              </span>
            </button>
          ))}
        </div>
      ) : (
        <div className="mt-3 d-flex flex-column gap-3 items-content-stack">
          {selectedCategory !== 'all' && (
            <div className="class-filter-panel">
              <div className="class-filter-title">Фильтр по классу</div>
              <div className="class-filter-chips">
                <button
                  type="button"
                  className={`class-filter-chip ${selectedClass === 'all' ? 'active' : ''}`}
                  onClick={() => setSelectedClass('all')}
                >
                  Все
                </button>
                {categoryClassOptions.map((className) => {
                  const fullClassPath = `${selectedCategory}/${className}`
                  return (
                    <button
                      key={className}
                      type="button"
                      className={`class-filter-chip ${selectedClass === className ? 'active' : ''}`}
                      onClick={() => setSelectedClass(className)}
                      title={translateCategorySegment(className, fullClassPath)}
                    >
                      {translateCategorySegment(className, fullClassPath)}
                    </button>
                  )
                })}
              </div>
            </div>
          )}

          <div className="items-scroll-panel">
            <div className="items-grid items-grid-category">
              {filteredItems.map((item, index) => (
                <Link key={item.item_id} to={`/items/${item.item_id}`} className="item-card text-decoration-none">
                  {item.has_sales ? (
                    <span className="item-sales-indicator" title="Есть записи продаж" aria-label="Есть записи продаж">
                      <Scale size={12} strokeWidth={2} aria-hidden="true" />
                    </span>
                  ) : null}
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
                      <div className="item-subtitle">
                        {translateCategorySegment(item.category.split('/').filter(Boolean).at(-1) || '', item.category)}
                      </div>
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default ItemsPage
