import { Controller } from '@hotwired/stimulus'
import { drawSlots } from './otp/slots.js'

// Draws Bootstrap's OTP input: one real field rendered as six slots. Bootstrap initializes
// it on DOMContentLoaded, which a Turbo visit never fires — and a verification page is only
// ever reached by one, so without this the reader is left with an empty box.
export default class extends Controller {
  connect() {
    // Says the slots are coming, which is what lets the stylesheet hold back the bare field.
    this.element.classList.add('otp-drawing')
    this.pasted = false

    this.draw = () => {
      if (!this.element.isConnected) { return }

      this.otp = drawSlots(this.element, this.field)
    }

    // A keystroke past the sixth is one iOS cannot place, and it answers by selecting inside
    // the real field rather than by doing nothing. That field's text and caret are both
    // transparent, but a selection is not its to hide: iOS draws the grab handles itself, and
    // the hidden text they follow lies crammed against the left edge rather than under the
    // slots — so a bar surfaces inside the first one. Collapsed to the end there is nothing
    // left to draw, and only once the code is whole, so selecting to replace a half-typed one
    // still works.
    this.collapse = () => {
      if (document.activeElement !== this.field) { return }
      const { value, selectionStart, selectionEnd } = this.field
      if (value.length < 6 || selectionStart === selectionEnd) { return }

      this.field.setSelectionRange(value.length, value.length)
    }

    // The plugin cancels every `beforeinput` and writes the value itself, so typing a code
    // fires no `input` on the field at all — only its own `input.bs.otpInput`, which leaves
    // everything watching the field behind, the submit gating included. Say it again in the
    // language the page speaks, guarded, since the plugin answers `input` with another.
    this.relay = () => {
      if (this.relaying) { return }
      this.relaying = true
      this.field.dispatchEvent(new Event('input', { bubbles: true }))
      this.relaying = false
    }

    // A pasted code is a whole code, so there is nothing left to confirm: send it. A typed
    // one is not, because the sixth digit may be a typo the typist is about to fix. Emptied
    // first, or a code pasted over six already there is dropped: the field is full and
    // `maxlength` has nowhere to put the new one.
    this.remember = () => {
      this.pasted = true
      this.field.value = ''
    }
    this.forget = (event) => { if (/^[0-9]$/.test(event.key)) { this.pasted = false } }
    this.send = () => {
      if (!this.pasted) { return }

      this.pasted = false
      this.submit()
    }

    this.submit = () => this.element.closest('form')?.requestSubmit()

    // A code that arrives without a keystroke — iOS offering it from Messages, or any other
    // autofill — is written straight into the field, which fires a native `input`; typing
    // never does. So this is either the relay above or a whole code that appeared, and the
    // slots have to be told. `keyup` is one of the three events the plugin re-reads the field
    // on, and it re-reads in place: redrawing takes the row of six down and puts it back up,
    // which is the shrink with the bare field showing yellow underneath. And the plugin
    // announces completeness only for input it handled, so a code that landed this way is
    // sent from here as a pasted one is — tapping the suggestion is the confirmation.
    this.adopt = () => {
      if (this.relaying) { return }

      this.field.dispatchEvent(new Event('keyup', { bubbles: true }))
      if (this.field.checkValidity()) { this.submit() }
    }

    this.listeners = [['input', this.adopt], ['input.bs.otpInput', this.relay],
      ['paste', this.remember], ['keydown', this.forget], ['complete.bs.otpInput', this.send]]
    for (const [name, on] of this.listeners) { this.element.addEventListener(name, on) }
    this.draw()
    // A refused code comes back as a re-render that can leave this controller untouched, so
    // the drawing is redone whenever Turbo renders rather than only when Stimulus connects.
    document.addEventListener('turbo:render', this.draw)
    // On the document rather than the field: iOS reports a selection it made itself here.
    document.addEventListener('selectionchange', this.collapse)
  }

  disconnect() {
    document.removeEventListener('turbo:render', this.draw)
    document.removeEventListener('selectionchange', this.collapse)
    for (const [name, on] of this.listeners) { this.element.removeEventListener(name, on) }
    this.otp?.dispose()
  }

  // The one real field the six slots are drawn over, and the only thing that holds the code.
  get field() { return this.element.querySelector('.otp-input') }
}
