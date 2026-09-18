import { Controller } from '@hotwired/stimulus'

// The sidebar's one control over how a page looks. A click moves it to another palette
// and into the mode it is not in, which is what the icon promises: a moon while the page
// is light, a sun while it is dark. The choice belongs to the reader rather than to the
// app, so it is kept in their browser — the layout's own script is what puts it back
// before the first paint, a controller connecting far too late for that.
export default class extends Controller {
  static values = { themes: Array, path: String, storage: String }

  // Turbo merges the head on a visit, which puts the palette the server chose back over
  // the one the reader picked, and the layout's script runs only on a full load. The
  // sidebar is drawn again on every visit, so connecting is the moment to say it again.
  connect() {
    const stored = this.#stored()

    if (stored) { this.#apply(stored.theme, stored.mode) }
  }

  // Another palette, in the other mode. Random rather than in order: the eight have no
  // order that means anything. Excluding the one showing is what stops a click looking
  // like it did nothing, which is the whole risk of picking at random.
  rotate() {
    const mode = this.#mode() === 'dark' ? 'light' : 'dark'
    const others = this.themesValue.filter((theme) => theme !== this.#theme())
    const theme = others[Math.floor(Math.random() * others.length)]

    this.#apply(theme, mode)
    localStorage.setItem(this.storageValue, JSON.stringify({ theme, mode }))
  }

  // The mode onto the element every `light-dark()` on the page is resolved against, and
  // the palette onto the one link that serves one. A name is checked against the list
  // the server sent: the storage is the reader's own, but what comes back out of it is
  // still not something to put in a URL unread.
  #apply(theme, mode) {
    if (mode === 'light' || mode === 'dark') {
      document.documentElement.dataset.bsTheme = mode
    }
    if (!this.themesValue.includes(theme)) { return }

    this.#link().href = `${this.pathValue}/${theme}.css`
  }

  // What the reader picked last, or nothing at all where they never have.
  #stored() {
    try {
      return JSON.parse(localStorage.getItem(this.storageValue))
    } catch (error) {
      return null
    }
  }

  // Which mode the page is in: whatever has been forced onto it, and otherwise whatever
  // the system asks for, since a page nobody has chosen for follows that.
  #mode() {
    return document.documentElement.dataset.bsTheme ||
      (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
  }

  // Which palette is showing, read off the link rather than remembered, so a reader who
  // cleared their storage still moves on from the one in front of them.
  #theme() {
    const link = this.#current()

    return link ? link.href.split('/').pop().replace('.css', '') : null
  }

  // The palette the page is drawn in, which is the *last* of these links rather than the
  // first. Turbo's head merge appends a stylesheet the new head has and the old one does
  // not — it never replaces one — and the server names the same palette on every page,
  // so a visit made after the reader chose leaves two links and the browser obeys the
  // one at the end. Writing to the other would change nothing anybody can see.
  #current() {
    const links = document.querySelectorAll('link[data-recourse-theme]')

    return links[links.length - 1]
  }

  // The one link a palette is served through: whichever is in force, with any the merge
  // left behind it taken away, and a new one where a host named no palette at all and
  // there is none in the head to find.
  #link() {
    const links = [...document.querySelectorAll('link[data-recourse-theme]')]
    const link = links.pop() || this.#appended()
    links.forEach((stale) => stale.remove())

    return link
  }

  #appended() {
    const link = document.createElement('link')
    link.rel = 'stylesheet'
    link.dataset.recourseTheme = ''
    document.head.appendChild(link)

    return link
  }
}
