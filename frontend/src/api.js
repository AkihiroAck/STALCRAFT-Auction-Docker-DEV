const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/auction/api'
const BACKEND_BASE = API_BASE.replace(/\/api\/?$/, '')

function encodeCategoryPath(category) {
  return String(category || '')
    .split('/')
    .map((part) => encodeURIComponent(part))
    .join('/')
}

async function request(path, options = {}) {
  const response = await fetch(`${API_BASE}${path}`, {
    credentials: 'include',
    ...options,
  })

  if (!response.ok) {
    const text = await response.text()
    throw new Error(text || `Request failed with status ${response.status}`)
  }

  const contentType = response.headers.get('content-type') || ''
  if (contentType.includes('application/json')) {
    return response.json()
  }

  return response.blob()
}

export async function fetchAllItems() {
  return request('/items/all/')
}

export async function fetchItemSuggestions(query, limit = 8) {
  if (!query.trim()) return { items: [] }
  return request(`/items/suggest/?q=${encodeURIComponent(query)}&limit=${limit}`)
}

export function getOptimizedIconUrl(category, itemId, size = 56) {
  return `${BACKEND_BASE}/api/icons/${encodeCategoryPath(category)}/${encodeURIComponent(itemId)}/?size=${size}`
}

export async function fetchItemDetail(itemId) {
  return request(`/items/${encodeURIComponent(itemId)}/`)
}

export async function fetchItemSales(itemId, limit = 100) {
  return request(`/items/${encodeURIComponent(itemId)}/sales/?limit=${limit}`)
}

export async function processLangFile(file, months) {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('months', months)

  const blob = await request('/process-lang/', {
    method: 'POST',
    body: formData,
  })

  return blob
}

export async function authMe() {
  return request('/auth/me/')
}

export async function authLogin(username, password) {
  return request('/auth/login/', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password }),
  })
}

export async function authLogout() {
  return request('/auth/logout/', {
    method: 'POST',
  })
}

export async function fetchCeleryOverview() {
  return request('/admin/celery/overview/')
}

export async function fetchCeleryLogs(source = 'app', lines = 250) {
  return request(`/admin/celery/logs/?source=${encodeURIComponent(source)}&lines=${lines}`)
}

export async function startCeleryTask(taskName, args = [], kwargs = {}) {
  return request('/admin/celery/tasks/start/', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ task_name: taskName, args, kwargs }),
  })
}

export async function stopCeleryTask(taskId, terminate = true, signal = 'SIGTERM') {
  return request('/admin/celery/tasks/stop/', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ task_id: taskId, terminate, signal }),
  })
}
