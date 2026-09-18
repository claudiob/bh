import { Controller } from '@hotwired/stimulus'
import { Tooltip } from 'bootstrap'

// Largest first, so the first one an instant clears is the one it is said in.
const UNITS = [
  ['year', 31536000000], ['month', 2592000000], ['week', 604800000],
  ['day', 86400000], ['hour', 3600000], ['minute', 60000],
]

// How long ago a timestamp was, said again at the moment somebody asks. The server
// writes the same words with Rails' own helper, which is what a reader without
// JavaScript gets — but a table is cached and a page is left open, so those words are
// only true when they are drawn. These are true when they are read.
export default class extends Controller {
  // Before the `tooltip` controller beside it, which is what makes the instance: this
  // listener is registered first and so runs before Bootstrap's own.
  connect() {
    this.entered = () => this.#refresh()
    this.element.addEventListener('mouseenter', this.entered)
  }

  disconnect() {
    this.element.removeEventListener('mouseenter', this.entered)
  }

  // Through `setContent`, since Bootstrap reads a tooltip's words once when it is made
  // and never looks at the attribute again.
  #refresh() {
    const at = new Date(this.element.getAttribute('datetime'))
    if (isNaN(at.getTime())) { return }

    Tooltip.getInstance(this.element)?.setContent({ '.tooltip-inner': this.#words(at) })
  }

  #words(at) {
    const format = new Intl.RelativeTimeFormat(document.documentElement.lang || 'en')
    const ms = at - new Date()

    for (const [unit, size] of UNITS) {
      if (Math.abs(ms) >= size) { return format.format(Math.round(ms / size), unit) }
    }

    return format.format(Math.round(ms / 1000), 'second')
  }
}
