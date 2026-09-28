# frozen_string_literal: true

require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  def test_protected_page_sends_a_visitor_to_the_login_page_and_remembers_where_they_were
    get blog_engine.new_blog_path
    assert_redirected_to '/account/login'
    assert_equal blog_engine.new_blog_path, request.session[:return_to]
  end

  def test_remember_me_cookie_logs_the_visitor_in
    user = users(:bob)
    user.remember_me
    cookies[:auth_token] = user.remember_token
    get blog_engine.new_blog_path
    assert_response :success
  end
end
