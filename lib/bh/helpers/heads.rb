module Bh
  module Helpers
    # What a page built on Bootstrap 6 puts in its `<head>`.
    module Heads
      # One line per tag, each at the depth a head's children sit at in a layout indented
      # by two: `<html>`, then `<head>`, then these.
      INDENT = "\n    "

      # The metas Bootstrap and Turbo read, and the stylesheet and script this gem serves.
      # `color-scheme` is what lets `light dark` follow the system, so most pages need no
      # theme attribute at all. A page refresh Turbo is sent morphs the page in place and
      # keeps the scroll, so an answer landing in a thread leaves the reader where they were.
      # The icon font is the host's to link: which glyphs a page draws is the host's business,
      # and a gem reaching for somebody else's CDN on its own is not.
      def bh_head_tags
        safe_join [
          tag.meta(name: 'viewport', content: 'width=device-width, initial-scale=1'),
          tag.meta(name: 'color-scheme', content: 'light dark'),
          tag.meta(name: 'turbo-refresh-method', content: 'morph'),
          tag.meta(name: 'turbo-refresh-scroll', content: 'preserve'),
          tag.link(rel: 'stylesheet', href: "#{Engine::PREFIX}css/bh.css"),
          tag.script('', type: 'module', src: "#{Engine::PREFIX}js/bh.js"),
        ], INDENT
      end
    end
  end
end
