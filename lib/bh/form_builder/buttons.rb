require 'action_view'

module Bh
  class FormBuilder < ActionView::Helpers::FormBuilder
    # What a form is sent with, and what else it offers to press.
    module Buttons
      # What a button wears: the large pill in the primary color, solid or outlined.
      PILL = 'btn btn-lg rounded-5 theme-primary'

      # What clears a button of the field or the button above it.
      SPACE = 'mt-3 md:mt-4'

      # A submit is the builder's button, solid.
      def submit(value = nil, options = {})
        super(value, with_classes(options, "#{PILL} btn-solid #{SPACE}"))
      end

      # A button is the builder's too: solid where it submits, which is what one does unless
      # told `type: :button`, and outlined where it does not. A disabled one given a `title`
      # says why on hover — `Available soon` — from a wrapper around it, since a disabled
      # button hears no mouse; the wrapper then takes the button's place in the column.
      def button(value = nil, options = {}, &)
        return button(nil, value, &) if value.is_a? Hash

        wrapped = options[:disabled] && options[:title]
        fill = options[:type].to_s == 'button' ? 'btn-outline' : 'btn-solid'
        classes = @template.class_names PILL, fill, (SPACE unless wrapped)
        button = super(value, with_classes(options.except(:title), classes), &)

        wrapped ? tooltipped(button, options[:title]) : button
      end

    private

      def tooltipped(button, title)
        @template.tag.span button, class: "d-grid #{SPACE}", data: @template.tooltip_data(title)
      end
    end
  end
end
