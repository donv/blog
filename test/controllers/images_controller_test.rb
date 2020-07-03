require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  def setup
    login
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_show
    get :show, params:{id: images(:first).id}

    assert_response :success
  end

  def test_thumbnail
    get :thumbnail, params:{id: images(:first).id}

    assert_response :success
  end

  def test_new
    get :new, params:{blog_entry_id: blog_entries(:first)}

    assert_response :success
  end

  def test_create
    num_images = Image.count

    post :create, params:{image: {blog_entry_id: blog_entries(:first).id, picture_content_type: 'image/png'}}

    assert_response :redirect
    assert_redirected_to blog_entries(:first)

    assert_equal num_images + 1, Image.count
  end

  def test_edit
    get :edit, params:{id: images(:first).id}

    assert_response :success

  end

  def test_update
    post :update, params:{id: images(:first).id, image: {picture_content_type: 'image/png'}}
    assert_response :redirect
    assert_redirected_to :action => 'show', id: images(:first).id
  end

  def test_destroy
    assert_not_nil images(:first)

    post :destroy, params:{id: images(:first).id}
    assert_response :redirect
    assert_redirected_to action: :index

    assert_raise(ActiveRecord::RecordNotFound) {
      Image.find(1)
    }
  end
end
