# frozen_string_literal: true

module BlogEngine
  class UserNotifyMailer < ApplicationMailer
    default from: UserSystem::CONFIG[:email_from].to_s

    def prefix(title)
      "[#{UserSystem::CONFIG[:app_name]}] #{title}"
    end

    def signup(user, password, url = nil)
      @name = "#{user.first_name} #{user.last_name}"
      @login = user.email
      @password = password
      @url = url || UserSystem::CONFIG[:app_url].to_s
      @app_name = UserSystem::CONFIG[:app_name].to_s

      mail subject: prefix("Welcome to #{UserSystem::CONFIG[:app_name]}!"),
           to: user.email
    end

    def forgot_password(user, url = nil)
      @name = "#{user.first_name} #{user.last_name}"
      @url = url || UserSystem::CONFIG[:app_url].to_s
      @app_name = UserSystem::CONFIG[:app_name].to_s

      mail subject: prefix('Forgotten password notification'), to: user.email
    end

    def change_password(user, password, url = nil)
      @user = user
      @name = "#{user.first_name} #{user.last_name}"
      @password = password
      @url = url || UserSystem::CONFIG[:app_url].to_s
      @app_name = UserSystem::CONFIG[:app_name].to_s

      mail subject: prefix('Changed password notification'), to: user.email
    end

    def pending_delete(user, url = nil)
      @name = "#{user.first_name} #{user.last_name}"
      @url = url || UserSystem::CONFIG[:app_url].to_s
      @app_name = UserSystem::CONFIG[:app_name].to_s
      @days = UserSystem::CONFIG[:delayed_delete_days].to_s

      mail subject: prefix('Delete user notification'), to: user.email
    end

    def delete(user, url = nil)
      @name = "#{user.first_name} #{user.last_name}"
      @url = url || UserSystem::CONFIG[:app_url].to_s
      @app_name = UserSystem::CONFIG[:app_name].to_s

      mail subject: prefix('Delete user notification'), to: user.email
    end
  end
end
