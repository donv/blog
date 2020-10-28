# frozen_string_literal: true

module UserSystem
  CONFIG = {
    # Source address for user emails
    email_from: 'noreply@kubosch.no',

    # Destination email for system errors
    admin_email: '',

    # Sent in emails to users
    app_url: 'http://localhost:3000/',

    # Sent in emails to users
    app_name: 'Kubosch Blog',

    # Email charset
    mail_charset: 'utf-8',

    # Security token lifetime in hours
    security_token_life_hours: 24,

    # Two column form input
    two_column_input: true,

    # Add all changeable user fields to this array.
    # They will then be able to be edited from the edit action. You
    # should NOT include the email field in this array.
    changeable_fields: %w[first_name last_name],

    # Set to true to allow delayed deletes (i.e., delete of record
    # doesn't happen immediately after user selects delete account,
    # but rather after some expiration of time to allow this action
    # to be reverted).
    delayed_delete: false,

    # Default is one week
    delayed_delete_days: 7,

    # Server environment
    server_env: Rails.env.to_s
  }.freeze

  protected

  # overwrite this if you want to restrict access to only a few actions
  # or if you want to check if the user has the correct rights
  # example:
  #
  #  # only allow nonbobs
  #  def authorize?(user)
  #    user.login != "bob"
  #  end
  def authorize?(_user)
    true
  end

  # overwrite this method if you only want to protect certain actions of the controller
  # example:
  #
  #  # don't protect the login and the about method
  #  def protect?(action)
  #    if ['action', 'about'].include?(action)
  #       return false
  #    else
  #       return true
  #    end
  #  end
  def protect?(_action)
    true
  end

  # login_required filter. add
  #
  #   before_filter :login_required
  #
  # if the controller should be under any rights management.
  # for finer access control you can overwrite
  #
  #   def authorize?(user)
  #
  def login_required
    return true unless protect?(action_name)

    return true if user? && authorize?(session[:user])

    # store current location so that we can
    # come back after the user logged in
    store_location

    # call overwriteable reaction to unauthorized access
    access_denied
    false
  end

  # overwrite if you want to have special behavior in case the user is not authorized
  # to access the current operation.
  # the default action is to redirect to the login screen
  # example use :
  # a popup window might just close itself for instance
  def access_denied
    redirect_to controller: :users, action: :login
  end

  # store current uri in  the session.
  # we can return to this location by calling return_location
  def store_location
    session['return-to'] = request.path
  end

  # move to the last store_location call or to the passed default one
  def redirect_back_or_default(default)
    if session['return-to'].nil?
      redirect_to default
    else
      redirect_to session['return-to']
      session['return-to'] = nil
    end
  end

  def user?
    # First, is the user already authenticated?
    return true unless session['user'].nil?

    # If not, is the user being authenticated by a token?
    return false unless params['user']

    id = params['user']['id']
    key = params['key']
    if id && key
      session['user'] = User.authenticate_by_token(id, key)
      return true unless session['user'].nil?
    end

    # Everything failed
    false
  end
end
