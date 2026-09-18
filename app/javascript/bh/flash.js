// The toast the server ships, built in the browser for the one message that has no
// response to arrive with. `data-controller` is what hands it to the toast
// controller for its timer and its X, so the two kinds fade alike.
export function flash(message, theme = 'theme-danger') {
  const toast = document.createElement('div')
  toast.className = `toast fade show ${theme}`
  toast.setAttribute('role', 'alert')
  toast.setAttribute('aria-live', 'assertive')
  toast.dataset.controller = 'toast'
  toast.dataset.action = ['mouseenter->toast#stopTimer', 'mouseleave->toast#startTimer',
                          'focusin->toast#stopTimer', 'focusout->toast#startTimer'].join(' ')
  const header = document.createElement('div')
  header.className = 'toast-header border-0'
  const text = document.createElement('span')
  text.className = 'me-auto'
  // Never innerHTML: this is a message, and a message is data.
  text.textContent = message
  header.append(text)
  toast.append(header)
  container().append(toast)
}

// A page with nothing to say ships no container at all, so the first message is what
// makes one.
function container() {
  let container = document.querySelector('.toast-container')
  if (container) return container

  container = document.createElement('div')
  container.className = 'toast-container position-fixed bottom-0 end-0 p-3'
  container.dataset.turboTemporary = ''
  document.body.append(container)

  return container
}
