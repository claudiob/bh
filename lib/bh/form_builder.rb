require 'action_view'
require_relative 'form_builder/adornments'
require_relative 'form_builder/buttons'
require_relative 'form_builder/comboboxes'
require_relative 'form_builder/controls'
require_relative 'form_builder/pins'

module Bh
  # The form: what a label, a field and a button of one wear, and the field Rails has
  # none of. Given to one form as `builder:`, or to every form of a controller through
  # `default_form_builder`. What a view passes is kept: its classes join the builder's, its
  # `data` is merged key by key with the builder's, and any other option of its overrides.
  class FormBuilder < ActionView::Helpers::FormBuilder
    include Adornments, Buttons, Comboboxes, Controls, Pins

    # What a field wears: Bootstrap's control, at the size a thumb finds.
    CONTROL = 'form-control form-control-lg'

    # What a phone field carries: the bundle's `phone` controller, which shapes the number as
    # it is typed, and the keyboard and autofill a phone offers for one.
    PHONE = {
      autocomplete: 'tel',
      data: { controller: 'phone', action: 'keydown->phone#down input->phone#input' },
    }.freeze

    # The fieldset a form's controls sit in: a grid, with `legend` over them where one is
    # given, wearing nothing of ours. It carries
    # its own spacing, twice as much under it as over, so one group reads as belonging to the
    # words above it rather than sitting evenly between two. Every option is the fieldset's.
    def fieldset(legend = nil, **options, &)
      heading = (@template.tag.legend legend if legend)
      inside = @template.safe_join [heading, @template.capture(&)].compact

      @template.tag.fieldset inside, **with_classes(options, 'd-grid bh-fieldset')
    end

    # A label is Bootstrap's `form-label`, whatever else it is given -- and given both words
    # and a block, the control the words name as well, which Rails' own label has no meaning
    # for: it drops the words and renders the block. Wrapped, the pair is one element, so a
    # form laid out in columns has a cell to place and neither an id nor a stylesheet counting
    # children has to bind them -- which a control drawing markup of its own, a combobox say,
    # would break on connect.
    def label(method, text = nil, options = {}, &block)
      return label(method, nil, text, &block) if text.is_a? Hash
      return super(method, text, with_classes(options, 'form-label'), &block) unless text && block

      words = @template.tag.span text, class: 'form-label'
      inside = @template.safe_join [words, @template.capture(&block)]

      @template.tag.label inside, for: field_id(method), **with_classes(options, 'bh-field')
    end

    # A text field is a large control.
    def text_field(method, options = {}) = super(method, dressed(method, options))

    # A file to attach, which Rails hands over undressed.
    def file_field(method, options = {}) = super(method, dressed(method, options))

    # A phone field is a large control shaped by the `phone` controller as it is typed, and
    # showing the shape it will take. Read at the call rather than frozen into `PHONE`, since
    # how a number is written is the reader's language and not this gem's.
    def phone_field(method, options = {})
      shown = { placeholder: @template.t('bh.phone') }

      super(method, PHONE.merge(shown).deep_merge(dressed(method, options)))
    end

  private

    def with_classes(options, classes)
      options.merge class: @template.class_names(classes, options[:class])
    end

    # What a control wears, and what names it where the words that do are not beside it: the
    # attribute, as the label a reader meeting the field alone is read it by. A page's own
    # `aria` wins over this one, key by key.
    def dressed(method, options, classes = CONTROL)
      { aria: { label: method } }.deep_merge with_classes(options, classes)
    end
  end
end
