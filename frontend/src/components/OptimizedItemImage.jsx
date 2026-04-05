import { useMemo, useState } from 'react'

function OptimizedItemImage({
  src,
  alt,
  fallbackSrc,
  frameClassName = '',
  frameStyle,
  imgClassName = '',
  loading = 'lazy',
  fetchPriority = 'auto',
}) {
  const [isLoaded, setIsLoaded] = useState(false)
  const [isFailed, setIsFailed] = useState(false)

  const currentSrc = useMemo(() => {
    if (isFailed && fallbackSrc) return fallbackSrc
    return src
  }, [isFailed, fallbackSrc, src])

  return (
    <div
      className={`${frameClassName} ${!isLoaded ? 'image-loading' : ''}`.trim()}
      style={frameStyle}
    >
      <img
        src={currentSrc}
        alt={alt}
        className={`${imgClassName} ${isLoaded ? 'image-loaded' : 'image-hidden'}`.trim()}
        loading={loading}
        decoding="async"
        fetchPriority={fetchPriority}
        onLoad={() => setIsLoaded(true)}
        onError={() => {
          if (fallbackSrc && !isFailed) {
            setIsFailed(true)
            setIsLoaded(false)
            return
          }
          setIsLoaded(true)
        }}
      />
    </div>
  )
}

export default OptimizedItemImage