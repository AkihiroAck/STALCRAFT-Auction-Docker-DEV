import { useEffect, useState } from 'react'
import { Route, Routes, useNavigate } from 'react-router-dom'
import ItemsPage from './pages/ItemsPage'
import ItemDetailPage from './pages/ItemDetailPage'
import UploadLangPage from './pages/UploadLangPage'
import AppLayout from './components/AppLayout'
import AdminPage from './pages/AdminPage'
import AdminCeleryTasksPage from './pages/AdminCeleryTasksPage'
import AdminCelerySchedulerPage from './pages/AdminCelerySchedulerPage'
import { authLogout, authMe } from './api'

const ADMIN_AUTH_FLAG_KEY = 'admin-authenticated'

function App() {
  const navigate = useNavigate()
  const [isAdminAuthenticated, setIsAdminAuthenticated] = useState(() => {
    if (typeof window === 'undefined') return false
    return window.sessionStorage.getItem(ADMIN_AUTH_FLAG_KEY) === '1'
  })

  useEffect(() => {
    let isActive = true

    async function refreshAdminAuth() {
      try {
        const me = await authMe()
        if (!isActive) return
        const authenticated = Boolean(me?.authenticated && me?.is_staff)
        setIsAdminAuthenticated(authenticated)
        if (authenticated) {
          window.sessionStorage.setItem(ADMIN_AUTH_FLAG_KEY, '1')
        } else {
          window.sessionStorage.removeItem(ADMIN_AUTH_FLAG_KEY)
        }
      } catch {
        if (!isActive) return
        setIsAdminAuthenticated(window.sessionStorage.getItem(ADMIN_AUTH_FLAG_KEY) === '1')
      }
    }

    const handleAuthChanged = () => {
      refreshAdminAuth()
    }

    refreshAdminAuth()
    window.addEventListener('admin-auth-changed', handleAuthChanged)

    return () => {
      isActive = false
      window.removeEventListener('admin-auth-changed', handleAuthChanged)
    }
  }, [])

  const handleAdminLogin = () => {
    navigate('/control-center')
  }

  const handleAdminCenter = () => {
    navigate('/control-center')
  }

  const handleAdminLogout = async () => {
    try {
      await authLogout()
    } finally {
      setIsAdminAuthenticated(false)
      window.sessionStorage.removeItem(ADMIN_AUTH_FLAG_KEY)
      window.dispatchEvent(new CustomEvent('admin-auth-changed', { detail: { authenticated: false } }))
      navigate('/')
    }
  }

  return (
    <AppLayout
      isAdminAuthenticated={isAdminAuthenticated}
      onAdminLogin={handleAdminLogin}
      onAdminCenter={handleAdminCenter}
      onAdminLogout={handleAdminLogout}
    >
        <Routes>
          <Route path="/" element={<ItemsPage />} />
          <Route path="/items" element={<ItemsPage />} />
          <Route path="/items/:itemId" element={<ItemDetailPage />} />
          <Route path="/upload-lang" element={<UploadLangPage />} />
          <Route path="/control-center" element={<AdminPage />} />
          <Route path="/control-center/celery-tasks" element={<AdminCeleryTasksPage />} />
          <Route path="/control-center/celery-scheduler" element={<AdminCelerySchedulerPage />} />
        </Routes>
    </AppLayout>
  )
}

export default App
