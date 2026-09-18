import { Controller } from '@hotwired/stimulus'
import { Toast } from 'bootstrap'
import { DELAY } from './written.js'

// The toast arrives from the server already shown, so Bootstrap's show() must never
// run: it re-adds `showing` and blinks the toast through transparent. But show() is
// also the only place Bootstrap arms its autohide, so the timer lives here instead,
// and only the hiding is Bootstrap's — the timed hide and the dismiss X then share
// one code path and one fade.
export default class extends Controller {
  static values = { delay: { type: Number, default: DELAY } }

  connect() {
    // `autohide: false` keeps Bootstrap from arming a rival timer if anything ever
    // does call show() on this element.
    this.toast = Toast.getOrCreateInstance(this.element, { autohide: false })
    this.startTimer()
  }

  disconnect() {
    this.stopTimer()
    this.toast.dispose()
  }

  // Reading the message, or aiming for the X, holds the toast open — Bootstrap's
  // own pause-on-hover only guards the timer *it* armed, so it is redone here.
  stopTimer() {
    clearTimeout(this.timeout)
  }

  // A fresh full delay on leave, which is also what Bootstrap re-arms.
  startTimer() {
    this.timeout = setTimeout(() => this.toast.hide(), this.delayValue)
  }
}
