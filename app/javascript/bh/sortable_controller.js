import { Controller } from '@hotwired/stimulus'
import Sortable from 'sortablejs'
import { flash } from './flash.js'

// Drags a row of an arranged table to another place in it. Only the row that moved is
// reported, as the place it landed in: the server shifts whatever it displaced,
// because it is the only one that knows how many rows there are behind this page.
//
// The rows are a page rather than the table, so the index a drop reports is short by
// whatever the pages before it hold — `offset` is what makes up the difference, and a
// drag therefore moves a row within the page it is on.
export default class extends Controller {
  static values = { offset: Number, message: String }

  connect() {
    this.sortable = Sortable.create(this.element, {
      handle: '.recourse-handle',
      animation: 150,
      onStart: this.hold,
      onEnd: this.drop,
    })
    // A refresh broadcast morphs the page, and one arriving mid-drag would rewrite the
    // rows under the cursor. The search form sits a morph out the same way.
    document.addEventListener('turbo:before-morph-element', this.freeze)
  }

  disconnect() {
    this.sortable.destroy()
    document.removeEventListener('turbo:before-morph-element', this.freeze)
  }

  // Arrows, so `this` survives being handed to a listener and the same function object
  // is the one removed again.
  hold = () => {
    this.dragging = true
  }

  drop = ({ item, newIndex, oldIndex }) => {
    this.dragging = false
    if (newIndex === oldIndex) return

    this.send(item.dataset.sortableUpdateUrl, this.offsetValue + newIndex + 1)
  }

  freeze = (event) => {
    if (this.dragging && this.element.contains(event.target)) event.preventDefault()
  }

  // Nothing is rendered from the answer: the row is already where it was dropped, and
  // redrawing the table under the cursor that dropped it is what this avoids. It is
  // still read, so a move the server refused does not sit there looking saved.
  async send(url, position) {
    const body = new FormData()
    body.append('position', position)

    try {
      const response = await fetch(url, {
        method: 'PATCH',
        body,
        headers: { Accept: 'application/json', 'X-CSRF-Token': this.token },
      })
      if (!response.ok) return this.revert()

      // Said only once the row is actually written. The drop moved it on the screen and
      // would have moved it under a request that never landed, so this is the half of
      // the report only the server can give.
      flash(this.messageValue, 'theme-success')
    } catch {
      this.revert()
    }
  }

  // Put the table back the way the database has it, since the row is sitting somewhere
  // the server never agreed to.
  revert() {
    this.element.closest('turbo-frame')?.reload()
  }

  // The token in the head rather than one in a form: there is no form here, and the
  // head's is global to the session and fresh per request.
  get token() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }
}
