import { Controller } from '@hotwired/stimulus'

// The arrows at the foot of the sidebar, drawn on a phone alone: a tap puts the words
// back beside every icon the chrome shows — the sidebar's entries, the crumbs, the tabs,
// the foot's own controls — and the next tap takes them away again. The choice goes to
// the server in a cookie, the way the zone does, and the page is loaded again outright
// rather than reshaped in place: Safari left the row of entries where it was when the
// words came out of hiding, one link over the next, until a reload laid it out afresh.
// A Turbo visit to the same address is no better — an index carries the metas that make
// a refresh morph, so the visit reshaped the body it had rather than drawing a new one.
export default class extends Controller {
  static values = { storage: String }

  toggle() {
    const expanded = document.body.classList.contains('recourse-expanded')
    const density = expanded ? 'compact' : 'expanded'

    document.cookie = `${this.storageValue}=${density}; path=/; max-age=31536000; samesite=lax`
    window.location.reload()
  }
}
