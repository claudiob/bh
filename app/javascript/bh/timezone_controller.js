import { Controller } from '@hotwired/stimulus'

// The reader's own zone, told to the server so it can draw their pages against their
// clock. A cookie rather than local storage, for the reason the page size uses one:
// the server does the converting, and a cookie is the only storage the server is sent.
export default class extends Controller {
  static values = { storage: String }

  // The page in front of the reader was drawn before this cookie existed, so the first
  // visit from a browser — and the first after they travel — is drawn against the
  // host's zone and then asked for again. Only when the cookie disagrees, so every
  // other visit costs nothing: this writes what is already there and stops.
  connect() {
    const zone = Intl.DateTimeFormat().resolvedOptions().timeZone
    if (!zone || zone === this.#stored()) { return }

    document.cookie =
      `${this.storageValue}=${encodeURIComponent(zone)}; path=/; max-age=31536000; samesite=lax`
    window.Turbo.visit(window.location.href, { action: 'replace' })
  }

  #stored() {
    const row = document.cookie.split(/;\s*/).find((one) => one.startsWith(`${this.storageValue}=`))

    return row ? decodeURIComponent(row.split('=')[1]) : null
  }
}
