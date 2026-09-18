import { Controller } from '@hotwired/stimulus'
import { Combobox } from 'bootstrap'
import { menuFor } from './combobox/menu.js'

// A `<select data-controller='combobox'>` becomes Bootstrap's combobox: a toggle that reads
// the picked option, a menu with a search box, and a check per pick where the select is
// `multiple`. The select stays, hidden, as the one thing the form submits — the plugin is
// told no `name`, so it writes no hidden input of its own — and every pick in the menu is
// written back to it and announced as the select's own `change`. A page without this
// script has a working select; a page with it has the same select dressed.
//
// A multiple menu reads as `California + 1 more` rather than the plugin's `2 selected`,
// in the words `data-combobox-more-value` gives it. The select's own `data-` attributes
// say the rest: a placeholder for the toggle, an `All` row that puts held-back options on
// the menu, and on an option `data-count` for a figure beside it and `data-hidden` to hold
// it back until `All` asks.
export default class extends Controller {
  static values = { more: String, placeholder: String, all: String }

  connect() {
    this.#dress()
    this.morphed = () => this.#remake()
    document.addEventListener('turbo:morph', this.morphed)
  }

  disconnect() {
    document.removeEventListener('turbo:morph', this.morphed)
    this.#undress()
  }

  #dress() {
    this.widget = menuFor(this.element, this)
    this.element.after(...this.widget)
    this.element.hidden = true
    this.combobox = Combobox.getOrCreateInstance(this.toggle)
    this.#name()
    this.picked = () => this.#pick()
    this.toggle.addEventListener('change.bs.combobox', this.picked)
  }

  #undress() {
    this.toggle.removeEventListener('change.bs.combobox', this.picked)
    this.combobox.dispose()
    this.widget.forEach((node) => node.remove())
    this.element.hidden = false
  }

  get toggle() { return this.widget[0] }

  get menu() { return this.widget[1] }

  // Remade whole rather than repaired: a morph rewrote the select's options and what is
  // selected among them, and a widget built from it again is the one way to be sure the
  // toggle's text, the menu's ticks and the plugin's state all say the same thing.
  #remake() {
    if (!this.element.isConnected) { return }

    this.#undress()
    this.#dress()
  }

  // What the menu says, written onto the select, and said again as the select's own event
  // so a form listening for a change hears one — the plugin's event never leaves the toggle.
  #pick() {
    const picked = new Set([...this.menu.querySelectorAll('.menu-item.selected')].map((item) => item.dataset.bsValue))
    for (const option of this.element.options) { option.selected = picked.has(option.value) }
    this.#name()
    this.element.dispatchEvent(new Event('change', { bubbles: true }))
  }

  // `California + 1 more` over the plugin's `2 selected`. Only a multiple menu with more
  // than one pick: with one the plugin names it, and with none it shows the placeholder.
  #name() {
    const picked = this.menu.querySelectorAll('.menu-item.selected')
    if (!this.element.multiple || picked.length < 2) { return }

    const first = picked[0].querySelector('.menu-item-content > span:first-child')
    this.toggle.querySelector('.combobox-value').textContent = this.moreValue
      .replace('%{first}', first.textContent)
      .replace('%{count}', picked.length - 1)
  }
}
