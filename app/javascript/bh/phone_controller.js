import { Controller } from '@hotwired/stimulus'

// How a North American phone reads: `555-555-5555`, on a cell
// that shows one and in a field that takes one. The server hands over ten bare digits
// and a `data-controller`, and everything about the shape is decided here, so an app
// that wants `(555) 555-5555` changes this file and no Ruby.
export default class extends Controller {
  // Ten digits with the separators typed in; an area or exchange code never starts
  // with 0 or 1, which is what NANP forbids and what the server's own check enforces.
  static pattern = '[2-9]\\d{2}-[2-9]\\d{2}-\\d{4}'
  static sample = '555-555-5555'

  // A field says what shape it wants where the markup left that blank, and both a
  // field and a cell are formatted at once — so a form redrawn after a rejected save
  // shows the separators rather than the digits it was sent.
  connect() {
    if (this.#field) { this.#constrain() }
    this.#format()
  }

  // Only a digit goes in, and not an eleventh: a full field refuses the key itself rather
  // than taking it and cutting it back, since everything else watching the field — a
  // submit shut until it is valid — would see the eleven digits first and never the ten.
  down(event) {
    if (!event.key) { return }
    if (event.ctrlKey) { return }
    if (event.metaKey) { return }
    if (event.key.length > 1) { return }
    if (!/[0-9.]/.test(event.key)) { event.preventDefault(); return }
    if (this.#digits().length >= 10 && this.#nothingSelected()) { event.preventDefault() }
  }

  input(event) {
    if (event.inputType === 'deleteContentBackward') { return }
    this.#format()
  }

  get #field() {
    return this.element instanceof HTMLInputElement
  }

  #digits() {
    return this.constructor.digits(this.#field ? this.element.value : this.element.textContent)
  }

  #nothingSelected() {
    return this.element.selectionStart === this.element.selectionEnd
  }

  #constrain() {
    const { pattern, sample } = this.constructor
    const field = this.element
    field.pattern ||= pattern
    field.placeholder ||= sample
    field.title ||= `Please match the format ${sample}`
    field.inputMode ||= 'numeric'
  }

  // A value that came in whole — pasted, autofilled — is reshaped, and where that changed
  // it the field says `input` again, so a submit that read the raw paste reads the shape.
  #format() {
    const text = this.#field ? this.element.value : this.element.textContent
    const formatted = this.constructor.format(text)
    if (formatted === text) { return }

    if (!this.#field) { this.element.textContent = formatted; return }
    this.element.value = formatted
    if (this.saying) { return }
    this.saying = true
    this.element.dispatchEvent(new Event('input', { bubbles: true }))
    this.saying = false
  }

  // The digits in `text`, up to ten, with a dash after the third and the sixth.
  static format(text) {
    const digits = this.digits(text)
    const parts = [digits.substring(0, 3), digits.substring(3, 6), digits.substring(6, 10)]

    return parts.filter((part) => part.length > 0).join('-')
  }

  // The digits alone, less the country code a number arrives with: no NANP area code
  // starts with a 1, so a leading 1 on eleven digits is +1 and nothing else.
  static digits(text) {
    const digits = text.replace(/\D/g, '')

    return digits.length > 10 && digits.startsWith('1') ? digits.slice(1, 11) : digits.slice(0, 10)
  }
}
