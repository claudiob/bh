module Bh
  module Helpers
    module Chats
      # Who sent a message, when, whether it arrived and what it cost, small above its bubble.
      module Asides
        # Which bubble: the other party's comes in on the left, the reader's goes out on the right.
        SIDES = { left: 'in', right: 'out' }.freeze

        # How a delivery reads, and in which of Bootstrap's tones: a mark for arrived, a mark
        # for sent and not yet, a cross for either way it failed.
        DELIVERIES = {
          delivered: %w[✓ success], sent: %w[✓ secondary],
          failed: %w[✕ danger], undelivered: %w[✕ danger],
        }.freeze

      private

        def bh_chat_aside(message)
          parts = [
            message.sender, bh_chat_time(message.at),
            bh_chat_delivery(message.delivery), bh_chat_cost(message.cost),
          ]
          return if parts.compact.empty?

          side = SIDES.fetch message.side
          tag.small safe_join(parts.compact, ' '), class: "chat-aside chat-aside-#{side}"
        end

        def bh_chat_time(at)
          return unless at

          tag.time t('bh.ago', time: time_ago_in_words(at)),
                   datetime: at.xmlschema, title: l(at, format: :long)
        end

        def bh_chat_delivery(delivery)
          return unless delivery

          mark, tone = DELIVERIES.fetch delivery.to_sym
          tag.strong mark, class: "fg-#{tone}"
        end

        def bh_chat_cost(cost)
          "· #{number_to_currency cost, precision: 4}" if cost
        end
      end
    end
  end
end
