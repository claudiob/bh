require_relative 'chats/asides'
require_relative 'chats/asks'

module Bh
  module Helpers
    # A conversation drawn as the bubbles every Bh chat wears.
    module Chats
      include Asides, Asks

      # `messages` as a thread that opens at its newest and, where `url` is given, a field
      # under it that posts the next message there, suggesting `hints` one at a time. A
      # `note` stands over the whole thread: what this conversation is about, or the other
      # way to reach whoever is on the far end of it.
      def chat_with(messages:, url: nil, hints: [], note: nil)
        parts = [bh_chat_note(note), bh_chat_messages(messages)]
        parts.push bh_chat_ask(url, hints) if url

        said = safe_join parts.compact, "\n"

        tag.div said, class: 'chat-thread', data: { controller: 'thread' }
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

      # Said over the thread rather than in it, so it is not one of the turns: nobody
      # said this, and a bubble would claim somebody had.
      def bh_chat_note(note)
        tag.p note, class: 'chat-note' if note.present?
      end

      def bh_chat_bubble(message)
        side = Asides::SIDES.fetch message.side
        said = bh_chat_said message
        return tag.p said, class: "chat-bubble chat-#{side}" if said

        tag.p safe_join(Array.new(3) { tag.span }), class: "chat-bubble chat-#{side} chat-typing",
                                                    aria: { label: t('bh.typing') }
      end

      # The words and then the pictures, which is the order a phone lays a picture
      # message out in -- and nothing at all where a message has neither yet.
      def bh_chat_said(message)
        pictures = Array(message.photos).map { |photo| bh_chat_photo photo }

        safe_join([message.text, *pictures].compact_blank, "\n").presence
      end

      # A picture in the bubble, opening full size in a tab of its own: what fits beside
      # words is rarely what somebody wants to look at.
      def bh_chat_photo(url)
        tag.a href: url, target: :_blank, rel: 'noopener' do
          tag.img src: url, alt: t('bh.photo'), class: 'chat-photo', loading: :lazy
        end
      end
    end
  end
end
