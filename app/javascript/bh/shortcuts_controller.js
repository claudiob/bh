import { Controller } from '@hotwired/stimulus'

// Option is the modifier. Control and Command are spoken for — Control+C and
// Command+C are both copy — while Option is what a browser's own accesskey reaches
// for on most platforms, and it collides with almost nothing a page would want.
export default class extends Controller {
  connect() {
    this.reveal = (event) => this.element.classList.toggle('recourse-keys', event.altKey)
    this.hide = () => this.element.classList.remove('recourse-keys')
    this.press = (event) => this.#press(event)

    document.addEventListener('keydown', this.reveal)
    document.addEventListener('keyup', this.reveal)
    document.addEventListener('keydown', this.press)
    // Holding Option and switching windows would otherwise leave the hints up.
    window.addEventListener('blur', this.hide)
  }

  disconnect() {
    document.removeEventListener('keydown', this.reveal)
    document.removeEventListener('keyup', this.reveal)
    document.removeEventListener('keydown', this.press)
    window.removeEventListener('blur', this.hide)
  }

  #press(event) {
    if (!event.altKey || event.ctrlKey || event.metaKey) { return }

    // On a Mac, Option+c is 'ç', so the key pressed is read from the keyboard's own
    // layout-independent code rather than from the character it produced.
    const pressed = event.code.match(/^Key([A-Z])$/)
    if (!pressed) { return }

    const link = this.element.querySelector(`[data-key="${pressed[1].toLowerCase()}"]`)
    if (!link) { return }

    event.preventDefault()
    this.hide()
    // Clicked rather than assigned to, so Turbo takes the visit like any other link.
    link.click()
  }
}
