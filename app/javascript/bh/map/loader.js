// Google's own bootstrap, spelled out: `importLibrary` fetches the API the first time it
// is asked for a library, and the API then answers it itself. Once per page, however many
// maps are on it — and a Turbo visit keeps the page, so once per session in practice.
export function load(key) {
  const maps = (window.google ||= {}).maps ||= {}
  if (maps.importLibrary) return

  let loading
  maps.importLibrary = (library, ...rest) => {
    loading ||= new Promise((resolve, reject) => {
      const script = document.createElement('script')
      const params = new URLSearchParams({ key, v: 'weekly', loading: 'async', callback: 'google.maps.__ib__' })
      script.src = `https://maps.googleapis.com/maps/api/js?${params}`
      maps.__ib__ = resolve
      script.onerror = () => reject(new Error('The Google Maps API could not be loaded'))
      document.head.append(script)
    })
    return loading.then(() => maps.importLibrary(library, ...rest))
  }
}
