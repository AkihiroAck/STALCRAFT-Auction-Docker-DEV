import { Link, NavLink } from 'react-router-dom'
import { Server } from 'lucide-react'
import GlobalSearchBar from './GlobalSearchBar'
import CipherText from './CipherText'

function AppHeader({ isAdminAuthenticated, onAdminLogin, onAdminCenter, onAdminLogout }) {
  return (
    <header className="topbar border-bottom border-secondary-subtle">
      <div className="container-fluid py-3 px-4 d-flex align-items-center justify-content-between gap-3 flex-wrap topbar-row">
        <div className="d-flex align-items-center gap-4">
          <Link to="/" className="brand-link" aria-label="STALCRAFT AUCTION">
            <CipherText
              text="STALCRAFT AUCTION"
              className="cipher-text cipher-inline-text brand-cipher-text"
              scrambleChance={0.01}
              intervalMs={100}
            />
          </Link>
          <nav className="d-flex align-items-center gap-2">
            <NavLink className="nav-pill" to="/items">Предметы</NavLink>
            <NavLink className="nav-pill" to="/upload-lang">AVG to lang</NavLink>
          </nav>
        </div>

        <div className="text-secondary small topbar-center-label d-flex align-items-center gap-1">
          <Server size={14} strokeWidth={2} aria-hidden="true" />
          <CipherText
            text="Dark analytics core interface"
            className="cipher-text cipher-inline-text text-secondary"
            scrambleChance={0.01}
            intervalMs={100}
          />
        </div>

        <div className="d-flex align-items-center gap-3 ms-auto">
          <GlobalSearchBar />
          {isAdminAuthenticated ? (
            <>
              <button type="button" className="nav-pill" onClick={onAdminCenter}>
                Центр управления
              </button>
              <button type="button" className="nav-pill" onClick={onAdminLogout}>
                Выйти
              </button>
            </>
          ) : (
            <button type="button" className="nav-pill" onClick={onAdminLogin}>
              <CipherText text="[R3DACT3D]" className="cipher-login-text" scrambleChance={0.25} intervalMs={150} />
            </button>
          )}
        </div>
      </div>
    </header>
  )
}

export default AppHeader
