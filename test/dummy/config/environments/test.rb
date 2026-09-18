Rails.application.configure do
  config.eager_load = false

  # Discard log output: a test run should not leave files behind.
  config.logger = ActiveSupport::Logger.new IO::NULL

  # A path nothing answers renders the gem's 404 page, as a host's would; anything else raises.
  config.action_dispatch.show_exceptions = :rescuable
end
