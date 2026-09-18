require 'action_view'

module Bh
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Every other kind of field, at the one size this builder draws them: a page says which kind
    # it wants and nothing about how it looks. Rails hands an undressed control to whatever it
    # has no method for here, which is how a Bootstrap class ends up written in a view.
    module Controls
      # What a menu wears: the control's size, so a menu and a box beside it line up.
      MENU = 'form-select form-select-lg'

      # What a box or a circle that is ticked wears.
      CHECK = 'form-check-input'

      # An email address.
      def email_field(method, options = {}) = super(method, with_classes(options, CONTROL))

      # A number, which brings the keyboard for one.
      def number_field(method, options = {}) = super(method, with_classes(options, CONTROL))

      # A password, which no name of a column earns on its own.
      def password_field(method, options = {}) = super(method, with_classes(options, CONTROL))

      # A term to search by.
      def search_field(method, options = {}) = super(method, with_classes(options, CONTROL))

      # A web address.
      def url_field(method, options = {}) = super(method, with_classes(options, CONTROL))

      # A day.
      def date_field(method, options = {}) = super(method, with_classes(options, CONTROL))

      # A time of day.
      def time_field(method, options = {}) = super(method, with_classes(options, CONTROL))

      # A day and a time together.
      def datetime_field(method, options = {}) = super(method, with_classes(options, CONTROL))

      # More than a line of words.
      def text_area(method, options = {}) = super(method, with_classes(options, CONTROL))

      # A menu of what a column may be.
      def select(method, choices = nil, options = {}, html_options = {}, &)
        super(method, choices, options, with_classes(html_options, MENU), &)
      end

      # One of several, ticked.
      def check_box(method, options = {}, checked = '1', unchecked = '0')
        super(method, with_classes(options, CHECK), checked, unchecked)
      end

      # One of several, and only one.
      def radio_button(method, value, options = {})
        super(method, value, with_classes(options, CHECK))
      end

      # A box and the words beside it, which is the one place words sit after a control rather
      # than over it -- so they are not the label a field wears, and are written here instead.
      def check(method, text, options = {})
        words = @template.label_tag field_id(method), text, class: 'form-check-label'
        inside = @template.safe_join [check_box(method, options), words]

        @template.tag.div inside, class: 'form-check'
      end
    end
  end
end
