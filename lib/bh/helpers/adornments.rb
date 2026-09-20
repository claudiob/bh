module Bh
  module Helpers
    # A control with its unit written inside the border: money, and a share of a hundred.
    module Adornments
      # What the wrapper wears. Bootstrap adorns a control by wrapping it, so the border and
      # the padding are the wrapper's and the field inside carries neither.
      ADORN = 'form-control form-adorn d-flex'

      # @return [String] the currency an app counts in, as its own number formats name it.
      def bh_currency_unit = I18n.t 'number.currency.format.unit', default: '$'

      # A field with its unit beside it. The field is drawn by whoever knows how -- a builder,
      # or a gem reading a column -- and wears `form-ghost`, which has no border of its own.
      # @param unit [String] what the number is counted in.
      # @param field [String] the control the unit stands beside.
      # @param ending [Boolean] whether the unit follows the number rather than leading it.
      # @param options [Hash] anything else the wrapper carries.
      # @return [String] the wrapper, the unit and the field.
      def bh_adorned(unit, field, ending: false, **options)
        classes = class_names ADORN, ('form-adorn-end' if ending), options.delete(:class)
        inside = safe_join [tag.span(unit, class: 'form-adorn-text'), field]

        tag.div inside, class: classes, **options
      end
    end
  end
end
