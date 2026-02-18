Bh · Bootstrap Helpers
======================

A set of Ruby helpers that streamlines the use of
[Bootstrap 6 components](https://deploy-preview-42067--twbs-bootstrap.netlify.app/) in HTML views.

Bootstrap 6 is a great framework, but requires many lines of HTML code
even for simple components.

With Bh, you can achieve the same result with fewer lines of code

How to install
==============

1. Add `gem 'bh'` to the `Gemfile` file of your Rails app.
2. Add this line to the `config/importmap.rb` file:

```ruby
pin_all_from Bh::Engine.root.join('app/javascript/controllers'), under: 'controllers'
```
