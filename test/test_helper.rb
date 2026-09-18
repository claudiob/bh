require 'simplecov'

# Started before anything else is required, or the gem's own files load untracked.
SimpleCov.start do
  skip '/test/'
  minimum_coverage 100
end

ENV['RAILS_ENV'] = 'test'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'bh'
require_relative 'dummy/config/environment'

require 'minitest/autorun'
require 'action_dispatch/testing/integration'

# What every test that visits a page needs, said once.
class IntegrationCase < Minitest::Test
  def setup
    @session = ActionDispatch::Integration::Session.new Rails.application
    @session.host! 'localhost'
  end

  # The page at `path`, which is expected to be there.
  def visit(path)
    @session.get path

    assert_equal 200, @session.response.status, "GET #{path}"
    body
  end

  # What the last request answered.
  def body = @session.response.body

  # One header of the last answer.
  def header(name) = @session.response.headers[name]
end
