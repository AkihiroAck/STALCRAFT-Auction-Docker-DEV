import CipherText from './CipherText'
import { UserLock } from 'lucide-react'
import { Link } from 'react-router-dom'

function AdminLoginPanel({
  accessTargetText,
  submitCipherText,
  username,
  password,
  loginError,
  onSubmit,
  onUsernameChange,
  onPasswordChange,
}) {
  return (
    <div className="admin-login-wrap">
      <div className="glass-panel p-4 admin-login-panel">
        <h3 className="mb-3 d-flex align-items-center justify-content-between">
          <span>
            <CipherText text="В0ЙТU_В_СUСТ3МУ" className="cipher-login-text" scrambleChance={0.1} intervalMs={150} />
          </span>
          <UserLock size="1em" strokeWidth={2} aria-hidden="true" className="text-secondary" />
        </h3>
        <p className="text-secondary">
          П0ДТВЕРЖДЕНUЕ{' '}
          <CipherText text="К0РП-ID" className="cipher-login-text cipher-inline-text text-secondary" scrambleChance={0.1} intervalMs={150} />{' '}
          0бя3аTеJIьH0. <br />Д0CTYП K{' '}
          <CipherText text={accessTargetText} className="cipher-login-text cipher-inline-text text-secondary" scrambleChance={0.1} intervalMs={150} />{' '}
          Pа3PеIIIеH TоJIьк0 для Перс0наJIа с ур0внeм д0пускa{' '}
          <CipherText text="L0-K1" className="cipher-login-text cipher-inline-text text-secondary" scrambleChance={0.1} intervalMs={150} />.
        </p>

        <form className="d-flex flex-column gap-3" onSubmit={onSubmit}>
          <input
            className="form-control"
            placeholder="U53R_N4M3"
            value={username}
            onChange={(event) => onUsernameChange(event.target.value)}
          />
          <input
            className="form-control"
            type="password"
            placeholder="P4$$_C0D3"
            value={password}
            onChange={(event) => onPasswordChange(event.target.value)}
          />
          {loginError && <div className="alert alert-danger mb-0">{loginError}</div>}
          <div className="d-flex align-items-center gap-2">
            <Link to="/" className="btn btn-outline-secondary">
              <CipherText text="НA3AД" className="cipher-login-text" scrambleChance={0.1} intervalMs={150} />
            </Link>
            <button className="btn btn-accent" type="submit">
              <CipherText text={submitCipherText} className="cipher-login-text" scrambleChance={0.1} intervalMs={150} />
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default AdminLoginPanel
