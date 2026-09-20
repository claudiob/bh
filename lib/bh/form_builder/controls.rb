require 'action_view'

module Bh
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Every other kind of field, at the one size this builder draws them: a page says which kind
    # it wants and nothing about how it looks. Rails hands an undressed control to whatever it
    # has no method for here, which is how a Bootstrap class ends up written in a view.
    module Controls
      # What a box that is ticked wears, and what a circle does.
      CHECK = 'check'
      RADIO = 'radio'

      # An email address, which a browser offers the one it keeps.
      def email_field(method, options = {})
        super(method, { autocomplete: 'email' }.merge(dressed(method, options)))
      end

      # A number, which brings the keyboard for one.
      def number_field(method, options = {}) = super(method, dressed(method, options))

      # A password, which no name of a column earns on its own.
      def password_field(method, options = {}) = super(method, dressed(method, options))

      # A term to search by.
      def search_field(method, options = {}) = super(method, dressed(method, options))

      # A web address, which a browser offers the one it keeps.
      def url_field(method, options = {})
        super(method, { autocomplete: 'url' }.merge(dressed(method, options)))
      end

      # A day.
      def date_field(method, options = {}) = super(method, dressed(method, options))

      # A time of day.
      def time_field(method, options = {}) = super(method, dressed(method, options))

      # A day and a time together.
      def datetime_field(method, options = {}) = super(method, dressed(method, options))

      # More than a line of words.
      def text_area(method, options = {}) = super(method, dressed(method, options))

      # A menu of what a column may be.
      def select(method, choices = nil, options = {}, html_options = {}, &)
        super(method, choices, options, dressed(method, html_options), &)
      end

      # One of several, ticked.
      def check_box(method, options = {}, checked = '1', unchecked = '0')
        super(method, with_classes(options, CHECK), checked, unchecked)
      end

      # One of several, and only one.
      def radio_button(method, value, options = {})
        super(method, value, with_classes(options, RADIO))
      end

      # A box and the words beside it, which is the one place words sit after a control rather
      # than over it -- so they are not the label a field wears, and are written here instead.
      # A `description:` is the line under those words, for a box whose label is too short to
      # say what ticking it means. Every other option is the box's.
      def check(method, text, options = {})
        box = check_box method, options.except(:description)
        inside = @template.safe_join [box, checked_words(method, text, options[:description])]

        @template.tag.div inside, class: 'form-field'
      end

    private

      def checked_words(method, text, description)
        words = @template.label_tag field_id(method), text
        return words unless description

        said = @template.tag.small description, class: 'form-text'

        @template.tag.div @template.safe_join([words, said]), class: 'form-field-content'
      end
    end
  end
end
