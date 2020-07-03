require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    Mail::TestMailer.inject_one_error = false
    ActionMailer::Base.deliveries = []
  end

  def test_auth_bob
    session['return-to'] = '/bogus/location'

    post :login, params:{user: {email: 'bob@test.com', password: 'atest'}}
    assert session[:user]

    assert_equal users(:bob), session['user']

    assert_redirected_to "http://#{@request.host}/bogus/location"
  end

  def do_test_signup(bad_password, bad_email)
    session['return-to'] = '/bogus/location'

    if not bad_password and not bad_email
      post :signup, params:{user: {password: 'newpassword', password_confirmation: 'newpassword', email: 'newbob@test.com'}}
      assert_nil session[:user]

      assert_redirected_to(@controller.url_for(action: :login))
      assert_equal 1, ActionMailer::Base.deliveries.size
      mail = ActionMailer::Base.deliveries[0]
      assert_equal 'newbob@test.com', mail.to_addrs[0].to_s
      assert_match /login:\s+newbob@test\.com\n/, mail.decoded
      assert_match /password:\s+\w+\n/, mail.decoded
      mail.encoded =~ /key=(.*?)"/
      key = $1

      user = User.find_by_email('newbob@test.com')
      assert_not_nil user
      assert_equal 0, user.verified

      # First past the expiration.
      Timecop.freeze(1.days.from_now) do
        get :welcome, params:{user: {id: "#{user.id}"}, key: "#{key}"}
      end
      user = User.find_by_email('newbob@test.com')
      assert_equal 0, user.verified

      # Then a bogus key.
      get :welcome, params:{user: {id: "#{user.id}"}, key: 'boguskey'}
      user = User.find_by_email('newbob@test.com')
      assert_equal 0, user.verified

      # Now the real one.
      get :change_password, params:{user: {id: "#{user.id}"}, key: "#{key}"}
      user = User.find_by_email('newbob@test.com')
      assert_equal 1, user.verified

      post :login, params:{user: {email: 'newbob@test.com', password: 'newpassword'}}
      assert_equal user, session['user']
      get :logout
    elsif bad_password
      post :signup, params:{user: {login: 'newbob', password: 'bad', password_confirmation: 'bad', email: 'newbob@test.com'}}
      assert_nil session[:user]
      assert_response :success
      assert_equal 0, ActionMailer::Base.deliveries.size
    elsif bad_email
      Mail::TestMailer.inject_one_error = true
      post :signup, params:{user: {login: 'newbob', password: 'newpassword', password_confirmation: 'newpassword', email: 'newbob@test.com'}}
      assert_nil session[:user]
      assert_equal 0, ActionMailer::Base.deliveries.size
    else
      # Invalid test case
      assert false
    end
  end

  def test_signup
    do_test_signup(true, false)
    do_test_signup(false, true)
    do_test_signup(false, false)
  end

  def test_edit
    post :login, params:{user: {email: 'bob@test.com', password: 'atest'}}
    assert session[:user]

    post :edit, params:{user: {first_name: 'Bob', form: 'edit'}}
    assert_equal session['user'].first_name, 'Bob'

    post :edit, params:{user: {first_name: '', form: 'edit'}}
    assert_equal session['user'].first_name, ''

    get :logout
  end

  def test_delete
    # Immediate delete
    post :login, params:{user: {email: 'deletebob1@test.com', password: 'alongtest'}}
    assert session[:user]

    UserSystem::CONFIG[:delayed_delete] = false
    post :edit, params:{user: {form: 'delete'}}
    assert_equal 1, ActionMailer::Base.deliveries.size

    assert_nil session[:user]
    post :login, params:{user: {login: 'deletebob1', password: 'alongtest'}}
    assert_nil session[:user]

    # Now try delayed delete
    ActionMailer::Base.deliveries = []

    post :login, params:{user: {email: 'deletebob2@test.com', password: 'alongtest'}}
    assert session[:user]

    UserSystem::CONFIG[:delayed_delete] = true
    post :edit, params:{user: {form: 'delete'}}
    assert_equal 1, ActionMailer::Base.deliveries.size
    mail = ActionMailer::Base.deliveries[0]
    assert (mail.encoded =~ /user\[id\]=([^"&]+)/),
        'Unable to find user id in email.'
    id = $1
    assert (mail.encoded =~ /key=([^"&]+)"/),
        'Unable to find key in email.'
    key = $1
    post :restore_deleted, params:{user: {id: "#{id}"}, key: 'badkey'}
    assert_nil session[:user]

    # Advance the time past the delete date
    Timecop.freeze(UserSystem::CONFIG[:delayed_delete_days].days.from_now) do
      post :restore_deleted, params:{user: {id: "#{id}"}, key: "#{key}"}
      assert_nil session[:user]
    end

    post :restore_deleted, params:{user: {id: "#{id}"}, key: "#{key}"}
    assert session[:user]
    get :logout
  end

  def do_change_password(bad_password, bad_email)
    ActionMailer::Base.deliveries = []
    post :login, params:{user: {email: 'bob@test.com', password: 'atest'}}
    assert session[:user]

    if not bad_password and not bad_email
      post :change_password, params:{user: {password: 'changed_password', password_confirmation: 'changed_password'}}
      assert_equal 1, ActionMailer::Base.deliveries.size
      mail = ActionMailer::Base.deliveries[0]
      assert_equal 'bob@test.com', mail.to_addrs[0].to_s
      assert_match /login:\s+bob@test\.com\n/, mail.decoded
      assert_match /password:\s+\w+\n/, mail.decoded
    elsif bad_password
      post :change_password, params:{user: {password: 'bad', password_confirmation: 'bad'}}
      assert_response :success
      assert_equal 0, ActionMailer::Base.deliveries.size
    elsif bad_email
      Mail::TestMailer.inject_one_error = true
      post :change_password, params:{:user => {:password => 'changed_password', :password_confirmation => 'changed_password'}}
      assert_equal 0, ActionMailer::Base.deliveries.size
    else
      # Invalid test case
      assert false
    end

    get :logout
    assert_nil session[:user]

    if not bad_password and not bad_email
      post :login, params:{user: {email: 'bob@test.com', password: 'changed_password'}}
      assert session[:user]
      post :change_password, params:{user: {password: 'atest', password_confirmation: 'atest'}}
      get :logout
    end

    post :login, params:{user: {email: 'bob@test.com', password: 'atest'}}
    assert session[:user]

    get :logout
  end

  def test_change_password
    do_change_password(false, false)
    do_change_password(true, false)
    do_change_password(false, true)
  end

  def do_forgot_password(bad_address, bad_email, logged_in)
    ActionMailer::Base.deliveries = []

    if logged_in
      post :login, params:{user: {email: 'bob@test.com', password: 'atest'}}
      assert session[:user]
    end

    session['return-to'] = '/bogus/location'
    if not bad_address and not bad_email
      post :forgot_password, params:{user: {email: 'bob@test.com'}}
      password = 'anewpassword'
      if logged_in
        assert_equal 0, ActionMailer::Base.deliveries.size
        assert_redirected_to(@controller.url_for(action: :change_password))
        post :change_password, params:{user: {password: "#{password}", password_confirmation: "#{password}"}}
      else
        assert_equal 1, ActionMailer::Base.deliveries.size
        mail = ActionMailer::Base.deliveries[0]
        assert_equal 'bob@test.com', mail.to_addrs[0].to_s
        assert mail.decoded =~ /user%5Bid%5D=(\d*)/
        id = $1
        assert mail.decoded =~ /key=([0-9a-f]*)/
        key = $1
        post :change_password, params:{user: {password: "#{password}", password_confirmation: "#{password}", id: "#{id}"}, key: "#{key}"}
        assert session[:user]
        get :logout
      end
    elsif bad_address
      post :forgot_password, params:{user: {email: 'bademail@test.com'}}
      assert_equal 0, ActionMailer::Base.deliveries.size
    elsif bad_email
      Mail::TestMailer.inject_one_error = true
      post :forgot_password, params:{user: {email: 'bob@test.com'}}
      assert_equal 0, ActionMailer::Base.deliveries.size
    else
      # Invalid test case
      assert false
    end

    if not bad_address and not bad_email
      if logged_in
        get :logout
      else
        assert_redirected_to(controller: :blogs, action: :index)
      end
      post :login, params:{user: {email: 'bob@test.com', password: "#{password}"}}
    else
      # Okay, make sure the database did not get changed
      if logged_in
        get :logout
      end
      post :login, params:{user: {email: 'bob@test.com', password: 'atest'}}
    end

    assert session[:user]

    # Put the old settings back
    if not bad_address and not bad_email
      post :change_password, params:{user: {password: 'atest', password_confirmation: 'atest'}}
    end

    get :logout
  end

  def test_forgot_password
    do_forgot_password(false, false, false)
    do_forgot_password(false, false, true)
    do_forgot_password(true, false, false)
    do_forgot_password(false, true, false)
  end

  def test_bad_signup
    session['return-to'] = "/bogus/location"

    post :signup, params:{"user" => {"login" => "newbob", "password" => "newpassword", "password_confirmation" => "wrong"}}
    assert_response :success

    post :signup, params:{"user" => {"login" => "yo", "password" => "newpassword", "password_confirmation" => "newpassword"}}
    assert_response :success

    post :signup, params:{"user" => {"login" => "yo", "password" => "newpassword", "password_confirmation" => "wrong"}}
    assert_response :success
  end

  def test_invalid_login
    post :login, params:{"user" => {"login" => "bob", "password" => "not_correct"}}

    assert_nil session[:user]
  end

  def test_login_logoff

    post :login, params:{user: {email: 'bob@test.com', password: 'atest'}}
    assert session[:user]

    get :logout
    assert_nil session[:user]

  end

end
