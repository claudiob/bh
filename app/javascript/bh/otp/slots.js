import { OtpInput } from 'bootstrap'

// Draws the six slots over the one real field and returns the plugin's instance. A page
// restored from history comes back with the slots still in it, and a re-render can leave a
// connected controller holding an instance whose slots have been deleted underneath it — so
// neither the markup nor the instance is trusted, only taken down and drawn again.
export function drawSlots(element, field) {
  OtpInput.getInstance(element)?.dispose()
  element.querySelector('.otp-slots')?.remove()
  element.classList.remove('otp-rendered')
  const otp = new OtpInput(element)

  // A refused code comes back in the field, the way any invalid field keeps what was typed —
  // but a re-render leaves nothing focused, so backspace and a new digit went nowhere.
  // Focused with the caret past the last digit, fixing a typo is one keystroke.
  if (field.value) {
    field.focus()
    field.setSelectionRange(field.value.length, field.value.length)
  }

  // The plugin rewrites `pattern` to `[0-9]*` from its own type, and `minlength` cannot stand
  // in: the browser enforces tooShort only on a value a person edited, and this plugin writes
  // every value programmatically. Restoring the exact length is what keeps the submit shut
  // until all six digits are in rather than after the first.
  field.pattern = '[0-9]{6}'
  return otp
}
