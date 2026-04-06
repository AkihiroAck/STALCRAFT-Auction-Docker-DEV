import { useEffect, useState } from 'react'

const CIPHER_ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789[]:#-_?*'

function getRandomCipherChar() {
  const index = Math.floor(Math.random() * CIPHER_ALPHABET.length)
  return CIPHER_ALPHABET[index]
}

function CipherText({ text, className = '', scrambleChance = 0.3, intervalMs = 120 }) {
  const [displayText, setDisplayText] = useState(text)

  useEffect(() => {
    if (typeof window !== 'undefined' && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      setDisplayText(text)
      return undefined
    }

    const timerId = window.setInterval(() => {
      const next = text
        .split('')
        .map((char) => {
          if (char === ' ') return char
          if (Math.random() > scrambleChance) return char
          return getRandomCipherChar()
        })
        .join('')

      setDisplayText(next)
    }, intervalMs)

    return () => {
      window.clearInterval(timerId)
    }
  }, [text, scrambleChance, intervalMs])

  return <span className={className}>{displayText}</span>
}

export default CipherText
