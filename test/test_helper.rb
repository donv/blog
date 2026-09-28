# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require_relative '../test/dummy/config/environment'
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __dir__)
require 'rails/test_help'

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
ActiveSupport::TestCase.fixture_paths = [File.expand_path('fixtures', __dir__)]
ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
ActiveSupport::TestCase.file_fixture_path = File.expand_path('fixtures/files', __dir__)
ActiveSupport::TestCase.fixtures :all

# require 'simplecov'
# SimpleCov.start :rails
#
# ENV['RAILS_ENV'] ||= 'test'
# require File.expand_path('../../config/environment', __FILE__)
# require 'rails/test_help'
#
# MiniTest::Reporters.use!
#
module ActionDispatch
  class IntegrationTest
    # Log in through the dummy app's test endpoint; the session cannot be written directly.
    def login(user = users(:bob))
      post '/account/test_login', params: { user_id: user.id }
    end
  end
end

module MailDeliveryError
  def self.prepended(clas)
    clas.cattr_accessor :inject_one_error
    clas.inject_one_error = false
  end

  def deliver!(mail)
    if inject_one_error
      self.class.inject_one_error = false
      raise 'Failed to send email' if ActionMailer::Base.raise_delivery_errors
    end
    super mail
  end
end
require 'mail'
Mail::TestMailer.prepend MailDeliveryError
