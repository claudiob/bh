import { Controller } from '@hotwired/stimulus'
import { flash } from './flash.js'

// The square that keeps a row, answered before the server does. The icon flips under
// the cursor and the request goes in the background, so the table is never redrawn and
// the row stays where the eye left it — until the next load, where kept-first belongs.
//
// The form is still a real one. Without this controller it submits, redirects and
// reloads, which is the same floor every other button here degrades to.
export default class extends Controller {
  static values = { kept: Boolean, error: String }

  connect() {
    this.form = this.element.closest('form')
    this.row = this.element.closest('tr')
    this.icon = this.element.querySelector('i')
    this.form.addEventListener('submit', this.submit)
  }

  disconnect() {
    this.form.removeEventListener('submit', this.submit)
  }

  // An arrow so `this` survives being handed to the listener, and so the same
  // function object is the one removed again.
  submit = (event) => {
    event.preventDefault()
    const kept = !this.keptValue
    // Read the form before flipping it. The verb it is still wearing is the one this
    // click means — `post` to keep the row, `delete` to drop it — while `render`
    // dresses it for the click after this one, which is the opposite.
    const body = new FormData(this.form)
    this.render(kept)
    this.send(body, kept)
  }

  // What the eye reads, what a screen reader reads, and what the next click will do:
  // the path never changes, only the verb Rails wrote into the form.
  render(kept) {
    this.keptValue = kept
    this.icon.className = kept ? 'bi bi-bookmark-fill' : 'bi bi-bookmark'
    this.element.setAttribute('aria-pressed', kept)
    this.method.value = kept ? 'delete' : 'post'
  }

  // The token in the head, not the one in the form. Rails scopes a form's own token
  // to the method it was drawn with and this square flips that method; the form's is
  // inside a cached fragment besides, so it belongs to whichever session drew the
  // table. The head's is global to the session and fresh per request, and Rails takes
  // whichever of the two is valid.
  get token() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }

  // Rails' own override field, which `button_to` writes only for a delete — so a
  // square that started hollow has none until the first click makes one.
  get method() {
    let field = this.form.querySelector('input[name="_method"]')
    if (!field) {
      field = document.createElement('input')
      field.type = 'hidden'
      field.name = '_method'
      this.form.prepend(field)
    }
    return field
  }

  // The response is never rendered, but it is read: a 500, a dropped connection or
  // an expired session would otherwise leave a filled square that was never saved.
  // `Accept` is what tells the server this one wants no flash and no redirect.
  async send(body, kept) {
    try {
      const response = await fetch(this.form.action, {
        method: 'post',
        body,
        headers: { Accept: 'application/json', 'X-CSRF-Token': this.token },
      })
      if (!response.ok) return this.revert(kept)

      // The report, and the reason there is no toast: the row takes or loses its tint,
      // which says which rows are kept. The icon flipped on the click and would have
      // flipped under a request that never landed, so this is the half only the server
      // can give.
      this.row?.classList.toggle('recourse-kept', kept)
    } catch {
      this.revert(kept)
    }
  }

  // Put the square back, and say why — the one time this column speaks, since a click
  // that worked is reported by the row taking color. Nothing to put back but the
  // square: the tint is never laid on until the row is written.
  revert(kept) {
    this.render(!kept)
    flash(this.errorValue)
  }
}
