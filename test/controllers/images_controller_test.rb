require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  def setup
    login
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

    assert_not_nil assigns(:images)
  end

  def test_show
    get :show, id: images(:first).id

    assert_response :success
    assert_template nil
  end

  def test_new
    get :new, blog_entry_id: blog_entries(:first)

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:image)
  end

  def test_create
    num_images = Image.count

    post :create, image: {blog_entry_id: blog_entries(:first).id, picture_content_type: 'image/png'}

    assert_no_errors :image
    assert_response :redirect
    assert_redirected_to blog_entries(:first)

    assert_equal num_images + 1, Image.count
  end

  def test_edit
    get :edit, id: images(:first).id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:image)
    assert assigns(:image).valid?
  end

  def test_update
    post :update, id: images(:first).id, image: {picture_content_type: 'image/png'}
    assert_response :redirect
    assert_redirected_to :action => 'show', id: images(:first).id
  end

  def test_destroy
    assert_not_nil images(:first)

    post :destroy, id: images(:first).id
    assert_response :redirect
    assert_redirected_to action: :list

    assert_raise(ActiveRecord::RecordNotFound) {
      Image.find(1)
    }
  end
end
