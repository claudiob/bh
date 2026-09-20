// The markup Bootstrap's combobox wants, built from a `<select>`: the toggle and the menu,
// as the two nodes to put after it. Every word on them comes from the select or its
// controller's values, so nothing here is in any one language.

// The toggle takes the select's size and its error, and is labelled the way the select was.
export function menuFor(select, controller) {
  const toggle = element('button', 'form-control combobox-toggle', { type: 'button' })
  if (select.classList.contains('form-select-sm')) { toggle.classList.add('form-control-sm') }
  if (select.classList.contains('is-invalid')) { toggle.classList.add('is-invalid') }
  toggle.dataset.bsToggle = 'combobox'
  toggle.dataset.bsSearch = 'true'
  toggle.dataset.bsPlaceholder = controller.placeholderValue
  if (select.multiple) { toggle.dataset.bsMultiple = 'true' }
  if (select.required) { toggle.setAttribute('aria-required', 'true') }
  labelled(toggle, select)
  toggle.append(element('span', 'combobox-value', {}, controller.placeholderValue),
                element('i', 'bi bi-chevron-down combobox-caret'))

  return [toggle, menu(select, controller)]
}

// The label that pointed at the select points at what a reader now clicks instead.
function labelled(toggle, select) {
  const label = select.id && document.querySelector(`label[for='${select.id}']`)
  if (label) { toggle.setAttribute('aria-labelledby', label.id ||= `${select.id}-label`) }
  for (const name of ['aria-label', 'aria-describedby']) {
    if (select.hasAttribute(name)) { toggle.setAttribute(name, select.getAttribute(name)) }
  }
}

function menu(select, controller) {
  const menu = element('div', 'menu')
  menu.append(search(select))
  if (controller.hasAllValue && select.multiple) { menu.append(all(select, controller.allValue), element('div', 'menu-divider')) }
  for (const option of select.options) { menu.append(item(option, select.multiple)) }
  menu.append(element('div', 'combobox-no-results d-none', {}, select.dataset.noResults || ''))

  return menu
}

// The box that narrows a long menu, with the X that empties it inside the field. It takes
// an id and no name: a field with neither is one a browser says it cannot offer to fill,
// and a name would submit a box that narrows a menu rather than asking the server anything.
let searches = 0

function search(select) {
  const box = element('div', 'combobox-search')
  box.dataset.controller = 'clear'
  const input = element('input', 'form-control combobox-search-input', {
    id: select.id ? `${select.id}-search` : `combobox-search-${++searches}`,
    type: 'text', autocomplete: 'off',
    placeholder: select.dataset.search || '', 'aria-label': select.dataset.search || '',
  })
  input.dataset.clearTarget = 'input'
  input.dataset.action = 'input->clear#toggle'
  const clear = element('button', 'combobox-search-clear d-none', { type: 'button', 'aria-label': select.dataset.clear || '' })
  clear.dataset.clearTarget = 'button'
  clear.dataset.action = 'clear#clear'
  clear.append(element('i', 'bi bi-x-lg'))
  box.append(input, clear)

  return box
}

// `All`: no `data-bs-value`, so the plugin passes it by and the deselect controller has it.
function all(select, words) {
  const row = element('button', 'menu-item', { type: 'button' }, words)
  row.dataset.controller = 'deselect'
  row.dataset.action = 'deselect#all'
  row.dataset.deselectMultipleValue = String(select.multiple)

  return row
}

// One option as one row: its words, a figure beside them where it has one, a check where
// the menu is multiple, and `d-none` where it waits for `All`. An empty option is the way
// back to nothing, and takes the plugin's own empty value.
function item(option, multiple) {
  const row = element('button', 'menu-item', { type: 'button', 'aria-selected': String(option.selected) })
  row.dataset.bsValue = option.value
  if (option.selected) { row.classList.add('selected') }
  if ('hidden' in option.dataset && !option.selected) { row.classList.add('d-none') }
  const content = element('span', 'menu-item-content')
  content.append(element('span', '', {}, option.textContent))
  row.append(content)
  if (option.dataset.count) { row.append(element('span', 'combobox-count fg-2', {}, option.dataset.count)) }
  if (multiple) { row.append(element('i', 'bi bi-check menu-item-check')) }

  return row
}

function element(tag, classes, attributes = {}, text = null) {
  const node = document.createElement(tag)
  if (classes) { node.className = classes }
  for (const [name, value] of Object.entries(attributes)) { node.setAttribute(name, value) }
  if (text !== null) { node.textContent = text }

  return node
}
