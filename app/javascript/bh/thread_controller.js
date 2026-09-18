import { Controller } from '@hotwired/stimulus'

// A thread opens at its newest message with the field ready, and stays at the newest as
// answers arrive. Every render undoes both -- `autofocus` included, which is why sending a
// question landed back here with nothing focused -- so it is said again on each one rather
// than only when Stimulus connects, which a morphed-in answer never triggers.
//
// The field itself Turbo is told to leave alone, since an answer landing morphs the page and
// the server's empty box would be written over a question half typed. Nothing else then
// empties it, so this does, once the question it held has actually gone.
export default class extends Controller {
  static targets = ['messages', 'field']

  connect() {
    this.following = true
    this.follow = () => { this.following = this.#atBottom() }
    this.settle = () => requestAnimationFrame(() => this.#settle())
    this.empty = () => { if (this.hasFieldTarget) { this.fieldTarget.value = '' } }

    if (this.hasMessagesTarget) { this.messagesTarget.addEventListener('scroll', this.follow) }
    document.addEventListener('turbo:render', this.settle)
    this.element.addEventListener('turbo:submit-end', this.empty)
    this.settle()
  }

  disconnect() {
    if (this.hasMessagesTarget) { this.messagesTarget.removeEventListener('scroll', this.follow) }
    document.removeEventListener('turbo:render', this.settle)
    this.element.removeEventListener('turbo:submit-end', this.empty)
  }

  // Left where the reader put it once they have scrolled up to read back: an answer landing is
  // no reason to pull the thread out from under them. The field takes focus without the page
  // scrolling to it: a chat below the fold, the showcase's say, must not drag the page down
  // on load, and a chat page is sized to the window, so there the field is in view already.
  #settle() {
    if (this.hasFieldTarget) { this.fieldTarget.focus({ preventScroll: true }) }
    if (this.hasMessagesTarget && this.following) {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }
  }

  #atBottom() {
    const { scrollTop, scrollHeight, clientHeight } = this.messagesTarget
    return scrollHeight - scrollTop - clientHeight < 24
  }
}
