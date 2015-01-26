require 'test_helper'

class BlogsControllerTest < ActionController::TestCase
  def setup
    login
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'show'
  end

  def test_show
    get :show, id: blogs(:first)

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:blog)
    assert assigns(:blog).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:blog)
  end

  def test_create
    num_blogs = Blog.count

    post :create, blog: {title: 'new title'}

    assert_no_errors :blog
    assert_response :redirect
    assert_redirected_to action: :list

    assert_equal num_blogs + 1, Blog.count
  end

  def test_edit
    get :edit, id: blogs(:first).id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:blog)
    assert assigns(:blog).valid?
  end

  def test_update
    post :update, id: blogs(:first).id, blog: {title: 'new title'}
    assert_response :redirect
    assert_redirected_to action: :show, id: blogs(:first).id
  end

  def test_destroy
    assert_not_nil blogs(:first)

    post :destroy, id: blogs(:first).id
    assert_response :redirect
    assert_redirected_to action: :list

    assert_raise(ActiveRecord::RecordNotFound) {
      Blog.find(blogs(:first).id)
    }
  end
end
