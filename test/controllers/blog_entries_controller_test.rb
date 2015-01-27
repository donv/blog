require 'test_helper'

class BlogEntriesControllerTest < ActionController::TestCase
  def setup
    login
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:blog_entries)
  end

  def test_show
    get :show, id: blog_entries(:first).id

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

    post :create, blog_entry: {blog_id: blogs(:first).id, datetime: DateTime.now, title: 'hello', text: 'content'}

    assert_no_errors :blog_entry
    assert_response :redirect
    assert_redirected_to assigns(:blog_entry)

    assert_equal num_blog_entries + 1, BlogEntry.count
  end

  def test_edit
    get :edit, id: blog_entries(:first).id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:blog_entry)
    assert assigns(:blog_entry).valid?
  end

  def test_update
    post :update, id: blog_entries(:first).id, blog_entry: {title: 'new title'}
    assert_response :redirect
    assert_redirected_to action: :show, id: blog_entries(:first).id
  end

  def test_destroy
    assert_not_nil blog_entries(:first)

    post :destroy, id: blog_entries(:first).id
    assert_response :redirect
    assert_redirected_to action: :index

    assert_raise(ActiveRecord::RecordNotFound) {
      BlogEntry.find(1)
    }
  end
end
