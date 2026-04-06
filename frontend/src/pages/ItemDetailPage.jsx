import { useEffect, useMemo, useRef, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import {
  CategoryScale,
  Chart as ChartJS,
  Decimation,
  Legend,
  LinearScale,
  LineElement,
  PointElement,
  TimeScale,
  Tooltip,
} from 'chart.js'
import zoomPlugin from 'chartjs-plugin-zoom'
import 'chartjs-adapter-date-fns'
import { Line } from 'react-chartjs-2'
import { fetchItemDetail, fetchItemSales } from '../api'
import { translateCategorySegment } from '../utils/categoryI18n'

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, TimeScale, Tooltip, Legend, Decimation, zoomPlugin)

const QUALITY_LABELS = {
  0: 'Обычный',
  1: 'Необычный',
  2: 'Особый',
  3: 'Редкий',
  4: 'Исключительный',
  5: 'Легендарный',
  6: 'Уникальный',
}

const TZ_OPTIONS = [
  { value: 0, label: 'UTC+0' },
  { value: 3, label: 'UTC+3 (Москва)' },
  { value: 4, label: 'UTC+4 (Баку)' },
  { value: 5, label: 'UTC+5 (Алматы)' },
]

function wrapTooltipText(text, maxCharsPerLine = 46) {
  if (!text) return []

  const lines = []
  const paragraphs = String(text).split('\n')

  for (const paragraph of paragraphs) {
    const words = paragraph.trim().split(/\s+/).filter(Boolean)

    if (!words.length) {
      lines.push('')
      continue
    }

    let currentLine = ''

    for (const word of words) {
      if (!currentLine) {
        currentLine = word
        continue
      }

      const candidate = `${currentLine} ${word}`
      if (candidate.length <= maxCharsPerLine) {
        currentLine = candidate
      } else {
        lines.push(currentLine)
        currentLine = word
      }
    }

    if (currentLine) {
      lines.push(currentLine)
    }
  }

  return lines
}

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;')
}

function getOrCreateChartTooltip(chart) {
  const parent = chart.canvas.parentNode
  let tooltipEl = parent.querySelector('.chartjs-external-tooltip')

  if (!tooltipEl) {
    if (window.getComputedStyle(parent).position === 'static') {
      parent.style.position = 'relative'
    }

    tooltipEl = document.createElement('div')
    tooltipEl.className = 'chartjs-external-tooltip'
    tooltipEl.style.position = 'absolute'
    tooltipEl.style.pointerEvents = 'none'
    tooltipEl.style.background = '#0f1726'
    tooltipEl.style.border = '1px solid #2f3d52'
    tooltipEl.style.color = '#d2dae9'
    tooltipEl.style.padding = '10px 12px'
    tooltipEl.style.borderRadius = '8px'
    tooltipEl.style.fontSize = '12px'
    tooltipEl.style.maxWidth = '380px'
    tooltipEl.style.lineHeight = '1.35'
    tooltipEl.style.zIndex = '30'
    tooltipEl.style.boxShadow = '0 6px 22px rgba(0,0,0,0.35)'
    tooltipEl.style.whiteSpace = 'normal'
    parent.appendChild(tooltipEl)
  }

  return tooltipEl
}

function externalTooltipHandler(context) {
  const { chart, tooltip } = context
  const tooltipEl = getOrCreateChartTooltip(chart)

  if (!tooltip || tooltip.opacity === 0 || !tooltip.dataPoints?.length) {
    tooltipEl.style.opacity = '0'
    return
  }

  const point = tooltip.dataPoints[0].raw
  const lines = []
  const title = point.ptn !== undefined
    ? `${point.itemName || 'Предмет'} | +${point.ptn}`
    : (point.itemName || 'Предмет')

  lines.push(`<div style="margin-bottom:4px;"><strong>${escapeHtml(title)}</strong></div>`)

  if (point.qlt !== undefined) {
    const qualityColor = point.pointColor || '#9a9a9a'
    lines.push(
      `<div>Качество: <span style="display:inline-block;width:12px;height:12px;background:${escapeHtml(qualityColor)};border:1px solid #cfe0ff;border-radius:2px;vertical-align:middle;margin:0 6px 4px 4px;"></span>${escapeHtml(QUALITY_LABELS[point.qlt] || point.qlt)}</div>`,
    )
  }

  lines.push(`<div>Время: ${escapeHtml(new Date(point.x).toLocaleString('ru-RU'))}</div>`)
  lines.push(`<div>Цена: ${escapeHtml(Number(point.price).toLocaleString('ru-RU'))} руб.</div>`)
  lines.push('<hr style="border:0;border-top:1px solid #7f98bd;margin:6px 0;">')

  const serialized = JSON.stringify(point.extra_data || {}, null, 2)
  for (const line of wrapTooltipText(serialized, 46)) {
    lines.push(`<div>${escapeHtml(line || ' ')}</div>`)
  }

  tooltipEl.innerHTML = lines.join('')

  const canvas = chart.canvas
  const canvasWidth = canvas.clientWidth
  const canvasHeight = canvas.clientHeight
  const gap = 20

  const pointX = tooltip.caretX
  const pointY = tooltip.caretY

  let left = pointX + gap
  let top = pointY - 12

  const tooltipWidth = tooltipEl.offsetWidth
  const tooltipHeight = tooltipEl.offsetHeight

  // Позиционируем рядом с точкой без перекрытия точки.
  const candidates = [
    { left: pointX + gap, top: pointY - tooltipHeight - gap / 2 },
    { left: pointX - tooltipWidth - gap, top: pointY - tooltipHeight - gap / 2 },
    { left: pointX + gap, top: pointY + gap / 2 },
    { left: pointX - tooltipWidth - gap, top: pointY + gap / 2 },
  ]

  const fits = (pos) => (
    pos.left >= 8
    && pos.top >= 8
    && pos.left + tooltipWidth <= canvasWidth - 8
    && pos.top + tooltipHeight <= canvasHeight - 8
  )

  const chosen = candidates.find(fits)
  if (chosen) {
    left = chosen.left
    top = chosen.top
  } else {
    left = Math.min(Math.max(left, 8), canvasWidth - tooltipWidth - 8)
    top = Math.min(Math.max(top, 8), canvasHeight - tooltipHeight - 8)
  }

  tooltipEl.style.opacity = '1'
  tooltipEl.style.left = `${left}px`
  tooltipEl.style.top = `${top}px`
}

const FALLBACK_ICON = 'http://localhost:8000/static/auction/media/no_item_icon.png'

function getIconUrl(item) {
  return `https://github.com/EXBO-Studio/stalcraft-database/raw/main/ru/icons/${item.category}/${item.item_id}.png`
}

function parseOptionalNumber(value, { min = null, max = null } = {}) {
  const normalized = String(value ?? '').trim()
  if (normalized === '') return null

  const parsed = Number(normalized)
  if (!Number.isFinite(parsed)) return null

  let bounded = parsed
  if (min !== null) bounded = Math.max(min, bounded)
  if (max !== null) bounded = Math.min(max, bounded)

  return bounded
}

function sanitizeDigitsInput(value) {
  return String(value ?? '').replace(/\D+/g, '')
}

function normalizeDigitsValue(value, { min = null, max = null } = {}) {
  const parsed = parseOptionalNumber(sanitizeDigitsInput(value), { min, max })
  if (parsed === null) return ''
  return String(Math.trunc(parsed))
}

function ItemDetailPage() {
  const { itemId } = useParams()
  const chartRef = useRef(null)
  const itemChangePendingRef = useRef(false)

  const [item, setItem] = useState(null)
  const [limitInput, setLimitInput] = useState('100')
  const [appliedLimit, setAppliedLimit] = useState(100)
  const [limitReloadTick, setLimitReloadTick] = useState(0)
  const [maxLimit, setMaxLimit] = useState(2000)
  const [sales, setSales] = useState([])
  const [colors, setColors] = useState({})
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState('')

  const [timezone, setTimezone] = useState(3)
  const [minPrice, setMinPrice] = useState('')
  const [maxPrice, setMaxPrice] = useState('')
  const [minPtn, setMinPtn] = useState('')
  const [maxPtn, setMaxPtn] = useState('')
  const [quality, setQuality] = useState('-1')

  useEffect(() => {
    const saved = window.localStorage.getItem('chart_timezone')
    if (saved !== null) {
      setTimezone(Number(saved))
    }
  }, [])

  useEffect(() => {
    window.localStorage.setItem('chart_timezone', String(timezone))
  }, [timezone])

  useEffect(() => {
    itemChangePendingRef.current = true
    setLimitInput('100')
    setAppliedLimit(100)
  }, [itemId])

  useEffect(() => {
    if (itemChangePendingRef.current && appliedLimit !== 100) {
      return
    }

    itemChangePendingRef.current = false

    let isActive = true

    async function run() {
      setIsLoading(true)
      setError('')
      try {
        const [detail, salesData] = await Promise.all([
          fetchItemDetail(itemId),
          fetchItemSales(itemId, appliedLimit),
        ])

        if (!isActive) return

        setItem(detail.item)
        setMaxLimit(detail.max_limit)
        setSales(salesData.sales || [])
        setColors(salesData.colors || {})
        setLimitInput(String((salesData.sales || []).length))
      } catch (loadError) {
        if (!isActive) return
        setError(loadError.message || 'Ошибка загрузки')
      } finally {
        if (isActive) setIsLoading(false)
      }
    }

    run()
    return () => {
      isActive = false
    }
  }, [itemId, appliedLimit, limitReloadTick])

  const applyLimit = () => {
    const parsed = Number(limitInput)
    if (!Number.isFinite(parsed)) return

    const nextLimit = Math.min(maxLimit, Math.max(2, Math.floor(parsed)))
    if (nextLimit === appliedLimit) {
      setLimitReloadTick((value) => value + 1)
      return
    }

    setLimitInput(String(nextLimit))
    setAppliedLimit(nextLimit)
  }

  const applyPresetLimit = (value) => {
    const parsed = Number(value)
    if (!Number.isFinite(parsed)) return

    const nextLimit = Math.min(maxLimit, Math.max(2, Math.floor(parsed)))
    if (nextLimit === appliedLimit) {
      setLimitReloadTick((value) => value + 1)
      return
    }

    setLimitInput(String(nextLimit))
    setAppliedLimit(nextLimit)
  }

  const getDefaultLimitValue = () => {
    const parsedMaxLimit = Number(maxLimit)
    if (!Number.isFinite(parsedMaxLimit)) return 100
    return Math.max(2, Math.min(100, Math.floor(parsedMaxLimit)))
  }

  const resetLimitInputToDefault = () => {
    const defaultLimit = getDefaultLimitValue()
    setLimitInput(String(defaultLimit))
    setAppliedLimit(defaultLimit)
  }

  const clearAllFilters = () => {
    setMinPrice('')
    setMaxPrice('')
    setMinPtn('')
    setMaxPtn('')
    setQuality('-1')
  }

  const isArtefact = useMemo(() => item?.category?.split('/')[0] === 'artefact', [item])
  const categoryParts = useMemo(() => {
    if (!item?.category) return []
    return item.category.split('/').filter(Boolean)
  }, [item])
  const categoryCrumbs = useMemo(() => {
    return categoryParts.map((name, index) => ({
      name,
      path: categoryParts.slice(0, index + 1).join('/'),
    }))
  }, [categoryParts])

  const transformedSales = useMemo(() => {
    return (sales || [])
      .map((entry) => {
        const time = new Date(entry.time)
        const shiftedTs = time.getTime() + timezone * 60 * 60 * 1000
        const qlt = entry.extra_data?.qlt
        const ptn = entry.extra_data?.ptn

        return {
          x: shiftedTs,
          t: shiftedTs,
          y: Number(entry.price),
          price: Number(entry.price),
          qlt,
          ptn,
          extra_data: entry.extra_data || {},
          pointColor: qlt !== undefined ? Object.values(colors)[Math.min(qlt, 6)] : colors[entry.item__color],
          itemName: entry.item__name,
        }
      })
      .sort((a, b) => a.t - b.t)
  }, [sales, colors, timezone])

  const filteredSales = useMemo(() => {
    const min = parseOptionalNumber(minPrice, { min: 0 })
    const max = parseOptionalNumber(maxPrice, { min: 0 })

    return transformedSales.filter((entry) => {
      if (min !== null && entry.price < min) return false
      if (max !== null && entry.price > max) return false

      if (isArtefact) {
        const minArtifactPtn = parseOptionalNumber(minPtn, { min: 0, max: 15 })
        const maxArtifactPtn = parseOptionalNumber(maxPtn, { min: 0, max: 15 })
        const qltFilter = quality === '-1' ? null : Number(quality)

        if (minArtifactPtn !== null && (entry.ptn ?? -1) < minArtifactPtn) return false
        if (maxArtifactPtn !== null && (entry.ptn ?? -1) > maxArtifactPtn) return false
        if (qltFilter !== null && entry.qlt !== qltFilter) return false
      }

      return true
    })
  }, [transformedSales, minPrice, maxPrice, isArtefact, minPtn, maxPtn, quality])

  const chartData = useMemo(() => {
    return {
      datasets: [
        {
          label: 'Цена',
          data: filteredSales,
          borderColor: '#8f99a8',
          borderWidth: 1,
          pointRadius: 4,
          pointHitRadius: 12,
          pointHoverRadius: 6,
          tension: 0,
          fill: false,
          pointBackgroundColor: filteredSales.map((entry) => entry.pointColor || '#9a9a9a'),
          pointBorderColor: '#0f1624',
          parsing: false,
        },
      ],
    }
  }, [filteredSales])

  const xBounds = useMemo(() => {
    if (!filteredSales.length) {
      return { min: null, max: null, displayMin: null, displayMax: null }
    }

    let min = Number.POSITIVE_INFINITY
    let max = Number.NEGATIVE_INFINITY

    for (const point of filteredSales) {
      if (point.t < min) min = point.t
      if (point.t > max) max = point.t
    }

    const range = Math.max(1, max - min)
    const edgePadding = Math.max(60 * 1000, Math.floor(range * 0.012))

    return {
      min,
      max,
      displayMin: min - edgePadding,
      displayMax: max + edgePadding,
    }
  }, [filteredSales])

  const yBounds = useMemo(() => {
    if (!filteredSales.length) {
      return { min: null, max: null }
    }

    let min = Number.POSITIVE_INFINITY
    let max = Number.NEGATIVE_INFINITY

    for (const point of filteredSales) {
      if (point.y < min) min = point.y
      if (point.y > max) max = point.y
    }

    const range = Math.max(1, max - min)
    const padding = Math.max(1, range * 0.06)

    return {
      min: min - padding,
      max: max + padding,
    }
  }, [filteredSales])

  const chartOptions = useMemo(() => {
    const hasBounds = xBounds.min !== null && xBounds.max !== null
    const minRange = hasBounds ? Math.max(60 * 1000, Math.min((xBounds.max - xBounds.min) || 0, 1000 * 60 * 60)) : 1000 * 60 * 60

    return {
      maintainAspectRatio: false,
      normalized: true,
      animation: false,
      interaction: {
        mode: 'nearest',
        intersect: true,
      },
      plugins: {
        legend: { display: false },
        decimation: {
          enabled: true,
          algorithm: 'lttb',
          samples: 700,
        },
        tooltip: {
          enabled: false,
          external: externalTooltipHandler,
        },
        zoom: {
          limits: {
            x: {
              min: hasBounds ? xBounds.displayMin : undefined,
              max: hasBounds ? xBounds.displayMax : undefined,
              minRange,
            },
          },
          zoom: {
            wheel: { enabled: true },
            pinch: { enabled: true },
            mode: 'x',
          },
          pan: {
            enabled: true,
            mode: 'x',
          },
        },
      },
      scales: {
        x: {
          type: 'time',
          min: hasBounds ? xBounds.displayMin : undefined,
          max: hasBounds ? xBounds.displayMax : undefined,
          offset: false,
          time: {
            displayFormats: {
              day: 'dd.MM.yyyy',
            },
          },
          grid: { color: '#243143' },
          ticks: {
            color: '#9fb0c7',
            autoSkip: false,
            maxTicksLimit: 8,
            callback(value, index, ticks) {
              const tickValue = ticks?.[index]?.value ?? value
              const date = new Date(tickValue)
              return date.toLocaleDateString('ru-RU', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
              })
            },
          },
        },
        y: {
          min: yBounds.min !== null ? yBounds.min : undefined,
          max: yBounds.max !== null ? yBounds.max : undefined,
          grid: { color: '#243143' },
          ticks: {
            color: '#9fb0c7',
            callback(value) {
              return Number(value).toLocaleString('ru-RU')
            },
          },
        },
      },
    }
  }, [xBounds, yBounds])

  if (isLoading) {
    return <div className="text-secondary text-center py-5">Загрузка...</div>
  }

  if (error) {
    return <div className="alert alert-danger">{error}</div>
  }

  return (
    <div className="glass-panel p-3 p-md-4">
      <div className="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-3">
        <div>
          <div className="small text-secondary mb-2">
            <Link to="/items" className="text-secondary text-decoration-none">Список предметов</Link>
            {categoryCrumbs.map((crumb) => (
              <span key={crumb.path}>
                {' < '}
                <Link
                  to={`/items?category=${encodeURIComponent(crumb.path)}`}
                  className="text-secondary text-decoration-none"
                >
                  {translateCategorySegment(crumb.name, crumb.path)}
                </Link>
              </span>
            ))}
            {item?.name ? ` < ${item.name}` : ''}
          </div>
          <div className="d-flex align-items-center gap-2">
            <div className="item-icon-frame item-detail-icon-frame" style={{ borderColor: item.color }}>
              <img
                src={getIconUrl(item)}
                alt={item.name}
                className="item-icon item-detail-icon"
                loading="lazy"
                onError={(event) => {
                  event.currentTarget.onerror = null
                  event.currentTarget.src = FALLBACK_ICON
                }}
              />
            </div>
            <div>
              <h3 className="mb-0">{item.name}</h3>
              <div className="small text-secondary">Класс: {translateCategorySegment(categoryParts[categoryParts.length - 1] || '', item.category) || item.category}</div>
            </div>
          </div>
        </div>

        <div className="d-flex flex-nowrap align-items-center gap-2">
          <label className="small text-secondary text-nowrap mb-0">Часовой пояс:</label>
          <select
            className="form-select form-select-sm"
            value={timezone}
            onChange={(event) => setTimezone(Number(event.target.value))}
          >
            {TZ_OPTIONS.map((option) => (
              <option key={option.value} value={option.value}>{option.label}</option>
            ))}
          </select>
        </div>
      </div>

      <div className="row g-2 align-items-stretch mb-2 flex-xl-nowrap">
        <div className="col-16 col-xl">
          <div className="border border-secondary-subtle rounded-3 p-3">
            <div className="small text-secondary mb-1">Количество отображаемых записей в истории продаж:</div>
            <div className="row g-1 align-items-end">
              <div className="col-12 col-md-4 col-lg-2">
                <div className="input-group input-group-sm">
                  <input
                    className="form-control"
                    type="number"
                    min={2}
                    max={maxLimit}
                    step="1"
                    inputMode="numeric"
                    pattern="[0-9]*"
                    value={limitInput}
                    onChange={(event) => setLimitInput(sanitizeDigitsInput(event.target.value))}
                    onBlur={() => {
                      const normalized = normalizeDigitsValue(limitInput, { min: 2, max: maxLimit })
                      if (normalized === '') {
                        setLimitInput(String(getDefaultLimitValue()))
                        return
                      }

                      setLimitInput(normalized)
                    }}
                    onKeyDown={(event) => {
                      if (event.key === 'Enter') {
                        event.preventDefault()
                        applyLimit()
                      }
                    }}
                  />
                  <button type="button" className="btn btn-outline-secondary" onClick={resetLimitInputToDefault}>x</button>
                </div>
              </div>
              <div className="col-12 col-md-3 col-lg-2">
                <button type="button" className="btn btn-accent btn-sm w-100 d-flex align-items-center justify-content-center" onClick={applyLimit}>Применить</button>
              </div>
              <div className="col-6 col-md-2 col-lg-2">
                <button
                  type="button"
                  className="btn btn-outline-light btn-sm w-100"
                  onClick={() => applyPresetLimit(100)}
                >
                  100 шт.
                </button>
              </div>
              <div className="col-6 col-md-2 col-lg-2">
                <button
                  type="button"
                  className="btn btn-outline-light btn-sm w-100"
                  onClick={() => applyPresetLimit(200)}
                >
                  200 шт.
                </button>
              </div>
              <div className="col-6 col-md-2 col-lg-2">
                <button
                  type="button"
                  className="btn btn-outline-light btn-sm w-100"
                  onClick={() => applyPresetLimit(1000)}
                >
                  1000 шт.
                </button>
              </div>
              <div className="col-6 col-md-2 col-lg-2">
                <button
                  type="button"
                  className="btn btn-outline-light btn-sm w-100"
                  onClick={() => applyPresetLimit(maxLimit)}
                >
                  {maxLimit} шт.
                </button>
              </div>
            </div>
          </div>
        </div>
        <div className="col-12 col-xl">
          <div className="border border-secondary-subtle rounded-3 p-3 h-100">
            <div className="small text-secondary mb-1">Фильтры записей:</div>
            <div className="row g-1">
              <div className="col-6 col-lg-2">
                <div className="input-group input-group-sm">
                  <input
                    className="form-control"
                    type="number"
                    min={0}
                    step="1"
                    inputMode="numeric"
                    pattern="[0-9]*"
                    placeholder="Цена от"
                    value={minPrice}
                    onChange={(event) => setMinPrice(sanitizeDigitsInput(event.target.value))}
                    onBlur={() => setMinPrice(normalizeDigitsValue(minPrice, { min: 0 }))}
                  />
                  <button type="button" className="btn btn-outline-secondary" onClick={() => setMinPrice('')}>x</button>
                </div>
              </div>
              <div className="col-6 col-lg-2">
                <div className="input-group input-group-sm">
                  <input
                    className="form-control"
                    type="number"
                    min={0}
                    step="1"
                    inputMode="numeric"
                    pattern="[0-9]*"
                    placeholder="Цена до"
                    value={maxPrice}
                    onChange={(event) => setMaxPrice(sanitizeDigitsInput(event.target.value))}
                    onBlur={() => setMaxPrice(normalizeDigitsValue(maxPrice, { min: 0 }))}
                  />
                  <button type="button" className="btn btn-outline-secondary" onClick={() => setMaxPrice('')}>x</button>
                </div>
              </div>

              {isArtefact && (
                <>
                  <div className="col-6 col-lg-2">
                    <div className="input-group input-group-sm">
                      <input
                        className="form-control"
                        type="number"
                        min={0}
                        max={15}
                        step="1"
                        inputMode="numeric"
                        pattern="[0-9]*"
                        placeholder="Урв. от"
                        value={minPtn}
                        onChange={(event) => setMinPtn(sanitizeDigitsInput(event.target.value))}
                        onBlur={() => setMinPtn(normalizeDigitsValue(minPtn, { min: 0, max: 15 }))}
                      />
                      <button type="button" className="btn btn-outline-secondary" onClick={() => setMinPtn('')}>x</button>
                    </div>
                  </div>
                  <div className="col-6 col-lg-2">
                    <div className="input-group input-group-sm">
                      <input
                        className="form-control"
                        type="number"
                        min={0}
                        max={15}
                        step="1"
                        inputMode="numeric"
                        pattern="[0-9]*"
                        placeholder="Урв. до"
                        value={maxPtn}
                        onChange={(event) => setMaxPtn(sanitizeDigitsInput(event.target.value))}
                        onBlur={() => setMaxPtn(normalizeDigitsValue(maxPtn, { min: 0, max: 15 }))}
                      />
                      <button type="button" className="btn btn-outline-secondary" onClick={() => setMaxPtn('')}>x</button>
                    </div>
                  </div>
                  <div className="col-12 col-lg">
                    <div className="input-group input-group-sm">
                      <select className="form-select quality-filter-select" value={quality} onChange={(event) => setQuality(event.target.value)}>
                        <option value="-1">Качество: любое</option>
                        {Object.entries(QUALITY_LABELS).map(([key, value]) => (
                          <option value={key} key={key}>{value}</option>
                        ))}
                      </select>
                      <button type="button" className="btn btn-outline-secondary" onClick={() => setQuality('-1')}>x</button>
                    </div>
                  </div>
                  <div className="col-12 col-lg-auto">
                    <button
                      type="button"
                      className="btn btn-outline-danger btn-sm w-100"
                      title="Очистить все фильтры"
                      onClick={clearAllFilters}
                    >
                      x
                    </button>
                  </div>
                </>
              )}
            </div>
          </div>
        </div>
        <div className="col-12 col-xl-auto ms-xl-3">
          <div className="border border-warning-subtle rounded-3 p-3 d-inline-flex flex-column">
            <div className="small text-secondary mb-1">Управление графиком</div>
            <button
              type="button"
              className="btn btn-outline-warning btn-sm"
              onClick={() => chartRef.current?.resetZoom()}
            >
              Сбросить зум
            </button>
          </div>
        </div>
      </div>

      <div className="chart-wrap">
        {filteredSales.length === 0 ? (
          <div className="text-center text-secondary py-5">Нет данных, соответствующих фильтрам</div>
        ) : (
          <Line ref={chartRef} data={chartData} options={chartOptions} />
        )}
      </div>
    </div>
  )
}

export default ItemDetailPage
