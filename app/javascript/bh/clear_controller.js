import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'button']

  connect() {
    this.toggle()
  }

  toggle() {
    this.buttonTarget.classList.toggle('d-none', !this.inputTarget.value)
  }

  clear() {
    this.inputTarget.value = ''
    // The combobox filters its menu on `input`, so it has to hear one to put every
    // row back. Bootstrap listens on the field itself, and the event bubbles anyway.
    this.inputTarget.dispatchEvent(new Event('input', { bubbles: true }))
    this.inputTarget.focus()
    this.toggle()
  }
}
