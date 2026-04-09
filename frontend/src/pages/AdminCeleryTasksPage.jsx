import { useEffect, useMemo, useRef, useState } from 'react'
import StatusLamp from '../components/StatusLamp'
import { Link } from 'react-router-dom'
import {
  authLogin,
  authMe,
  fetchCeleryLogs,
  fetchCeleryOverview,
  startCeleryTask,
  stopCeleryTask,
} from '../api'
import AdminLoginPanel from '../components/AdminLoginPanel'

const ADMIN_AUTH_FLAG_KEY = 'admin-authenticated'
const ADMIN_AUTH_USERNAME_KEY = 'admin-username'

function getCachedAdminAuth() {
  if (typeof window === 'undefined') return { authenticated: false, username: null }
  const authenticated = window.sessionStorage.getItem(ADMIN_AUTH_FLAG_KEY) === '1'
  const username = window.sessionStorage.getItem(ADMIN_AUTH_USERNAME_KEY)
  return { authenticated, username }
}

function AdminCeleryTasksPage() {
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
  // null — статус ещё не получен, иначе: 'success', 'timeout', 'error'
  const [overviewStatus, setOverviewStatus] = useState(null)
  const [hasOverviewLoaded, setHasOverviewLoaded] = useState(false)
  const [selectedTask, setSelectedTask] = useState('')
  const [logSource, setLogSource] = useState('app')
  const [logs, setLogs] = useState([])
  const [actionStatus, setActionStatus] = useState('')

  const isAdmin = authState.authenticated && authState.is_staff
  const hasOverviewLoadedRef = useRef(false)
  // Для лампочки статуса: null (ещё не было ответа) — серый, иначе последний статус
  const displayedOverviewStatus = overviewStatus ?? 'none'
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
          console.error('[AdminCeleryTasksPage] Celery overview error:', data.celery_error)
          setOverviewStatus(data.celery_error.toLowerCase().includes('timeout') ? 'timeout' : 'error')
        } else {
          setOverviewStatus('success')
        }
        setHasOverviewLoaded(true)
        hasOverviewLoadedRef.current = true
        setOverviewLoading(false)
        if (data.manual_tasks?.length) {
          setSelectedTask((prev) => prev || data.manual_tasks[0])
        }
      } catch (error) {
        if (!isActive) return
        const message = error.message || 'Не удалось получить статус Celery'
        setOverviewStatus(message.toLowerCase().includes('timeout') ? 'timeout' : 'error')
        setOverviewLoading(false)
        if (message.toLowerCase().includes('timeout')) {
          console.error('[AdminCeleryTasksPage] Request timeout while loading Celery overview')
        } else {
          console.error('[AdminCeleryTasksPage] Failed to load Celery overview:', message)
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

  useEffect(() => {
    if (!isAdmin || !hasOverviewLoaded) return undefined

    let isActive = true
    let timerId

    const fetchLogs = async () => {
      try {
        const data = await fetchCeleryLogs(logSource, 80)
        if (!isActive) return
        setLogs(data.lines || [])
      } catch {
        if (!isActive) return
      } finally {
        if (!isActive) return
        timerId = setTimeout(fetchLogs, 8000)
      }
    }

    fetchLogs()

    return () => {
      isActive = false
      clearTimeout(timerId)
    }
  }, [isAdmin, hasOverviewLoaded, logSource])

  const runningTaskIds = useMemo(() => new Set((overview.running_tasks || []).map((task) => task.id)), [overview.running_tasks])

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

  const handleStartTask = async () => {
    if (!selectedTask) return
    try {
      const result = await startCeleryTask(selectedTask)
      setActionStatus(`Запущена задача ${result.task_name} (${result.task_id})`)
    } catch (error) {
      console.error('[AdminCeleryTasksPage] Failed to start task:', error.message || 'Не удалось запустить задачу')
    }
  }

  const handleStopTask = async (taskId) => {
    try {
      await stopCeleryTask(taskId, true, 'SIGTERM')
      setActionStatus(`Задача ${taskId} остановлена`)
    } catch (error) {
      console.error('[AdminCeleryTasksPage] Failed to stop task:', error.message || 'Не удалось остановить задачу')
    }
  }

  if (authState.loading) {
    return <div className="text-secondary">Проверка доступа...</div>
  }

  if (!isAdmin) {
    return (
      <AdminLoginPanel
        accessTargetText="[M0ДYЛЬ_C3L3RY]"
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
          {' < Celery Tasks'}
        </div>
        <h4 className="mb-0">Celery Tasks</h4>
      </div>

      <div className="row g-3">
        <div className="col-12 col-xl-4">
          <div className="glass-panel p-3 h-100">
            <h6 className="panel-title mb-3">Управление задачами</h6>

            <label className="small text-secondary mb-1">Запуск задачи</label>
            <div className="d-flex gap-2">
              <select className="form-select" value={selectedTask} onChange={(event) => setSelectedTask(event.target.value)}>
                {(overview.manual_tasks || []).length > 0 ? (
                  (overview.manual_tasks || []).map((taskName) => (
                    <option key={taskName} value={taskName}>{taskName}</option>
                  ))
                ) : (
                  <option value="" disabled>Нет доступных задач</option>
                )}
              </select>
              <button
                type="button"
                className="btn btn-accent"
                onClick={handleStartTask}
                disabled={!selectedTask || (overview.manual_tasks || []).length === 0}
              >
                Start
              </button>
            </div>

            <div className="mt-3 d-flex justify-content-between align-items-start gap-2">
              <div>
                <div className="small text-secondary">Workers online: {workersOnline}</div>
                <div className="small text-secondary">Running: {overview.running_tasks?.length || 0}</div>
                <div className="small text-secondary">Pending: {overview.pending_tasks?.length || 0}</div>
              </div>
              <div className="d-flex align-items-center gap-2">
                <StatusLamp type="status" value={displayedOverviewStatus} />
                <StatusLamp type="loading" value={overviewLoading ? 'loading' : 'idle'} />
              </div>
            </div>

            {actionStatus && <div className="alert alert-info mt-3 mb-0 py-2">{actionStatus}</div>}
          </div>
        </div>

        <div className="col-12 col-xl-8">
          <div className="glass-panel p-3 h-100">
            <h6 className="panel-title mb-3">Активные задачи</h6>

            {overview.running_tasks?.length ? (
              <div className="d-flex flex-column gap-2">
                {overview.running_tasks.map((task) => (
                  <div key={task.id} className="admin-task-row">
                    <div>
                      <div className="fw-semibold">{task.name}</div>
                      <div className="small text-secondary">{task.id}</div>
                      <div className="small text-secondary">Worker: {task.worker}</div>
                    </div>
                    <button
                      type="button"
                      className="btn btn-sm btn-outline-danger"
                      disabled={!runningTaskIds.has(task.id)}
                      onClick={() => handleStopTask(task.id)}
                    >
                      Stop
                    </button>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-secondary">Сейчас нет активных задач.</div>
            )}
          </div>
        </div>
      </div>

      <div className="glass-panel p-3">
        <div className="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
          <h6 className="panel-title mb-0">Логи в реальном времени</h6>
          <select className="form-select admin-log-source" value={logSource} onChange={(event) => setLogSource(event.target.value)}>
            <option value="app">Task logs (app)</option>
            <option value="worker">Worker logs</option>
            <option value="beat">Beat logs</option>
          </select>
        </div>
        <pre className="admin-log-box mb-0">{logs.join('\n') || 'Логи пока пусты'}</pre>
      </div>
    </div>
  )
}

export default AdminCeleryTasksPage
