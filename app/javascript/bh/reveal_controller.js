import { Controller } from '@hotwired/stimulus'

// One masked value and the click that unmasks it. The plaintext arrives with the
// page rather than being fetched: the mask is against a screenshot, not against
// whoever is already reading the record.
export default class extends Controller {
  static targets = ['mask', 'button']
  static values = { plain: String }

  show() {
    this.maskTarget.textContent = this.plainValue
    // Nothing left for it to do, and a link that reveals what is already revealed
    // reads as though there were more to see.
    this.buttonTarget.remove()
  }
}
