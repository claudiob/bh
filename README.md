# Bh · Bootstrap Helpers

Bootstrap 6 in a Rails app, with the markup already written.

Bootstrap is a fine framework that asks for a lot of HTML. Bh answers with a form builder that
dresses every field a page can ask for, helpers for the components Bootstrap ships behavior for
and no markup — a combobox, a 6-digit code, a dialog, a toast, a thread of messages — and the
one stylesheet and one script that carry them, served by the engine.

## How to install

```bash
gem install bh --pre
```

```ruby
# Gemfile
gem 'bh', '6.2.0.alpha'
```

Spelled out, because `~>` does not reach a prerelease: Bundler would pass over `6.2.0.alpha`
for the 6.1.4 standing behind it. Once a final 6.2 is cut the pin is `~> 6.2.0`, which stops
short of `6.3` — this line breaks on a minor rather than on a major, so a minor is what to
hold. Rails 8.1 and Ruby 3.2 are the minimum.

6.0 and 6.1 are a different gem wearing this name: Bootstrap 3 wrappers with a Bootstrap 6
stopgap over them, and not one of their helpers survives here. They could not be withdrawn —
RubyGems keeps anything published over thirty days ago — so pin on purpose.

With the gem in the bundle an app serves `/bh/css/bh.css` and `/bh/js/bh.js` itself, and has
every helper below in every view. Put the two in the head, along with everything Bootstrap and
Turbo read:

```erb
<%= bh_head_tags %>
```

Bh links no icon font of its own: which glyphs a page draws is the host's business, and a gem
reaching for somebody else's CDN unasked is not. A combobox's chevron and a bookmark's star are
Bootstrap Icons, so a page that wants them says where they come from:

```erb
<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css'>
```

### From npm

For a host that bundles the sources itself rather than serving the gem's built tree. The package
is `bh6`, since `bh` on npm is somebody else's.

```bash
npm install bh6
```

```js
import 'bh6'
import 'bh6/bh.css'
```

The module exports nothing and is imported for its effect: it starts Stimulus, registers every
controller the markup below names, and hands Turbo the dialog it draws for a confirmation.

Bootstrap 6 is not on npm, so the bundle ships inside this package and a bundler has to send the
bare `bootstrap` specifier there:

```js
// esbuild
alias: { bootstrap: 'bh6/bootstrap' }
```

A single controller comes from `bh6/controllers`, for a host registering its own Stimulus
application rather than taking this one:

```js
import OtpController from 'bh6/controllers/otp_controller.js'
```

## The form

Given to one form as `builder:`, or to every form of a controller through `default_form_builder`.
What a view passes is kept: its classes join the builder's, its `data` is merged key by key with
the builder's, and any other option of its overrides.

```ruby
class ApplicationController < ActionController::Base
  default_form_builder Bh::FormBuilder
end
```

```erb
<%= form.fieldset 'Your code' do %>
  <%= form.label :pin_confirmation, '6-digit code' %>
  <%= form.pin_field :pin_confirmation, required: true %>
  <%= form.label :phone, 'Mobile number' do %>
    <%= form.phone_field :phone %>
  <% end %>
  <%= form.submit 'Confirm' %>
  <%= form.button 'Call us', type: :button, disabled: true, title: 'Available soon' %>
<% end %>
```

`fieldset` is a one-column grid with a legend where one is given. A `label` is Bootstrap's
`form-label`; given both words and a block it wraps the control the words name, so a form laid
out in two columns has one cell to place rather than a pair to bind. `submit` and `button` are
the large pill — solid where they submit, outlined where `type: :button` says they do not — and a
disabled one given a `title` says why on hover, from a wrapper that hears the mouse for it.

`text_field`, `email_field`, `number_field`, `password_field`, `search_field`, `url_field`,
`date_field`, `time_field`, `datetime_field` and `text_area` are all large controls; `select` is
a large menu; `check_box` and `radio_button` wear `form-check-input`, and `check` draws a box with
its words beside it. A page says which kind of field it wants and nothing about how it looks.

Two fields Rails has none of:

- **`phone_field`** — a North American number, `555-555-5555`, shaped by the `phone` controller as
  it is typed and carrying the keyboard and autofill a phone offers for one. Storage stays ten
  bare digits; the shape is the browser's business.
- **`pin_field`** — one real field rendered by Bootstrap as six slots, digits only, offered by the
  phone from the text that brought it. Refused, the slots redden rather than a box around them.

## The components

```erb
<%# A `<select>` drawn as a searchable menu, which stays the one thing the form submits. Its
    `:prompt` is what the toggle says before anything is picked; every other argument is the
    select's. `multiple:` gives each row a check. %>
<%= form.combobox :county, County.pluck(:name, :id), { prompt: 'Pick a county' }, multiple: true %>

<%# A link and the dialog it opens: headed, with an X, holding the block, and closed by an
    `Okay` too (`okay:` words it otherwise, `okay: false` leaves it out). The two share an id
    made from the link's words; any other option is an attribute of the link. The browser's
    own element brings the backdrop, the focus trap and Esc — nothing is scripted. %>
<%= dialog 'I’m not on Google Business', title: 'Not a problem' do %>
  We will look your business up ourselves.
<% end %>

<%# What the flash says, as toasts at the bottom right: green for a notice, red for an alert,
    neutral for any other key; visible at first paint, gone after a moment or a click, held
    while read. A value in the flash that is not words is left alone. %>
<%= notices %>

<%# A thread of messages, newest at the foot, and — where `url` is given — the field that posts
    the next one there, suggesting `hints` one at a time. Any object answering `side`, `text`,
    `sender`, `at`, `delivery` and `cost` is a message; `Bh::Message` is for a host that has the
    facts and no model to hang them on. One with no text yet is drawn as being typed. %>
<%= chat_with url: questions_path, hints: Chat::HINTS, messages: messages %>

<%# The page of a signup flow: `header` over the title and line the view set in `content_for`,
    one card as wide as `:width` says, and the pieces of `footer` under it joined by a middot.
    Every other option is an attribute of the column, which is where a host names the controller
    that paints what the page stands on. %>
<%= flow header: logo, footer: [sign_out_button], data: { controller: 'wall' } do %>
  <%= yield %>
<% end %>
```

Two behaviors need no helper either, only an attribute. A `<select data-controller='combobox'>`
becomes the combobox above with no form builder in sight; `data-combobox-all-value` names an
`All` row on a multiple menu, `data-combobox-more-value` words the toggle when several are picked
(`%{first} + %{count} more`), and on an option `data-count` puts a figure beside it while
`data-hidden` holds it back until `All` asks.

And any link or form with `data-turbo-confirm` asks through a Bootstrap dialog the bundle draws
on the first ask: the first line of the message is the question, the rest are paragraphs, and the
answer wears the words of the button that asked. A host in another language names the other word
in `<meta name='bh-cancel'>`.

## The controllers

Registered by the bundle under these names, for markup to call by `data-controller`:

`bookmark` keeps a row and says so before the server does · `clear` empties a field ·
`combobox` draws the menu above · `density` puts a phone's sidebar into words or icons ·
`deselect` lets a picked radio be unpicked · `limit` sets how many rows a page shows ·
`map` draws a page of a table on a Google map · `otp` draws the six slots ·
`phone` shapes a number as it is typed · `placeholder` cycles a field's suggestions ·
`relative-time` keeps `3 minutes ago` true · `require` shuts a submit until the form is valid ·
`reveal` unmasks one value · `scheme` moves a page between palettes ·
`search` survives the visit a submit starts · `shortcuts` binds Option to the page's own keys ·
`sortable` drags a row into another place · `thread` opens a chat at its newest ·
`timezone` tells the server the reader's zone · `toast` hides a notice, held while it is read ·
`tooltip` names an icon-only heading · `written` marks the row a write just landed on.

## Trying it out

The gem carries a dummy app that draws every helper on one page. From the root of a clone:

```bash
bin/setup
rails s
```

`http://localhost:3000` is every component at once, `?flash=1` adds the toasts, and
`http://localhost:3000/flow` is the signup page.
