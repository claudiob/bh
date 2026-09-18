require 'action_view'
require_relative 'form_builder/comboboxes'
require_relative 'form_builder/controls'
require_relative 'form_builder/pins'

module Bh
  # The form: what a label, a field and a button of one wear, and the field Rails has
  # none of. Given to one form as `builder:`, or to every form of a controller through
  # `default_form_builder`. What a view passes is kept: its classes join the builder's, its
  # `data` is merged key by key with the builder's, and any other option of its overrides.
  class FormBuilder < ActionView::Helpers::FormBuilder
    include Comboboxes, Controls, Pins

    # What a field wears: Bootstrap's control, at the size a thumb finds.
    CONTROL = 'form-control form-control-lg'

    # What a button wears: the large pill in the primary color, solid or outlined.
    PILL = 'btn btn-lg rounded-5 theme-primary'

    # What clears a button of the field or the button above it.
    SPACE = 'mt-3 md:mt-4'

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

      @template.tag.fieldset inside, **with_classes(options, 'd-grid flow-fieldset')
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

      @template.tag.label inside, for: field_id(method), **with_classes(options, 'flow-field')
    end

    # A text field is a large control.
    def text_field(method, options = {}) = super(method, with_classes(options, CONTROL))

    # A phone field is a large control shaped by the `phone` controller as it is typed.
    def phone_field(method, options = {})
      super(method, PHONE.deep_merge(with_classes(options, CONTROL)))
    end

    # A submit is the builder's button, solid.
    def submit(value = nil, options = {})
      super(value, with_classes(options, "#{PILL} btn-solid #{SPACE}"))
    end

    # A button is the builder's too: solid where it submits, which is what one does unless told
    # `type: :button`, and outlined where it does not. A disabled one given a `title` says why
    # on hover — `Available soon` — from a wrapper around it, since a disabled button hears no
    # mouse; the wrapper then takes the button's place in the column.
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
      @template.tag.span button, class: "d-grid #{SPACE}",
                                 data: { controller: 'tooltip', bs_title: title }
    end

    def with_classes(options, classes)
      options.merge class: @template.class_names(classes, options[:class])
    end
  end
end
