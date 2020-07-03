class UsersController < ApplicationController
  skip_before_action :login_required, only: [:forgot_password, :login, :signup]

  def login
    return if generate_blank
    @user = User.new(user_params)
    if session['user'] = User.authenticate(params['user']['email'], params['user']['password'])
      flash['notice'] = t(:user_login_succeeded)
      redirect_back_or_default controller: 'blogs', action: 'index'
    else
      @login = params['user']['login']
      flash.now['message'] = t(:user_login_failed)
    end
  end

  def signup
    return if generate_blank
    params[:user].delete(:form)
    @user = User.new(user_params)
    begin
      User.transaction do
        @user.new_password = true
        if @user.save
          key = @user.generate_security_token
          url = url_for(action: :welcome)
          url += "?user[id]=#{@user.id}&key=#{key}"
          UserNotify.signup(@user, params[:user][:password], url).deliver_now
          flash[:notice] = t(:user_signup_succeeded)
          redirect_to action: :login
        end
      end
    rescue Exception => e
      logger.error "Exception: #{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
      flash.now[:message] = t(:user_confirmation_email_error)
    end
  end

  def logout
    session['user'] = nil
    redirect_to controller: :blogs, action: :index
  end

  def change_password
    return if generate_filled_in
    params[:user].delete(:form)
    begin
      User.transaction do
        @user.change_password(params[:user][:password], params[:user][:password_confirmation])
        if @user.save
          UserNotify.change_password(@user, params[:user][:password]).deliver_now
          flash.now[:notice] = t(:user_updated_password, s: "#{@user.email}")
        end
      end
    rescue
      flash.now[:message] = t(:user_change_password_email_error)
    end
  end

  def forgot_password
    # Always redirect if logged in
    if user?
      flash[:message] = t(:user_forgot_password_logged_in)
      redirect_to action: :change_password
      return
    end

    # Render on :get and render
    return if generate_blank

    # Handle the :post
    if params[:user][:email].empty?
      flash.now[:message] = t(:user_enter_valid_email_address)
    elsif (user = User.find_by_email(params[:user][:email])).nil?
      flash.now[:message] = t(:user_email_address_not_found, s: "#{params[:user][:email]}")
    else
      begin
        User.transaction do
          key = user.generate_security_token
          url = url_for(action: :change_password, user: {id: user.id}, key: key)
          UserNotify.forgot_password(user, url).deliver_now
          flash[:notice] = t(:user_forgotten_password_emailed, s: "#{params[:user][:email]}")
          unless user?
            redirect_to login_users_path
            return
          end
          redirect_back_or_default action: :welcome
        end
      rescue
        flash.now[:message] = t(:user_forgotten_password_email_error, s: "#{params['user']['email']}")
      end
    end
  end

  def edit
    return if generate_filled_in
    if params['user']['form']
      form = params['user'].delete('form')
      case form
      when 'edit'
        changeable_fields = %w(first_name last_name)
        safe_params = params.require(:user).permit(changeable_fields)
        @user.attributes = safe_params
        @user.save
      when 'change_password'
        change_password
      when 'delete'
        delete
      else
        raise 'unknown edit action'
      end
    end
  end

  def delete
    @user = session['user']
    begin
      if UserSystem::CONFIG[:delayed_delete]
        User.transaction do
          key = @user.set_delete_after
          url = url_for(action: 'restore_deleted')
          url += "?user[id]=#{@user.id}&key=#{key}"
          UserNotify.pending_delete(@user, url).deliver_now
        end
      else
        destroy(@user)
      end
      logout
    rescue
      flash.now[:message] = t(:user_delete_email_error)
      redirect_back_or_default action: :welcome
    end
  end

  def restore_deleted
    @user = session['user']
    @user.deleted = 0
    if not @user.save
      flash.now['notice'] = t(:user_restore_deleted_error, "#{@user['login']}")
      redirect_to :action => 'login'
    else
      redirect_to :action => 'welcome'
    end
  end

  def welcome
  end

  protected

  def destroy(user)
    user.destroy
    flash[:notice] = t(:user_delete_finished, s: "#{user.email}")
    UserNotify.delete(user).deliver_now
  end

  def protect?(action)
    if ['login', 'signup', 'forgot_password'].include?(action)
      return false
    else
      return true
    end
  end

  # Generate a template user for certain actions on get
  def generate_blank
    case request.method
    when 'GET'
      @user = User.new
      render
      return true
    end
    return false
  end

  # Generate a template user for certain actions on get
  def generate_filled_in
    @user = session['user']
    case request.method
    when :get
      render
      return true
    end
    return false
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
