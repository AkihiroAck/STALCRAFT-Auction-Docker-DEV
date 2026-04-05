import { useEffect, useRef, useState } from 'react'
import { fetchItemSuggestions } from '../api'

function SearchBar({ value, onChange, onPickSuggestion }) {
  const [suggestions, setSuggestions] = useState([])
  const [showSuggestions, setShowSuggestions] = useState(false)
  const timerRef = useRef(null)

  useEffect(() => {
    clearTimeout(timerRef.current)

    timerRef.current = setTimeout(async () => {
      if (!value.trim()) {
        setSuggestions([])
        return
      }

      try {
        const data = await fetchItemSuggestions(value, 8)
        setSuggestions(data.items || [])
      } catch {
        setSuggestions([])
      }
    }, 220)

    return () => clearTimeout(timerRef.current)
  }, [value])

  return (
    <div className="search-box position-relative">
      <div className="input-group input-group-lg">
        <input
          className="form-control search-input"
          value={value}
          onChange={(event) => onChange(event.target.value)}
          onFocus={() => setShowSuggestions(true)}
          placeholder="Поиск по названию предмета"
        />
        <button className="btn btn-accent" type="button">Поиск</button>
      </div>

      {showSuggestions && suggestions.length > 0 && (
        <div className="search-dropdown">
          {suggestions.map((suggestion) => (
            <button
              key={suggestion.item_id}
              className="search-suggestion"
              type="button"
              onClick={() => {
                onPickSuggestion(suggestion)
                setShowSuggestions(false)
              }}
            >
              <div className="fw-semibold text-start">{suggestion.name}</div>
              <div className="small text-secondary text-start">{suggestion.category}</div>
            </button>
          ))}
        </div>
      )}
    </div>
  )
}

export default SearchBar
