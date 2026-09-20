require_relative 'helpers/chats'
require_relative 'helpers/confirmations'
require_relative 'helpers/dialogs'
require_relative 'helpers/toasts'
require_relative 'helpers/tooltips'

module Bh
  # Everything a view may call, in one module the engine puts on every Action View.
  module Helpers
    include Chats, Confirmations, Dialogs, Toasts, Tooltips
  end
end
