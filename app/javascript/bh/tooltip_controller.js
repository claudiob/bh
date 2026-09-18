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
export default class extends Controller {
  connect() {
    if (matchMedia('(hover: none), (pointer: coarse)').matches) return

    this.tooltip = Tooltip.getOrCreateInstance(this.element)
  }

  disconnect() {
    this.tooltip?.dispose()
  }
}
