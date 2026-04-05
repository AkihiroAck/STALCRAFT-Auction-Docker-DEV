import { useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { fetchItemSuggestions, getOptimizedIconUrl } from '../api'
import OptimizedItemImage from './OptimizedItemImage'

const FALLBACK_ICON = 'http://localhost:8000/static/auction/media/no_item_icon.png'

function getIconUrl(item) {
  return getOptimizedIconUrl(item.category, item.item_id, 40)
}

function GlobalSearchBar() {
  const navigate = useNavigate()
  const [query, setQuery] = useState('')
  const [suggestions, setSuggestions] = useState([])
  const [showSuggestions, setShowSuggestions] = useState(false)
  const timerRef = useRef(null)

  useEffect(() => {
    clearTimeout(timerRef.current)

    timerRef.current = setTimeout(async () => {
      if (!query.trim()) {
        setSuggestions([])
        return
      }

      try {
        const data = await fetchItemSuggestions(query, 8)
        setSuggestions(data.items || [])
      } catch {
        setSuggestions([])
      }
    }, 220)

    return () => clearTimeout(timerRef.current)
  }, [query])

  const handleSubmit = (event) => {
    event.preventDefault()
    if (!suggestions.length) return
    navigate(`/items/${suggestions[0].item_id}`)
    setShowSuggestions(false)
  }

  return (
    <div className="global-search position-relative">
      <form className="input-group input-group-sm" onSubmit={handleSubmit}>
        <input
          className="form-control search-input"
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          onFocus={() => setShowSuggestions(true)}
          onBlur={() => setTimeout(() => setShowSuggestions(false), 120)}
          placeholder="Глобальный поиск предмета"
        />
        <button className="btn btn-accent" type="submit">Найти</button>
      </form>

      {showSuggestions && suggestions.length > 0 && (
        <div className="search-dropdown">
          {suggestions.map((suggestion) => (
            <button
              key={suggestion.item_id}
              className="search-suggestion"
              type="button"
              onMouseDown={() => {
                navigate(`/items/${suggestion.item_id}`)
                setShowSuggestions(false)
              }}
            >
              <div className="search-suggestion-main">
                <OptimizedItemImage
                  src={getIconUrl(suggestion)}
                  alt={suggestion.name}
                  fallbackSrc={FALLBACK_ICON}
                  frameClassName="item-icon-frame search-icon-frame"
                  imgClassName="item-icon"
                  loading="eager"
                  fetchPriority="high"
                />
                <div className="fw-semibold text-start search-suggestion-name">{suggestion.name}</div>
              </div>
            </button>
          ))}
        </div>
      )}
    </div>
  )
}

export default GlobalSearchBar