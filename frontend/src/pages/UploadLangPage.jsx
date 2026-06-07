import { useState } from 'react'
import { processLangFile } from '../api'

function UploadLangPage() {
  const [file, setFile] = useState(null)
  const [months, setMonths] = useState(2)  // По умолчанию 2 месяца, можно изменить на 1 или 3
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState('')

  const handleSubmit = async (event) => {
    event.preventDefault()

    if (!file) {
      setError('Выберите файл ru.lang')
      return
    }

    setIsLoading(true)
    setError('')

    try {
      const resultBlob = await processLangFile(file, months)
      const url = URL.createObjectURL(resultBlob)
      const link = document.createElement('a')
      link.href = url
      link.download = 'ru.lang'
      link.click()
      URL.revokeObjectURL(url)
    } catch (submitError) {
      setError(submitError.message || 'Ошибка обработки файла')
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="glass-panel p-4 p-md-5 lang-panel">
      <h3 className="mb-3">AVG to lang</h3>
      <p className="text-secondary mb-4">
        Загрузите файл ru.lang и получите обновленную версию со средними ценами.
      </p>

      <form onSubmit={handleSubmit} className="d-flex flex-column gap-3">
        <div>
          <label className="form-label">Файл</label>
          <input
            type="file"
            className="form-control"
            accept=".lang,text/plain"
            onChange={(event) => setFile(event.target.files?.[0] || null)}
          />
        </div>

        <div>
          <label className="form-label">Период (месяцы)</label>
          <select
            className="form-select"
            value={months}
            onChange={(event) => setMonths(Number(event.target.value))}
          >
            <option value={1}>1 месяц</option>
            <option value={2}>2 месяца</option>
            <option value={3}>3 месяца</option>
          </select>
        </div>

        {error && <div className="alert alert-danger mb-0">{error}</div>}

        <button type="submit" className="btn btn-accent align-self-start" disabled={isLoading}>
          {isLoading ? 'Обработка...' : 'Скачать обработанный файл'}
        </button>
      </form>
    </div>
  )
}

export default UploadLangPage
