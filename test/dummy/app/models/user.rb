# frozen_string_literal: true

# Minimal stand-in for the host application's User model, which the engine depends on.
class User < ApplicationRecord
  def self.authenticate(email, _password)
    find_by(email: email)
  end

  def login
    email
  end
end
