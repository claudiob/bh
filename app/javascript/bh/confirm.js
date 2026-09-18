import { Dialog } from 'bootstrap'

// Turbo hands over the whole warning as one string, and the element and the button that
// asked. The first line is the question and each remaining line a paragraph — real
// paragraphs here, where a confirm() box had newlines. Always textContent, never
// innerHTML: the title carries a record's own name, and a name is data. The dialog is
// built the first time a page asks, so any page loading this bundle has one.
export default function confirm(message, element, submitter) {
  const dialog = dialogFor()
  const [title, ...lines] = message.split('\n')
  const body = dialog.querySelector('.dialog-body')
  dialog.querySelector('.dialog-title').textContent = title
  body.replaceChildren(...paragraphs(lines))
  body.hidden = !body.children.length
  const answer = dialog.querySelector('.bh-confirm-answer')
  answer.textContent = wordsOn(submitter, element) || 'OK'

  return new Promise(resolve => {
    // `onclick` rather than addEventListener: reassigning replaces the previous
    // answer's handler, so asking twice on one page never wires the button twice.
    answer.onclick = () => {
      resolve(true)
      Dialog.getOrCreateInstance(dialog).hide()
    }
    // Cancel, Esc and a click on the backdrop all close through here. After an
    // answer the promise is settled, and settling it again is a no-op.
    dialog.addEventListener('hidden.bs.dialog', () => resolve(false), { once: true })
    Dialog.getOrCreateInstance(dialog).show()
  })
}

// The answer is the very words of the button that asked — `Delete place` — so the dialog
// never has to know what the page is about, nor in which language. A link with a method
// arrives as the hidden form Turbo built for it, with no submitter and nothing to read.
function wordsOn(submitter, element) {
  const form = element?.tagName === 'FORM'
  const source = submitter || (form ? element.querySelector('[type=submit]') || asked : element)

  return source?.textContent?.trim() || source?.value
}

// The element a warning was asked from, remembered on the way down so it is there a frame
// later when Turbo submits. Focus cannot answer this: Safari does not focus a link it
// follows, so `document.activeElement` is `<body>` on an iPhone — and `<body>` reads back
// the text of the whole page, which the answer button then wore.
let asked = null

document.addEventListener('click', ({ target }) => {
  asked = target.closest?.('[data-turbo-confirm]') || null
}, true)

function paragraphs(lines) {
  return lines.filter(line => line).map(line => {
    const paragraph = document.createElement('p')
    paragraph.textContent = line
    return paragraph
  })
}

// The one dialog every warning on a page speaks through, made on the first ask. Cancel
// keeps the focus on the safe answer: `showModal` gives it to `autofocus` first.
// `dialog-slide-down` is the animation, shipped by Bootstrap 6.
function dialogFor() {
  let dialog = document.querySelector('#bh-confirm')
  if (dialog) { return dialog }

  dialog = document.createElement('dialog')
  dialog.className = 'dialog dialog-slide-down'
  dialog.id = 'bh-confirm'
  dialog.setAttribute('aria-labelledby', 'bh-confirm-title')
  dialog.innerHTML = `
    <div class='dialog-header'><h1 class='dialog-title' id='bh-confirm-title'></h1></div>
    <div class='dialog-body'></div>
    <div class='dialog-footer'>
      <button type='button' class='btn btn-solid theme-secondary' data-bs-dismiss='dialog' autofocus>${cancel()}</button>
      <button type='button' class='btn btn-solid theme-danger bh-confirm-answer'></button>
    </div>`
  document.body.append(dialog)

  return dialog
}

// The one word the page cannot supply, in the page's own language where a host has said
// it in a `<meta name='bh-cancel'>`, and English otherwise.
function cancel() {
  return document.querySelector('meta[name="bh-cancel"]')?.content || 'Cancel'
}

// Three things outlive a Turbo visit that starts mid-close: the snapshot, which would
// restore an open dialog; `dialog-open` on <html>, which is the scroll lock; and
// `hiding` on the dialog, the class its closing animation runs under. dispose() closes
// instantly and lifts the lock, but cuts the animation short of the end that would
// have taken `hiding` off — and a dialog still wearing it opens invisible the next
// time it is asked, which on a table of Remove buttons is the very next click. In the
// module, so it registers once.
document.addEventListener('turbo:before-cache', () => {
  const dialog = document.querySelector('#bh-confirm')
  if (dialog?.open) Dialog.getOrCreateInstance(dialog).dispose()
  dialog?.classList.remove('hiding')
})
