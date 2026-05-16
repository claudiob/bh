import { Controller } from "@hotwired/stimulus"

// If enabled on a form then disables any submit button in the form unless
// all the required inputs have values.
export default class extends Controller {
  connect() {
    this.toggle()
    this.element.querySelectorAll('[required').forEach((input) =>
      input.addEventListener('input', () => {this.toggle()})
    )
  }

  // Disables the button if all chekboxes are unchecked.
  toggle() {
    const invalidValues = this.element.querySelectorAll('[required]:invalid')
    const submitButtons = this.element.querySelectorAll('input[type="submit"]')
    const disable = (invalidValues.length > 0);
    [...submitButtons].map(button => button.disabled = disable)
  }
}
