import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.#format(this.element)
  }

  down(event) {
    if (!event.key) { return }
    if (event.ctrlKey) { return }
    if (event.metaKey) { return }
    if (event.key.length > 1) { return }
    if (/[0-9.]/.test(event.key)) { return }
    event.preventDefault()
  }

  input(event) {
    if (event.inputType === 'deleteContentBackward') { return }
    if (/[\d-]{12}/.test(event.target.value)) { event.preventDefault() }
    this.#format(event.target)
  }

  #format(element) {
    const digits = element.value.replace(/\D/g,'').substring(0, 10)
    const areaCode = digits.substring(0, 3)
    const prefix = digits.substring(3, 6)
    const suffix = digits.substring(6, 10)

    if (digits.length > 5) { element.value = `${areaCode}-${prefix}-${suffix}` }
    else if (digits.length > 2) { element.value = `${areaCode}-${prefix}` }
    else if (digits.length > 0) { element.value = `${areaCode}` }
  }
}
