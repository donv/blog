ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

MiniTest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all

  def login
    session[:user] = users(:bob)
  end

  def assert_no_errors(assigns_sym)
    assert_not_nil assigns(assigns_sym)
    assert_equal [], assigns(assigns_sym).errors.to_a
  end

end

class Mail::TestMailer
  cattr_accessor :inject_one_error
  self.inject_one_error = false

  # FIXME(uwe):  Use deliver_now instead?
  def deliver_with_error!(mail)
    if inject_one_error
      self.class.inject_one_error = false
      raise 'Failed to send email' if ActionMailer::Base.raise_delivery_errors
    end
    deliver_without_error! mail
  end
  alias_method_chain :deliver!, :error
end
