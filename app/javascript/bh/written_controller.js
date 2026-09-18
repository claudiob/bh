import { Controller } from '@hotwired/stimulus'
import { mark } from './written.js'

// The row a create or an update just landed on, marked for exactly as long as the
// toast that says so. One clock rather than two: the mark goes when the message goes,
// however long somebody held the toast open by reading it.
//
// `hide`, never `hidden`. Bootstrap fires the first as the toast begins to fade and the
// second only once it has finished, a whole second later — which is a mark still lit
// over a message that has already gone.
export default class extends Controller {
  static values = { row: String }

  // Only where the row is on this page — a record can be written onto a page it does
  // not appear on, sorted or filtered or paged away — and only where a toast is here
  // to end it, since nothing else would.
  connect() {
    const row = document.getElementById(this.rowValue)
    if (!row || !this.element.querySelector('.toast')) { return }

    this.fade = mark(row)
    this.element.addEventListener('hide.bs.toast', this.fade)
  }

  disconnect() {
    if (this.fade) { this.element.removeEventListener('hide.bs.toast', this.fade) }
  }
}
