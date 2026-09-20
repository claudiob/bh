require 'action_view'

module Bh
  class FormBuilder < ActionView::Helpers::FormBuilder
    # The two controls that carry a unit inside their border: money, and a share of a hundred.
    module Adornments
      # What a price takes: no less than nothing, and the cents a currency is counted in. A
      # caller knowing its column's scale says so and overrides the step.
      PRICE = { min: 0, step: 0.01 }.freeze

      # What the wrapper wears. Bootstrap adorns a control by wrapping it, so the border and
      # the padding are the wrapper's and the field inside carries neither.
      ADORN = 'form-control form-adorn d-flex'

      # What money is typed into: the number and the currency beside it, inside one border.
      def price_field(method, options = {})
        adorned method, currency_unit, PRICE.merge(options)
      end

      # And a share of a hundred, whose sign follows the number rather than leading it.
      def percentage_field(method, options = {})
        adorned method, '%', options, ending: true
      end

    private

      def currency_unit = I18n.t 'number.currency.format.unit', default: '$'

      def adorned(method, unit, options, ending: false)
        classes = @template.class_names ADORN, ('form-adorn-end' if ending), options[:class]
        unit = @template.tag.span unit, class: 'form-adorn-text'
        inside = @template.safe_join [unit, ghost_field(method, options.except(:class))]

        @template.tag.div inside, class: classes
      end

      # The control Rails draws before this builder dresses one, which is what the wrapper
      # holds: `form-ghost` wears neither the border nor the padding a control does.
      def ghost_field(method, options)
        asked = { aria: { label: method } }.deep_merge options

        @template.number_field @object_name, method,
                               objectify_options(asked.merge(class: 'form-ghost'))
      end
    end
  end
end
