# Bh · Bootstrap Helpers

**Bootstrap 6 in a Rails app, with the markup already written.**

[![Every component Bh draws, on one page](screenshot/page.jpg)](https://claudiob.github.io/bh/)

<p align='center'>
  <a href='https://claudiob.github.io/bh/'><strong>Every component, drawn and explained&nbsp;→</strong></a>
</p>

Bootstrap is a fine framework that asks for a lot of HTML. Bh answers with a form builder that
dresses every field a page can ask for, helpers for the components Bootstrap ships behavior for
and no markup — a combobox, a 6-digit code, a dialog, a toast, a thread of messages — and the
one stylesheet and one script that carry them, served by the engine.

## How to install

```bash
gem install bh
```

```ruby
# Gemfile
gem 'bh', '~> 6.2.0'
```

`~> 6.2.0` stops short of `6.3`, and that is the pin to hold: **until this line settles it
breaks on a minor, not on a major.** Rails 8.1 and Ruby 3.2 are the minimum.

6.2.0 breaks everything before it and keeps its major anyway. 6.0 through 6.1.4 were an alpha
in everything but the number — Bootstrap 3 wrappers with a Bootstrap 6 stopgap bolted on, cut
while Bootstrap 6 was itself pre-release — so there was no settled API to break. Those numbers
are taken and cannot be withdrawn, RubyGems keeping anything published over thirty days ago, so
this release steps over them.

With the gem in the bundle an app serves `/bh/css/bh.css` and `/bh/js/bh.js` itself. One helper
puts both in the head, along with everything Bootstrap and Turbo read:

```erb
<%= bh_head_tags %>
```

## What you get

```ruby
class ApplicationController < ActionController::Base
  default_form_builder Bh::FormBuilder
end
```

| | |
| --- | --- |
| `fieldset` `label` `submit` `button` | the form's furniture, with the pill Bootstrap draws |
| every `*_field`, `text_area`, `select`, `check` | dressed at one size, so a view says which kind and nothing about how it looks |
| `phone_field` | a North American number, shaped `555-555-5555` as it is typed |
| `pin_field` | one real field drawn as six slots, offered by the phone from the text that brought it |
| `combobox` | a `<select>` drawn as a searchable menu, still the one thing the form submits |
| `dialog` | a link and the `<dialog>` it opens, sharing an id made from the link's own words |
| `notices` | the flash as toasts, held while they are read |
| `chat_with` | a thread of bubbles, and the field that posts the next one |
| `flow` | the page of a signup flow: a header, a title, one card, a footer |
| 22 Stimulus controllers | registered by the bundle, called by `data-controller` |

The page above draws every one of them beside the line of Ruby that produces it.

## Trying it out

The gem carries a dummy app drawing every helper on one page, and a `bin/rails` at the root, so
there is no `cd` first. From the root of a clone:

```bash
bin/setup
rails s
```

`localhost:3000` is every component at once, `?flash=1` adds the toasts, and `/flow` is the
signup page.

## From npm

For a host that bundles the sources itself rather than serving the built tree. The package is
`bh6`, since `bh` on npm is somebody else's.

```bash
npm install bh6
```

Bootstrap 6 is not on npm at all, so its bundle ships inside the package and a bundler has to
send the bare `bootstrap` specifier there — `alias: { bootstrap: 'bh6/bootstrap' }`.

## Elsewhere

- [The page](https://claudiob.github.io/bh/) — every component, and how to reach it
- [API reference](https://rubydoc.info/gems/bh) — built from what RubyGems holds
- [CHANGELOG](CHANGELOG.md) — what each release is, and which of the three it is

MIT licensed. Drawn for [houseaccount](https://houseaccount.com/) by the Earl of Bubblehum.
