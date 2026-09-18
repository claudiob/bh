// The mark a create or an update leaves on the row it landed on, and how long the toast
// saying so stands — the one clock, which the toast controller reads too.
export const DELAY = 2000

// Marked, and handed back the way to let it go. Letting go swaps one class for the
// other rather than adding to it: the fade is an animation, and while the first class
// is still on the row it would paint the tint straight back the moment that animation
// ended. Off the row entirely, what paints it afterwards is whatever else the cascade
// says — the tint of a kept row, or nothing.
export function mark(row) {
  if (!row) { return () => {} }

  row.classList.remove('recourse-written-out')
  row.classList.add('recourse-written')

  return () => {
    row.classList.remove('recourse-written')
    row.classList.add('recourse-written-out')
  }
}
