# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

## [Unreleased]

## 6.6.0 - 2026-09-18

* [CHANGE] A picture in a bubble is a thumbnail

  Drawn at the height every other picture on these screens is, since what fits beside
  words is a thing to recognise and click rather than a thing to look at -- and narrower
  than the bubble whatever shape it is, so a portrait photograph does not make a column
  of one message.

## 6.5.1 - 2026-09-18

* [FIX] A thread's note is opaque and centred

  It named a background variable this bundle does not define, so it drew none and the
  message it holds the top over read through it. And it lost its centring when it gained
  its stickiness.

## 6.5.0 - 2026-09-18

* [FIX] The shell fills the screen in whole pixels

  `100dvh` computes to a fraction on a scaled display -- 415.455px against a viewport
  reporting 415 -- and the tenths over are enough for a browser to draw a scrollbar the
  page cannot use, beside the one the content it holds already has. The shell takes a
  percentage of a document given a height instead, which is the same whole number the
  viewport reports.

## 6.4.0 - 2026-09-18

* [FEATURE] A message carries its `photos`, drawn in the bubble under its words

  `Bh::Message` takes a list of addresses beside its text. Each is drawn under the words in
  the same bubble, linking to itself in a tab of its own: what fits beside words is rarely
  what somebody wants to look at. A message carrying pictures and no words is a message all
  the same, rather than one still being typed.

* [FEATURE] `chat_with` takes a `note:`, said over the thread rather than in it

  What the conversation is about, or the other way to reach whoever is on the far end of it.
  Over rather than in, because nobody in the conversation said it and a bubble would claim
  somebody had. It holds the top while the thread scrolls under it, and carries the page's
  own background for that reason: a tint would read as somebody's turn, and without one the
  bubbles would show through.

## 6.3.0 - 2026-09-18

* [FEATURE] The nine palettes, served at `/bh/theme/<name>.css`

  `bootstrap`, `dawn`, `dracula`, `gruvbox`, `monokai`, `nord`, `one_dark`, `solarized` and
  `tokyo_night`, each restating all thirteen steps of every Bootstrap family it repaints. They
  arrived with the `scheme` controller in 6.2.0 and the controller had nothing to swap: it
  reads `${path}/${theme}.css`, and no such file shipped. Now it does.

  They are copied beside the stylesheet rather than bundled into it, because a page links one
  at a time and swaps it for another, which is the whole point of them.

## 6.2.0 - 2026-09-18

A breaking change that keeps its major on purpose. 6.0 through 6.1.4 were an alpha in
everything but the number — Bootstrap 3 wrappers with a Bootstrap 6 stopgap bolted on,
cut while Bootstrap 6 was itself pre-release — so there is no settled API here to have
broken, and nothing is owed the major a real break would earn. Those numbers are taken
and cannot be withdrawn, RubyGems keeping anything published over thirty days ago, so
6.2.0 steps over them and lands above 6.1.4, where `bundle update` reaches it.

Until this line settles it breaks on a minor: pin `~> 6.2.0`, never `~> 6`.

* [BREAKING CHANGE] Everything. Bh is now Bootstrap 6 components rather than Bootstrap 3
  wrappers, and no helper of 1.x or 6.1.x survives: `head_tags`, `script_tags`, `navbar`,
  `navbar_brand`, `navbar_nav`, `navbar_toggler`, `navbar_collapse`, `navbar_collapsable`,
  `card`, `nav`, `nav_link_to`, `nav_link_options_for`, `table`, `column`, `grid`, `grid_row`,
  `grid_column`, `turbo_link_to` and `edit_link_to` are all gone, along with the `bh/_table`
  and `bh/_grid` partials and the loose `phone`, `require`, `submit` and `bh--theme`
  controllers.
* [FEATURE] `Bh::FormBuilder`, which dresses every field Rails draws and adds the two it has
  none of: `phone_field`, shaped as it is typed, and `pin_field`, the six slots a 6-digit code
  is typed into.
* [FEATURE] `combobox`, a `<select>` drawn as a searchable menu that stays the one thing the
  form submits.
* [FEATURE] `dialog`, `notices`, `chat_with` and `flow`.
* [FEATURE] `bh_head_tags`, and an engine that serves `/bh/css/bh.css` and `/bh/js/bh.js` — one
  stylesheet and one script, Bootstrap 6 included, built by esbuild and shipped in the gem.
* [FEATURE] Twenty-two Stimulus controllers, registered by the bundle, and a Bootstrap dialog
  standing in for the browser's `confirm()`.
* [FEATURE] A dummy app under `test/dummy` drawing every helper on one page, which `rails s`
  from the root of a clone runs.


## 6.1.5 - 2026-06-29

* [FEATURE] Point to main boostrap v6 CSS

## 6.1.4 - 2026-06-24

* [FEATURE] Include Boostrap Icons CSS

## 6.1.3 - 2026-05-16

* [FEATURE] Added three Stimulus controllers (phone, require, submit)

## 6.1.2 - 2026-03-18

* [BREAKING CHANGE] The `table` method doesn't take the `headers` parameter anymore.
* [FEATURE] New `column` method to define headers and body of a `table` at once

## 6.0.1 - 2026-02-23

- Remove class "card-row" from card_body

That's because a card body with card-row does not display correct borders for nested cards

## 6.0.0 - 2026-02-18

* [BREAKING FIXES] Literally everything changed. Moving from Bootstrap 3 to Bootstrap 6.

## 1.3.6 - 2015-12-18

* [ENHANCEMENT] Bump versions of asset libraries

## 1.3.5 - 2015-12-18

* [ENHANCEMENT] Replace `errors.get(:field)` with `errors[:field]` since the former is deprecated in Rails 5.

## 1.3.4 - 2015-06-23

* [BUGFIX] Security: don’t always assume that the content of `link_to` is safe

Note that this might break your code if it relied on the wrong behavior of
Bh, assuming that the content of `link_to` was always HTML safe.

For instance, if your app has the following code to display an image with a
link `link_to '<img src="logo.png">', '/'`, then the image will not display
anymore, since Bh now correctly escapes the HTML content (as Rails and Padrino
do). In this case, you should use `link_to image_tag('logo.png'), '/'` instead.

## 1.3.3 - 2015-03-11

* [BUGFIX] Correctly align the "X" icon at the right of the field in basic forms

## 1.3.2 - 2015-03-05

* [BUGFIX] Respect the original behavior of Padrino/Rails when calling `link_to` with `nil` as the name

## 1.3.1 - 2015-02-03

* [BUGFIX] Do not render the `:offset` option of the field helpers in the DOM
* [BUGFIX] Do not render the `:label` option of the field helpers in the DOM
* [ENHANCEMENT] Add `:label_options` option to customize the wrapping label of a field

## 1.3.0 - 2015-02-02

* [FEATURE] Extend `form_for` to be wrapped in <li> when inside a `nav`, just like `link_to`
* [FEATURE] Extend `button_to` to be wrapped in <li> when inside a `nav`, just like `link_to`
* [BUGFIX] Match default placeholder with label content (therefore supporting localization)
* [ENHANCEMENT] Bootstrappify forms wrapped in `navbar`, setting their class to "navbar-form"
* [ENHANCEMENT] Add `:help` option to display a help block after most form fields
* [ENHANCEMENT] Bump Bootstrap version to 3.3.2
* [ENHANCEMENT] Bump Font Awesome version to 4.3.0

## 1.2.0 - 2014-11-13

* [FEATURE] Add support for Middleman and Padrino for all helpers except `form_for`
* [FEATURE] Extend `button_to` to accept the same :content, :size and :layout options as `button`
* [DEPRECATION] Deprecate `glyphicon` in favor of `icon` (`glyphicon` will still work until version 2.0.0)
* [BUGFIX] Don’t override `button_to` unless `:context`, `:size` or `:layout` is passed
* [ENHANCEMENT] Allow `alert_box` to pass extra parameters to the alert box <div>
* [ENHANCEMENT] Allow `button_to` to pass extra parameters to the button element
* [ENHANCEMENT] Allow `dropdown` to display a full-width button when called with `{layout: :block, groupable: false}`
* [ENHANCEMENT] Allow `dropdown` to pass `:id` parameter to the dropdown <ul>
* [ENHANCEMENT] Allow `modal` to pass the `:id` parameter to the wrapping <div>
* [ENHANCEMENT] Allow `modal` to pass `{button: :class}` parameter to the toggle <button>
* [ENHANCEMENT] Allow `panel` to pass extra parameters to the wrapping <div>
* [ENHANCEMENT] Allow `progress_bar` to pass extra parameters to the wrapping container
* [ENHANCEMENT] Allow `progress_bar` to pass extra parameters to each bar
* [ENHANCEMENT] Don’t render anything when `vertical` and `horizontal` are not wrapped in a `navbar`
* [ENHANCEMENT] Wrap plain content passed to `modal` inside the modal body
* [ENHANCEMENT] Wrap plain content passed to `panel` inside the panel body

## 1.1.1 - 2014-09-20

* [ENHANCEMENT] Bump Bootstrap version to 3.3.0

## 1.1.0 - 2014-09-20

* [FEATURE] Add `icon` helper
* [FEATURE] Add `font_awesome_css` helper
* [FEATURE] Add `dropdown` helper
* [FEATURE] Add `progress_bar` helper
* [ENHANCEMENT] Add `:fieldset` option to decide whether `fields_for` should wrap fields in a <fieldset> tag
* [FEATURE] Add `button` helper

## 1.0.1 - 2014-09-14

* [BUGFIX] Remove `form-control` class from `file_field` (#20)
* [BUGFIX] Allow `record_object` to be passed to `fields_for` (#22)

## 1.0.0 - 2014-09-09

* No changes

## 0.0.8 - 2014-08-25

* [FEATURE] Add `button_to` helper
* [FEATURE] Add `navbar` helper

## 0.0.7 - 2014-08-25

* [FEATURE] Add `nav` helper

## 0.0.6 - 2014-08-22

* [FEATURE] Add `:prefix`, `:suffix` options to form field helpers

## 0.0.5 - 2014-08-22

* [FEATURE] Add `form_for` and form helpers for every type of field

## 0.0.4 - 2014-08-17

* [FEATURE] Add `modal`
* [FEATURE] Add `panel_row`
* [FEATURE] Add `panel`
* [FEATURE] Add `glyphicon`

## 0.0.3 - 2014-08-15

* [FEATURE] Add `bootstrap_css`, `bootstrap_theme_css` and `bootstrap_js`

## 0.0.2 - 2014-08-15

* [FEATURE] Add `alert_box` helper
