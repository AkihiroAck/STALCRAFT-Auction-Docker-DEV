import { useEffect, useMemo, useRef, useState } from 'react'
import StatusLamp from '../components/StatusLamp'
import { Link } from 'react-router-dom'
import { authLogin, authMe, fetchCeleryOverview, startCeleryTask, stopCeleryTask } from '../api'
import AdminLoginPanel from '../components/AdminLoginPanel'

const ADMIN_AUTH_FLAG_KEY = 'admin-authenticated'
const ADMIN_AUTH_USERNAME_KEY = 'admin-username'

function getCachedAdminAuth() {
  if (typeof window === 'undefined') return { authenticated: false, username: null }
  const authenticated = window.sessionStorage.getItem(ADMIN_AUTH_FLAG_KEY) === '1'
  const username = window.sessionStorage.getItem(ADMIN_AUTH_USERNAME_KEY)
  return { authenticated, username }
}

function AdminCelerySchedulerPage() {
  const cachedAuth = getCachedAdminAuth()
  const [authState, setAuthState] = useState({
    loading: true,
    authenticated: cachedAuth.authenticated,
    is_staff: cachedAuth.authenticated,
    username: cachedAuth.username,
  })
  const [loginForm, setLoginForm] = useState({ username: '', password: '' })
  const [loginError, setLoginError] = useState('')

  const [overview, setOverview] = useState({ pending_tasks: [] })
  const [overviewLoading, setOverviewLoading] = useState(true)
  // null — статус ещё не получен, иначе: 'success', 'timeout', 'error'
  const [overviewStatus, setOverviewStatus] = useState(null)
  const [actionStatus, setActionStatus] = useState('')

  const isAdmin = authState.authenticated && authState.is_staff
  const hasOverviewLoadedRef = useRef(false)
  // Для лампочки статуса: null (ещё не было ответа) — серый, иначе последний статус
  const displayedOverviewStatus = overviewStatus ?? 'none'

  const scheduledTasks = useMemo(
    () => (overview.pending_tasks || []).filter((task) => task.state === 'scheduled'),
    [overview]
  )
  const reservedTasks = useMemo(
    () => (overview.pending_tasks || []).filter((task) => task.state === 'reserved'),
    [overview]
  )
  const periodicTasks = overview.beat_schedule || []

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
          console.error('[AdminCelerySchedulerPage] Celery scheduler overview error:', data.celery_error)
          setOverviewStatus(data.celery_error.toLowerCase().includes('timeout') ? 'timeout' : 'error')
        } else {
          setOverviewStatus('success')
        }
        hasOverviewLoadedRef.current = true
        setOverviewLoading(false)
      } catch (error) {
        if (!isActive) return
        const message = error.message || 'Не удалось получить список запланированных задач'
        setOverviewStatus(message.toLowerCase().includes('timeout') ? 'timeout' : 'error')
        setOverviewLoading(false)
        if (message.toLowerCase().includes('timeout')) {
          console.error('[AdminCelerySchedulerPage] Request timeout while loading scheduler overview')
        } else {
          console.error('[AdminCelerySchedulerPage] Failed to load scheduler overview:', message)
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

  const handleRevoke = async (taskId) => {
    if (!taskId) return
    try {
      await stopCeleryTask(taskId, true, 'SIGTERM')
      setActionStatus(`Задача ${taskId} отменена`)
    } catch (error) {
      console.error('[AdminCelerySchedulerPage] Failed to revoke task:', error.message || 'Не удалось отменить задачу')
    }
  }

  const handleRunNow = async (taskName) => {
    if (!taskName) return
    try {
      const result = await startCeleryTask(taskName)
      setActionStatus(`Задача ${result.task_name} запущена (${result.task_id})`)
    } catch (error) {
      console.error('[AdminCelerySchedulerPage] Failed to run task now:', error.message || 'Не удалось запустить задачу')
    }
  }

  if (authState.loading) {
    return <div className="text-secondary">Проверка доступа...</div>
  }

  if (!isAdmin) {
    return (
      <AdminLoginPanel
        accessTargetText="[PL4NN3R_C3L3RY]"
        submitCipherText="X1-7A:П0ДТВ3РДИТЬ"
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
      <div className="glass-panel p-3">
        <div className="small text-secondary mb-2">
          <Link to="/control-center" className="text-secondary text-decoration-none">Центр управления</Link>
          {' < Celery Scheduler'}
        </div>
        <h4 className="mb-0">Celery Scheduler</h4>
      </div>

      <div className="glass-panel p-3 d-flex justify-content-between align-items-start gap-3 flex-wrap">
        <div>
          <div className="small text-secondary">Periodic (beat_schedule): {periodicTasks.length}</div>
          <div className="small text-secondary">Scheduled: {scheduledTasks.length}</div>
          <div className="small text-secondary">Reserved: {reservedTasks.length}</div>
        </div>
        <div className="d-flex align-items-center gap-2">
          <StatusLamp type="status" value={displayedOverviewStatus} />
          <StatusLamp type="loading" value={overviewLoading ? 'loading' : 'idle'} />
        </div>
      </div>

      {actionStatus && <div className="alert alert-info mb-0 py-2">{actionStatus}</div>}

      <div className="row g-3">
        <div className="col-12">
          <div className="glass-panel p-3 h-100">
            <h6 className="panel-title mb-3">Периодические задачи (beat_schedule)</h6>
            {periodicTasks.length ? (
              <div className="d-flex flex-column gap-2">
                {periodicTasks.map((task) => (
                  <div key={`${task.name}-${task.task}`} className="admin-task-row">
                    <div>
                      <div className="fw-semibold">{task.name}</div>
                      <div className="small text-secondary">task: {task.task || 'N/A'}</div>
                      <div className="small text-secondary">schedule: {task.schedule || 'N/A'}</div>
                    </div>
                    <button
                      type="button"
                      className="btn btn-sm btn-outline-light"
                      onClick={() => handleRunNow(task.task)}
                      disabled={!task.task}
                    >
                      Запустить сейчас
                    </button>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-secondary">Периодические задачи не найдены.</div>
            )}
          </div>
        </div>

        <div className="col-12 col-xl-6">
          <div className="glass-panel p-3 h-100">
            <h6 className="panel-title mb-3">Scheduled задачи</h6>
            {scheduledTasks.length ? (
              <div className="d-flex flex-column gap-2">
                {scheduledTasks.map((task) => (
                  <div key={`${task.id || 'unknown'}-${task.name}-${task.eta || ''}`} className="admin-task-row">
                    <div>
                      <div className="fw-semibold">{task.name || 'Без имени'}</div>
                      <div className="small text-secondary">id: {task.id || 'N/A'}</div>
                      <div className="small text-secondary">eta: {task.eta || 'N/A'}</div>
                      <div className="small text-secondary">worker: {task.worker || 'N/A'}</div>
                    </div>
                    <button
                      type="button"
                      className="btn btn-sm btn-outline-danger"
                      onClick={() => handleRevoke(task.id)}
                      disabled={!task.id}
                    >
                      Отменить
                    </button>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-secondary">Сейчас нет scheduled задач.</div>
            )}
          </div>
        </div>

        <div className="col-12 col-xl-6">
          <div className="glass-panel p-3 h-100">
            <h6 className="panel-title mb-3">Reserved задачи</h6>
            {reservedTasks.length ? (
              <div className="d-flex flex-column gap-2">
                {reservedTasks.map((task) => (
                  <div key={`${task.id || 'unknown'}-${task.name}-${task.worker || ''}`} className="admin-task-row">
                    <div>
                      <div className="fw-semibold">{task.name || 'Без имени'}</div>
                      <div className="small text-secondary">id: {task.id || 'N/A'}</div>
                      <div className="small text-secondary">worker: {task.worker || 'N/A'}</div>
                    </div>
                    <button
                      type="button"
                      className="btn btn-sm btn-outline-danger"
                      onClick={() => handleRevoke(task.id)}
                      disabled={!task.id}
                    >
                      Отменить
                    </button>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-secondary">Сейчас нет reserved задач.</div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}

export default AdminCelerySchedulerPage
