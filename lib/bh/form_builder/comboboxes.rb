require 'action_view'

module Bh
  class FormBuilder < ActionView::Helpers::FormBuilder
    # The menu the bundle draws as a combobox: Bootstrap's toggle and a searchable menu built
    # from a select it then hides, which stays the one thing the form submits.
    module Comboboxes
      # The words the menu is read by, which belong to the gem rather than to a page.
      WORDS = %i[all clear more no_results search].freeze

      # `method` as a combobox over `choices` -- the select `form.select` would draw, carrying
      # what the bundle needs to draw it as one instead. Every argument is that select's, and
      # its own `:prompt` is what the toggle says before anything is picked. The words it is
      # searched, cleared and emptied by are the gem's, in the reader's own language, and
      # `data` given in `html_options` is kept over any of them.
      def combobox(method, choices = nil, options = {}, html_options = {}, &)
        data = { controller: 'combobox', combobox_placeholder_value: options[:prompt],
                 **bh_combobox_words, **html_options.fetch(:data, {}), }

        select method, choices, options, html_options.merge(data: data), &
      end

    private

      # `all` and `more` are Stimulus values the menu reads; the rest are plain attributes.
      # `more` is a template the bundle fills, so it is asked for with its own placeholders as
      # their values -- I18n would otherwise raise on the two it cannot fill.
      def bh_combobox_words
        WORDS.to_h do |word|
          # rubocop:disable-next Style/FormatStringToken -- the bundle fills these, not Ruby
          said = @template.t "bh.#{word}", first: '%{first}', count: '%{count}'

          [%i[all more].include?(word) ? :"combobox_#{word}_value" : word, said]
        end
      end
    end
  end
end
