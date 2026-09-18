import { Controller } from '@hotwired/stimulus'

// Cycles a field's own suggestion, so the placeholder reads as an invitation rather than as
// one fixed example. Somebody who has started typing is left alone.
export default class extends Controller {
  static values = { questions: Array, every: { type: Number, default: 10000 } }

  connect() {
    this.index = 0
    this.timer = setInterval(() => this.#cycle(), this.everyValue)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  // The class fades the placeholder out; the text is swapped while it cannot be seen.
  #cycle() {
    if (this.element.value) { return }

    this.element.classList.add('is-fading')
    setTimeout(() => {
      this.index = (this.index + 1) % this.questionsValue.length
      this.element.placeholder = this.questionsValue[this.index]
      this.element.classList.remove('is-fading')
    }, 300)
  }
}
