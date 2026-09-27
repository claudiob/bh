import { Controller } from '@hotwired/stimulus'
import { Tooltip } from 'bootstrap'

// The tooltip naming an icon-only heading. Bootstrap never wires one on its own,
// and a Stimulus lifecycle is what survives Turbo redrawing the table: connect
// makes it, disconnect takes it down before the element goes, so a sorted or
// searched table never strands one over an element that left.
//
// None where nothing can hover: on a touch screen the tap that would open a link
// is also what shows a tooltip, and a word popping up over a tap reads as a hitch.
// Asked two ways, since an iPhone answered the first with a tooltip all the same: a
// screen that cannot hover, or a pointer too coarse to rest on one word of a row.
//
// Closed by a click on the icon or on whatever holds it, a button or a link: what a click
// does may take the icon away — the sidebar's moon and sun swap places, a sorted heading
// is drawn again — and a tooltip whose icon is gone from under the pointer sees no mouse
// leave, stays open, and is put by Popper wherever a hidden element is: the page's corner.
// In the capture phase, so it closes before the click's own action changes the page.
export default class extends Controller {
  connect() {
    if (matchMedia('(hover: none), (pointer: coarse)').matches) return

    this.tooltip = Tooltip.getOrCreateInstance(this.element)
    this.holder = this.element.closest('button, a') || this.element
    this.close = () => this.tooltip.hide()
    this.holder.addEventListener('click', this.close, true)
  }

  disconnect() {
    this.holder?.removeEventListener('click', this.close, true)
    this.tooltip?.dispose()
  }
}
