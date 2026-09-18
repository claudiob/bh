module Bh
  module Helpers
    # The page of a signup flow: a mark over whatever it stands on, a title, a line, one card,
    # the way out.
    module Flows
      # How wide the card is unless a page says otherwise: as wide as a thread, a table or a
      # contract wants. A page asking one question says a narrower one.
      WIDTH = '75rem'

      # Draws the page around the card's content: `header` over what the view said in
      # `content_for` — its `:title`, its `:subtitle`, how wide the card is in `:width` — and
      # the pieces of `footer` under the card joined by a middot. No header draws no header,
      # no subtitle no line and an empty footer no foot: a page says only what it has. Every
      # other option is an attribute of the column, which is where a host names the controller
      # that paints what the page stands on.
      def flow(header: nil, footer: [], **options, &)
        parts = [
          (tag.header header if header),
          *bh_flow_words,
          bh_flow_card(content_for(:width), &),
          bh_flow_footer(footer),
        ]
        classes = class_names 'flow', options[:class]

        tag.div safe_join(parts.compact), class: classes, **options.except(:class)
      end

    private

      def bh_flow_words
        [tag.h1(content_for(:title)), (tag.p content_for :subtitle if content_for? :subtitle)]
      end

      def bh_flow_card(width, &)
        width = width.presence || WIDTH
        style = "--flow-width: #{width}" unless width == WIDTH

        tag.div capture(&), class: 'flow-card p-3 md:p-4 mx-auto', style:
      end

      def bh_flow_footer(pieces)
        pieces = Array(pieces).compact_blank
        return if pieces.empty?

        tag.footer safe_join(pieces, tag.span('·', class: 'fg-2', aria: { hidden: true }))
      end
    end
  end
end
