import { Controller } from '@hotwired/stimulus'

// How much of a table one page shows. The choice belongs to the reader rather than
// to the app, so it is kept in their browser — but in a cookie rather than in local
// storage, which is where the scheme goes: pagy decides the page on the server, and
// a cookie is the only storage the server is sent.
export default class extends Controller {
  static values = { storage: String, to: Number }

  // Back to the first page, always: page five of twenty is past the end of a hundred
  // to a page, and pagy answers that with an empty table rather than an error. And
  // only the frame, so what is redrawn is the table and the row under it — the answer
  // brings the button back naming the size a click would go to next.
  toggle() {
    document.cookie =
      `${this.storageValue}=${this.toValue}; path=/; max-age=31536000; samesite=lax`

    const url = new URL(window.location.href)
    url.searchParams.delete('page')

    window.Turbo.visit(url.href, { frame: 'results', action: 'replace' })
  }
}
