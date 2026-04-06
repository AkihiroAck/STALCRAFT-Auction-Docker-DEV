import { useEffect, useMemo, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authLogin, authLogout, authMe, fetchCeleryOverview } from '../api'
import AdminLoginPanel from '../components/AdminLoginPanel'

const ADMIN_AUTH_FLAG_KEY = 'admin-authenticated'
const ADMIN_AUTH_USERNAME_KEY = 'admin-username'

function getCachedAdminAuth() {
  if (typeof window === 'undefined') return { authenticated: false, username: null }
  const authenticated = window.sessionStorage.getItem(ADMIN_AUTH_FLAG_KEY) === '1'
  const username = window.sessionStorage.getItem(ADMIN_AUTH_USERNAME_KEY)
  return { authenticated, username }
}

function AdminPage() {
  const navigate = useNavigate()
  const cachedAuth = getCachedAdminAuth()
  const [authState, setAuthState] = useState({
    loading: true,
    authenticated: cachedAuth.authenticated,
    is_staff: cachedAuth.authenticated,
    username: cachedAuth.username,
  })
  const [loginForm, setLoginForm] = useState({ username: '', password: '' })
  const [loginError, setLoginError] = useState('')

  const [overview, setOverview] = useState({ workers: [], running_tasks: [], pending_tasks: [], manual_tasks: [] })
  const [overviewLoading, setOverviewLoading] = useState(true)
  const [overviewStatus, setOverviewStatus] = useState('success')
  const hasOverviewLoadedRef = useRef(false)

  const isAdmin = authState.authenticated && authState.is_staff
  const accessLevel = authState.is_superuser ? 'Superuser' : 'Staff'
  const workersOnline = useMemo(() => {
    const directWorkers = Array.isArray(overview.workers) ? overview.workers.length : 0
    const registeredWorkers = overview.registered_tasks && typeof overview.registered_tasks === 'object'
      ? Object.keys(overview.registered_tasks).length
      : 0
    const statsWorkers = overview.stats && typeof overview.stats === 'object'
      ? Object.keys(overview.stats).length
      : 0

    return Math.max(directWorkers, registeredWorkers, statsWorkers)
  }, [overview])
  const periodicCount = (overview.beat_schedule || []).length
  const displayedOverviewStatus = useMemo(() => {
    if (!overviewLoading) return overviewStatus
    return overviewStatus === 'timeout' || overviewStatus === 'error' ? overviewStatus : 'loading'
  }, [overviewLoading, overviewStatus])
  const scheduledCount = useMemo(
    () => (overview.pending_tasks || []).filter((task) => task.state === 'scheduled').length,
    [overview]
  )
  const reservedCount = useMemo(
    () => (overview.pending_tasks || []).filter((task) => task.state === 'reserved').length,
    [overview]
  )

  useEffect(() => {
    let isActive = true

    async function run() {
      try {
        const me = await authMe()
        if (!isActive) return
        setAuthState({ loading: false, ...me })
        if (me?.authenticated && me?.is_staff) {
          window.sessionStorage.setItem(ADMIN_AUTH_FLAG_KEY, '1')
          if (me?.username) window.sessionStorage.setItem(ADMIN_AUTH_USERNAME_KEY, me.username)
        } else {
          window.sessionStorage.removeItem(ADMIN_AUTH_FLAG_KEY)
          window.sessionStorage.removeItem(ADMIN_AUTH_USERNAME_KEY)
        }
      } catch {
        if (!isActive) return
        if (cachedAuth.authenticated) {
          setAuthState({
            loading: false,
            authenticated: true,
            is_staff: true,
            username: cachedAuth.username,
          })
          return
        }
        setAuthState({ loading: false, authenticated: false, is_staff: false, username: null })
      }
    }

    run()
    return () => {
      isActive = false
    }
  }, [])

  useEffect(() => {
    if (!isAdmin) return undefined

    let isActive = true
    let timerId

    const fetchOverview = async () => {
      try {
        setOverviewLoading(true)
        const data = await fetchCeleryOverview()
        if (!isActive) return
        setOverview(data)
        if (data.celery_error) {
          console.error('[AdminPage] Celery overview error:', data.celery_error)
          setOverviewStatus(data.celery_error.toLowerCase().includes('timeout') ? 'timeout' : 'error')
        } else {
          setOverviewStatus('success')
        }
        hasOverviewLoadedRef.current = true
        setOverviewLoading(false)
      } catch (error) {
        if (!isActive) return
        const message = error?.message || 'Request timeout'
        setOverviewStatus(message.toLowerCase().includes('timeout') ? 'timeout' : 'error')
        setOverviewLoading(false)
        if (message.toLowerCase().includes('timeout')) {
          console.error('[AdminPage] Celery overview request failed: Request timeout')
        } else {
          console.error('[AdminPage] Celery overview request failed:', message)
        }
      } finally {
        if (!isActive) return
        timerId = setTimeout(fetchOverview, 4000)
      }
    }

    fetchOverview()

    return () => {
      isActive = false
      clearTimeout(timerId)
    }
  }, [isAdmin])

  const handleLogin = async (event) => {
    event.preventDefault()
    setLoginError('')

    try {
      const result = await authLogin(loginForm.username, loginForm.password)
      setAuthState({ loading: false, authenticated: true, ...result })
      window.sessionStorage.setItem(ADMIN_AUTH_FLAG_KEY, '1')
      window.sessionStorage.setItem(ADMIN_AUTH_USERNAME_KEY, result.username || loginForm.username)
      window.dispatchEvent(new CustomEvent('admin-auth-changed', { detail: { authenticated: true } }))
      setLoginForm({ username: '', password: '' })
    } catch (error) {
      setLoginError(error.message || 'Ошибка входа')
    }
  }

  const handleLogout = async () => {
    await authLogout()
    setAuthState({ loading: false, authenticated: false, is_staff: false, username: null })
    window.sessionStorage.removeItem(ADMIN_AUTH_FLAG_KEY)
    window.sessionStorage.removeItem(ADMIN_AUTH_USERNAME_KEY)
    window.dispatchEvent(new CustomEvent('admin-auth-changed', { detail: { authenticated: false } }))
    navigate('/')
  }

  if (authState.loading) {
    return <div className="text-secondary">Проверка доступа...</div>
  }

  if (!isAdmin) {
    return (
      <AdminLoginPanel
        accessTargetText="[ЦEHTP_УПР4ВЛ3HИЯ]"
        submitCipherText="П0ДТВ3РДИТЬ"
        username={loginForm.username}
        password={loginForm.password}
        loginError={loginError}
        onSubmit={handleLogin}
        onUsernameChange={(value) => setLoginForm((prev) => ({ ...prev, username: value }))}
        onPasswordChange={(value) => setLoginForm((prev) => ({ ...prev, password: value }))}
      />
    )
  }

  return (
    <div className="d-flex flex-column gap-3">
      <div className="glass-panel p-3 d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
          <h4 className="mb-2">Центр управления</h4>
          <div className="small text-secondary">Логин: {authState.username}</div>
          <div className="small text-secondary">Уровень доступа: {accessLevel}</div>
        </div>
      </div>

      <div className="row g-3 row-cols-1 row-cols-md-2 row-cols-xl-3">

        <div className="col">
          <div className="glass-panel p-3 h-100 d-flex flex-column">
            <h6 className="panel-title mb-2">Celery Tasks</h6>
            <div className="small text-secondary mb-3">Мониторинг воркеров, запуск и остановка задач, просмотр логов.</div>
            <div className="d-flex justify-content-between align-items-start gap-2 mb-3">
              <div>
                <div className="small text-secondary">Workers online: {workersOnline}</div>
                <div className="small text-secondary">Running: {overview.running_tasks?.length || 0}</div>
                <div className="small text-secondary">Pending: {overview.pending_tasks?.length || 0}</div>
              </div>
              <div
                className={`admin-status-dot admin-status-${displayedOverviewStatus}`}
                role="status"
                aria-label={`Статус Celery: ${displayedOverviewStatus}`}
              />
            </div>
            <button
              type="button"
              className="btn btn-sm btn-accent mt-auto"
              onClick={() => navigate('/control-center/celery-tasks')}
            >
              Открыть
            </button>
          </div>
        </div>

        <div className="col">
          <div className="glass-panel p-3 h-100 d-flex flex-column">
            <h6 className="panel-title mb-2">Celery Scheduler</h6>
            <div className="small text-secondary mb-3">Просмотр и отмена запланированных/ожидающих задач.</div>
            <div className="d-flex justify-content-between align-items-start gap-2 mb-3">
              <div>
                <div className="small text-secondary">Periodic: {periodicCount}</div>
                <div className="small text-secondary">Scheduled: {scheduledCount}</div>
                <div className="small text-secondary">Reserved: {reservedCount}</div>
              </div>
              <div
                className={`admin-status-dot admin-status-${displayedOverviewStatus}`}
                role="status"
                aria-label={`Статус планировщика: ${displayedOverviewStatus}`}
              />
            </div>
            <button
              type="button"
              className="btn btn-sm btn-accent mt-auto"
              onClick={() => navigate('/control-center/celery-scheduler')}
            >
              Открыть
            </button>
          </div>
        </div>

        <div className="col">
          <div className="glass-panel p-3 h-100 d-flex flex-column">
            <h6 className="panel-title mb-2">Инструмент 3</h6>
            <div className="small text-secondary mb-3">Скоро здесь появится новый модуль управления.</div>
            <button type="button" className="btn btn-sm btn-outline-secondary mt-auto" disabled>Скоро</button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default AdminPage
