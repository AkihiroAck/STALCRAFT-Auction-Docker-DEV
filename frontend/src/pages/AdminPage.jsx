import { useEffect, useMemo, useState } from 'react'
import {
  authLogin,
  authLogout,
  authMe,
  fetchCeleryLogs,
  fetchCeleryOverview,
  startCeleryTask,
  stopCeleryTask,
} from '../api'

function AdminPage() {
  const [authState, setAuthState] = useState({ loading: true, authenticated: false, is_staff: false, username: null })
  const [loginForm, setLoginForm] = useState({ username: '', password: '' })
  const [loginError, setLoginError] = useState('')

  const [overview, setOverview] = useState({ workers: [], running_tasks: [], pending_tasks: [], manual_tasks: [] })
  const [selectedTask, setSelectedTask] = useState('')
  const [logSource, setLogSource] = useState('app')
  const [logs, setLogs] = useState([])
  const [actionStatus, setActionStatus] = useState('')

  const isAdmin = authState.authenticated && authState.is_staff

  useEffect(() => {
    let isActive = true

    async function run() {
      try {
        const me = await authMe()
        if (!isActive) return
        setAuthState({ loading: false, ...me })
      } catch {
        if (!isActive) return
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

    const fetchOverview = async () => {
      try {
        const data = await fetchCeleryOverview()
        if (!isActive) return
        setOverview(data)
        if (!selectedTask && data.manual_tasks?.length) {
          setSelectedTask(data.manual_tasks[0])
        }
      } catch {
        if (!isActive) return
      }
    }

    fetchOverview()
    const interval = setInterval(fetchOverview, 4000)

    return () => {
      isActive = false
      clearInterval(interval)
    }
  }, [isAdmin, selectedTask])

  useEffect(() => {
    if (!isAdmin) return undefined

    let isActive = true

    const fetchLogs = async () => {
      try {
        const data = await fetchCeleryLogs(logSource, 250)
        if (!isActive) return
        setLogs(data.lines || [])
      } catch {
        if (!isActive) return
      }
    }

    fetchLogs()
    const interval = setInterval(fetchLogs, 2000)

    return () => {
      isActive = false
      clearInterval(interval)
    }
  }, [isAdmin, logSource])

  const runningTaskIds = useMemo(() => new Set((overview.running_tasks || []).map((task) => task.id)), [overview.running_tasks])

  const handleLogin = async (event) => {
    event.preventDefault()
    setLoginError('')

    try {
      const result = await authLogin(loginForm.username, loginForm.password)
      setAuthState({ loading: false, authenticated: true, ...result })
      setLoginForm({ username: '', password: '' })
    } catch (error) {
      setLoginError(error.message || 'Ошибка входа')
    }
  }

  const handleLogout = async () => {
    await authLogout()
    setAuthState({ loading: false, authenticated: false, is_staff: false, username: null })
  }

  const handleStartTask = async () => {
    if (!selectedTask) return
    try {
      const result = await startCeleryTask(selectedTask)
      setActionStatus(`Запущена задача ${result.task_name} (${result.task_id})`)
    } catch (error) {
      setActionStatus(error.message || 'Не удалось запустить задачу')
    }
  }

  const handleStopTask = async (taskId) => {
    try {
      await stopCeleryTask(taskId, true, 'SIGTERM')
      setActionStatus(`Задача ${taskId} остановлена`)
    } catch (error) {
      setActionStatus(error.message || 'Не удалось остановить задачу')
    }
  }

  if (authState.loading) {
    return <div className="text-secondary">Проверка доступа...</div>
  }

  if (!isAdmin) {
    return (
      <div className="glass-panel p-4 admin-login-panel">
        <h3 className="mb-3">Вход администратора</h3>
        <p className="text-secondary">Авторизуйтесь учетной записью Django superuser/staff для доступа к Celery панели.</p>

        <form className="d-flex flex-column gap-3" onSubmit={handleLogin}>
          <input
            className="form-control"
            placeholder="Username"
            value={loginForm.username}
            onChange={(event) => setLoginForm((prev) => ({ ...prev, username: event.target.value }))}
          />
          <input
            className="form-control"
            type="password"
            placeholder="Password"
            value={loginForm.password}
            onChange={(event) => setLoginForm((prev) => ({ ...prev, password: event.target.value }))}
          />
          {loginError && <div className="alert alert-danger mb-0">{loginError}</div>}
          <button className="btn btn-accent align-self-start" type="submit">Войти</button>
        </form>
      </div>
    )
  }

  return (
    <div className="d-flex flex-column gap-3">
      <div className="glass-panel p-3 d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
          <h4 className="mb-1">Celery Monitor</h4>
          <div className="small text-secondary">Администратор: {authState.username}</div>
        </div>
        <button type="button" className="btn btn-outline-light" onClick={handleLogout}>Выйти</button>
      </div>

      <div className="row g-3">
        <div className="col-12 col-xl-4">
          <div className="glass-panel p-3 h-100">
            <h6 className="panel-title mb-3">Управление задачами</h6>

            <label className="small text-secondary mb-1">Запуск задачи</label>
            <div className="d-flex gap-2">
              <select className="form-select" value={selectedTask} onChange={(event) => setSelectedTask(event.target.value)}>
                {(overview.manual_tasks || []).map((taskName) => (
                  <option key={taskName} value={taskName}>{taskName}</option>
                ))}
              </select>
              <button type="button" className="btn btn-accent" onClick={handleStartTask}>Start</button>
            </div>

            <div className="mt-3 small text-secondary">Workers online: {overview.workers?.length || 0}</div>
            <div className="small text-secondary">Running: {overview.running_tasks?.length || 0}</div>
            <div className="small text-secondary">Pending: {overview.pending_tasks?.length || 0}</div>

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

export default AdminPage
