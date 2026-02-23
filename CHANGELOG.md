# Changelog

All notable changes to this project will be documented in this file.

For more information about changelogs, check
[Keep a Changelog](http://keepachangelog.com) and
[Vandamme](http://tech-angels.github.io/vandamme).

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
