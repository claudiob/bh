import { Controller } from "@hotwired/stimulus"

// If enabled on a collection of checkboxes or radio buttons then disables any submit button in the
// form unless at least one checkbox/radio with a value is picked or a textarea is filled.
export default class extends Controller {
  static targets = [ 'textarea' ]

  connect() {
    this.#toggle()
    this.element.querySelectorAll('input').forEach((input) =>
      input.addEventListener('change', () => {this.#toggle()})
    )
    this.textareaTarget.addEventListener('input', () => {this.#toggle()})
  }

  // Disables the button if all valued chekboxes are unchecked and textareas are empty.
  #toggle() {
    const textareaValue = this.textareaTarget.value.trim()
    const checkedBoxes = this.element.querySelectorAll('input:checked:not([value=""])')
    const submitButtons = this.element.querySelectorAll('input[type="submit"]')
    const disable = (checkedBoxes.length == 0 && textareaValue.length == 0);
    [...submitButtons].map(button => button.disabled = disable)
  }
}
