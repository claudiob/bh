module Bh
  # One message of a chat, as `chat_with` draws it: which `side` its bubble is on (`:left`
  # for the other party, `:right` for the reader), its `text`, who the `sender` was, when it
  # was said (`at`), how its `delivery` went (`:delivered`, `:sent`, `:failed`,
  # `:undelivered` or nil) and what it `cost` in dollars, where anything did. Any object
  # answering the same six is a message too; this is for a host that has the facts and no
  # model to hang them on. A message with no text yet is drawn as being typed.
  Message = Data.define :side, :text, :sender, :at, :delivery, :cost do
    def initialize(side:, text: nil, sender: nil, at: nil, delivery: nil, cost: nil) = super
  end
end
