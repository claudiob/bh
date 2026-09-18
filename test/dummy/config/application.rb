require_relative 'boot'

require 'action_controller/railtie'
require 'action_view/railtie'

require 'bh'

# Stand-in for a host app, so the tests exercise the gem through a booting Rails — and so
# `rails s` from the root of the gem draws every component on one page.
module Dummy
  # The host the gem hangs off.
  class Application < Rails::Application
    config.root = File.expand_path '..', __dir__
    config.load_defaults 8.1
    config.secret_key_base = 'dummy_secret_key_base'
    config.time_zone = 'Eastern Time (US & Canada)'

    # Action View logs a line per partial, which buries the request itself.
    config.action_view.logger = nil
  end
end
