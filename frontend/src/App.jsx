import { Link, NavLink, Route, Routes } from 'react-router-dom'
import ItemsPage from './pages/ItemsPage'
import ItemDetailPage from './pages/ItemDetailPage'
import UploadLangPage from './pages/UploadLangPage'
import GlobalSearchBar from './components/GlobalSearchBar'
import AdminPage from './pages/AdminPage'

function App() {
  return (
    <div className="app-shell">
      <header className="topbar border-bottom border-secondary-subtle">
        <div className="container-fluid py-3 px-4 d-flex align-items-center justify-content-between gap-3 flex-wrap">
          <div className="d-flex align-items-center gap-4">
            <Link to="/" className="brand-link">STALCRAFT AUCTION</Link>
            <nav className="d-flex align-items-center gap-2">
              <NavLink className="nav-pill" to="/items">Предметы</NavLink>
              <NavLink className="nav-pill" to="/upload-lang">AVG to lang</NavLink>
              <NavLink className="nav-pill" to="/admin-panel">Админ</NavLink>
            </nav>
          </div>
          <div className="d-flex align-items-center gap-3">
            <GlobalSearchBar />
            <div className="text-secondary small d-none d-xl-block">Dark analytics interface</div>
          </div>
        </div>
      </header>

      <main className="container-fluid px-4 py-4">
        <Routes>
          <Route path="/" element={<ItemsPage />} />
          <Route path="/items" element={<ItemsPage />} />
          <Route path="/items/:itemId" element={<ItemDetailPage />} />
          <Route path="/upload-lang" element={<UploadLangPage />} />
          <Route path="/admin-panel" element={<AdminPage />} />
        </Routes>
      </main>
    </div>
  )
}

export default App
