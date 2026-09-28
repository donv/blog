# frozen_string_literal: true

module AuthenticatedSystem
  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  protected

  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    !current_user.nil?
  end

  # Accesses the current user from the session.
  def current_user
    @current_user ||= session[:user] && User.find_by(id: session[:user])
  end

  # Store the given user in the session.
  def current_user=(new_user)
    session[:user] = new_user.nil? || new_user.is_a?(Symbol) ? nil : new_user.id
    @current_user = new_user
  end

  # Check if the user is authorized.
  #
  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the user
  # has the correct rights.
  #
  # Example:
  #
  #  # only allow nonbobs
  #  def authorize?
  #    current_user.login != "bob"
  #  end
  def authorized?
    true
  end

  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  def login_required
    username, passwd = auth_data
    self.current_user ||= User.authenticate(username, passwd) if username && passwd
    (logged_in? && authorized?) || access_denied
  end

  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    respond_to do |format|
      format.html do
        store_location
        redirect_to main_app.account_login_path
      end
      format.any { request_http_basic_authentication('Web Password') }
    end
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.fullpath
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    redirect_to(session.delete(:return_to) || default)
  end

  # Name of the cookie holding the remember-me token. Like the session cookie, it is issued for the
  # whole domain so that one login covers all subdomains.
  REMEMBER_COOKIE = :remember_token

  # When called with before_action :login_from_cookie will check for a remember-me
  # cookie and log the user back in if apropriate
  def login_from_cookie
    return unless cookies[REMEMBER_COOKIE] && !logged_in?

    user = User.find_by(remember_token: cookies[REMEMBER_COOKIE])
    return unless user&.remember_token?

    user.remember_me
    self.current_user = user
    remember_current_user
    flash[:notice] = 'Logged in successfully'
  end

  def remember_current_user
    cookies[REMEMBER_COOKIE] = { value: current_user.remember_token,
                                 expires: current_user.remember_token_expires_at,
                                 domain: :all, httponly: true }
  end

  def forget_current_user
    cookies.delete REMEMBER_COOKIE, domain: :all
  end

  HTTP_AUTH_HEADERS = %w[X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization].freeze

  private

  # gets BASIC auth info
  def auth_data
    auth_key  = HTTP_AUTH_HEADERS.detect { |h| request.env.key?(h) }
    auth_data = request.env[auth_key].to_s.split if auth_key.present?
    auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil]
  end
end
