require_relative 'chats/asides'
require_relative 'chats/asks'

module Bh
  module Helpers
    # A conversation drawn as the bubbles every Bh chat wears.
    module Chats
      include Asides, Asks

      # `messages` as a thread that opens at its newest and, where `url` is given, a field
      # under it that posts the next message there, suggesting `hints` one at a time.
      def chat_with(messages:, url: nil, hints: [])
        parts = [bh_chat_messages(messages)]
        parts.push bh_chat_ask(url, hints) if url

        tag.div safe_join(parts, "\n"), class: 'chat-thread', data: { controller: 'thread' }
      end

    private

      def bh_chat_messages(messages)
        tag.div class: 'chat', data: { thread_target: 'messages' } do
          safe_join messages.map { |message| bh_chat_message message }, "\n"
        end
      end

      def bh_chat_message(message)
        parts = [bh_chat_aside(message), bh_chat_bubble(message)]

        safe_join parts.compact, "\n"
      end

      def bh_chat_bubble(message)
        side = Asides::SIDES.fetch message.side
        return tag.p message.text, class: "chat-bubble chat-#{side}" if message.text

        tag.p safe_join(Array.new(3) { tag.span }), class: "chat-bubble chat-#{side} chat-typing",
                                                    aria: { label: t('bh.typing') }
      end
    end
  end
end
