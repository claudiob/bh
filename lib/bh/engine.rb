# rails/engine alone raises NoMethodError: railtie.rb calls delegate_missing_to too early.
require 'rails'

module Bh
  # Hooks the gem into a host app: serves the built stylesheet and script, and the helpers.
  class Engine < ::Rails::Engine
    # Where the built files answer from: one prefix of the gem's own, so a host already
    # serving `/css` from somewhere else keeps it. The slash is kept, since `Rack::Static`
    # matches on `start_with?` and `/bh` would swallow a host's own `/bhutan`.
    PREFIX = '/bh/'.freeze

    # Neither URL carries a version, so both are asked for again on every full load and
    # answered `304 Not Modified` while the file they name still stands.
    HEADERS = [[:all, { 'cache-control' => 'no-cache' }]].freeze

    # Before `Rails::Rack::Logger`, so fetching the stylesheet writes no `Started GET` line,
    # and cascading, so a host route under the prefix still answers.
    initializer 'bh.assets' do |app|
      app.middleware.insert_before Rails::Rack::Logger, Rack::Static,
                                   urls: [PREFIX], root: Engine.root.join('public').to_s,
                                   header_rules: HEADERS, cascade: true
    end

    initializer 'bh.helpers' do
      ActiveSupport.on_load(:action_view) { include Bh::Helpers }
    end
  end
end
