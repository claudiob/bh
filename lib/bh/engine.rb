require_relative 'bootstrap_helpers'

module Bh
  class Engine < Rails::Engine
    initializer 'bh.view_helpers' do
      ActiveSupport.on_load(:action_view) { include Bh::BootstrapHelpers }
    end

    initializer 'bh.assets' do |app|
      app.config.assets.paths << root.join('app/javascript')
    end
  end
end
