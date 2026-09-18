import { Controller } from '@hotwired/stimulus'

// Survives the visit that a submit starts, since the module is not reloaded with
// the page: it is how the next controller knows the search box was being typed in.
// Only a submit that replaces the whole page needs it — a frame leaves the form,
// and the caret in it, exactly where they were.
let typing = false

export default class extends Controller {
  static targets = ['field']

  connect() {
    // Not on a cached preview: the real render connects a second time, and it is
    // the one whose field can still be typed into.
    if (typing && !document.documentElement.hasAttribute('data-turbo-preview')) {
      typing = false
      this.#restore()
    }

    // A pick in a combobox is written to its select and said as the select's own
    // `change`, which bubbles, so one listener on the form hears every menu in it and
    // each tick or untick narrows the table straight away. Coalesced to the end of the
    // turn, because emptying a filter unticks every option in it — one request for the
    // table that leaves, not one per option.
    this.picked = () => {
      clearTimeout(this.pick)
      this.pick = setTimeout(() => this.#submit(), 0)
    }
    this.element.addEventListener('change', this.picked)

    // The frame is not inside the form, so its events never reach it.
    this.reloaded = () => { typing = false; this.#syncSort() }
    document.addEventListener('turbo:frame-load', this.reloaded)

    // A refresh morph would write the fetched page's older query over what is
    // mid-typing, so the form's subtree sits a morph out — the text, the caret
    // and any open filter menu stay. Only a morph: a page visit still renders
    // every page's own form, which `turbo-permanent` here would carry across.
    this.morphing = (event) => { if (this.element.contains(event.target)) event.preventDefault() }
    document.addEventListener('turbo:before-morph-element', this.morphing)
  }

  disconnect() {
    this.element.removeEventListener('change', this.picked)
    document.removeEventListener('turbo:frame-load', this.reloaded)
    document.removeEventListener('turbo:before-morph-element', this.morphing)
    clearTimeout(this.timer)
    clearTimeout(this.pick)
  }

  submit() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => { typing = true; this.#submit() }, 300)
  }

  #submit() {
    this.element.requestSubmit()
  }

  // A heading sorts by navigating the frame, which advances the address bar but
  // leaves this form alone — so the sort it carries has to be read back off the URL,
  // or the next search would reorder the table by whatever was in force before.
  #syncSort() {
    const field = this.element.querySelector('input[name="q[s]"]')

    if (field) { field.value = new URL(window.location.href).searchParams.get('q[s]') || '' }
  }

  // The value comes back from the server, so only the caret has to be put back,
  // and at the end of it — typing carries on where it left off.
  #restore() {
    if (!this.hasFieldTarget) { return }

    const field = this.fieldTarget
    field.focus({ preventScroll: true })
    field.setSelectionRange(field.value.length, field.value.length)
  }
}
