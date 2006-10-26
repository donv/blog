require File.dirname(__FILE__) + '/../test_helper'
require 'blog_entries_controller'

# Re-raise errors caught by the controller.
class BlogEntriesController; def rescue_action(e) raise e end; end

class BlogEntriesControllerTest < Test::Unit::TestCase
  fixtures :blog_entries

  def setup
    @controller = BlogEntriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:blog_entries)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:blog_entry)
    assert assigns(:blog_entry).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:blog_entry)
  end

  def test_create
    num_blog_entries = BlogEntry.count

    post :create, :blog_entry => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_blog_entries + 1, BlogEntry.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:blog_entry)
    assert assigns(:blog_entry).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil BlogEntry.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      BlogEntry.find(1)
    }
  end
end
