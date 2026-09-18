require 'action_view'

module Bh
  class FormBuilder < ActionView::Helpers::FormBuilder
    # The field Rails has none of: the six slots a code is typed into.
    module Pins
      # What the one real PIN field carries: digits only, six of them, offered by the phone from
      # the text that brought them, and drawn as slots by Bootstrap and the `otp` controller.
      PIN = {
        class: 'otp-input', inputmode: :numeric, pattern: '[0-9]{6}', minlength: 6, maxlength: 6,
        autocomplete: 'one-time-code',
      }.freeze

      # `method` as Bootstrap's OTP input: one real field rendered as six slots, the slots
      # reddened where the record refused the code. Every option is the field's. The field is
      # drawn by the view rather than this builder on purpose, so it is never dressed as a
      # `form-control`: a refused one would wear a red box of its own around slots that say so.
      def pin_field(method, **options)
        invalid = @object.respond_to?(:errors) && @object.errors.include?(method)
        classes = @template.class_names 'otp otp-lg', 'is-invalid': invalid

        field = with_classes PIN.merge(options), PIN[:class]

        @template.tag.div class: classes, data: { controller: 'otp', bs_otp: true } do
          @template.text_field @object_name, method, **field, object: @object
        end
      end
    end
  end
end
