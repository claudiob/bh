import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { multiple: Boolean }

  // `All` asks for the options the menu is holding back — they are in it already, and
  // this is what puts them on it.
  all(event) {
    // A menu that sets a value is configured to close on any click inside it, this
    // button included — which would shut it over the options it was clicked to see. The
    // listener doing that is on the document, so stopping the click here is what keeps
    // them in view. A menu that narrows a table closes on outside clicks only, and is
    // unaffected either way.
    event.stopPropagation()

    const menu = this.element.closest('.menu')

    for (const waiting of menu.querySelectorAll('.menu-item.d-none')) {
      waiting.classList.remove('d-none')
    }

    // And, on a menu that narrows a table, it means every row as well as every option,
    // which is what nothing being ticked says. Clicking each chosen item is what the
    // plugin is already listening for, so the hidden input, the toggle's text and the
    // events stay its business rather than ours — it has no method for this, and
    // reaching into its state would be guessing.
    //
    // Only there. A menu that sets a value cannot mean none of them, and a click on the
    // one already chosen is the plugin being told to choose it again — which closes the
    // menu over the options this button was clicked to see.
    if (!this.multipleValue) return

    for (const item of menu.querySelectorAll('.menu-item.selected')) {
      item.click()
    }
  }
}
