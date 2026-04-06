import AppHeader from './AppHeader'
import AppFooter from './AppFooter'

function AppLayout({ isAdminAuthenticated, onAdminLogin, onAdminCenter, onAdminLogout, children }) {
  return (
    <div className="app-shell">
      <AppHeader
        isAdminAuthenticated={isAdminAuthenticated}
        onAdminLogin={onAdminLogin}
        onAdminCenter={onAdminCenter}
        onAdminLogout={onAdminLogout}
      />

      <main className="container-fluid px-4 py-4 app-main">
        {children}
      </main>

      <AppFooter />
    </div>
  )
}

export default AppLayout
