require_relative 'helpers/chats'
require_relative 'helpers/dialogs'
require_relative 'helpers/flows'
require_relative 'helpers/heads'
require_relative 'helpers/notices'

module Bh
  # Everything a view may call, in one module the engine puts on every Action View.
  module Helpers
    include Chats, Dialogs, Flows, Heads, Notices
  end
end
