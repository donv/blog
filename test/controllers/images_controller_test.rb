# frozen_string_literal: true

require 'test_helper'

module BlogEngine
  class ImagesControllerTest < ActionDispatch::IntegrationTest
    setup do
      login
    end

    def test_index
      get blog_engine.images_path
      assert_response :success
    end

    def test_show
      get blog_engine.image_path(images(:first))
      assert_response :success
    end

    def test_thumbnail
      get blog_engine.thumbnail_image_path(images(:first))
      assert_response :success
    end

    def test_new
      get blog_engine.new_image_path(blog_entry_id: blog_entries(:first).id)
      assert_response :success
    end

    def test_create
      assert_difference('Image.count') do
        post blog_engine.images_path, params: { image: { blog_entry_id: blog_entries(:first).id } }
      end
      assert_redirected_to blog_engine.blog_entry_path(blog_entries(:first))
    end

    def test_edit
      get blog_engine.edit_image_path(images(:first))
      assert_response :success
    end

    def test_update
      patch blog_engine.image_path(images(:first)), params: { image: { blog_entry_id: blog_entries(:first).id } }
      assert_redirected_to blog_engine.image_path(images(:first))
    end

    def test_destroy
      assert_difference('Image.count', -1) do
        delete blog_engine.image_path(images(:first))
      end
      assert_redirected_to blog_engine.images_path
    end
  end
end
