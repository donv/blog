require 'simplecov'
SimpleCov.start :rails

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

MiniTest::Reporters.use!

class ActiveSupport::TestCase
  fixtures :all

  def login
    session[:user] = users(:bob)
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
