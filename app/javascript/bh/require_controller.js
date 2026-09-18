import { Controller } from '@hotwired/stimulus'

// A form's submit is shut until every required field has a value, so a reader is told
// a message cannot be sent before they try, not after.
export default class extends Controller {
  connect() {
    this.toggle()
    this.element.querySelectorAll('[required]').forEach((field) => {
      field.addEventListener('input', () => this.toggle())
    })
  }

  toggle() {
    const invalid = this.element.querySelectorAll('[required]:invalid').length > 0

    this.element.querySelectorAll('[type="submit"]').forEach((button) => { button.disabled = invalid })
  }
}
