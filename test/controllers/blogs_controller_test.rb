# frozen_string_literal: true

require 'test_helper'

module BlogEngine
  class BlogsControllerTest < ActionController::TestCase
    # def setup
    #   login
    # end

    def test_index
      get :index
      assert_response :success
    end

    def test_show
      get :show, params: { id: blogs(:first) }

      assert_response :success
    end

    def test_new
      get :new

      assert_response :success
    end

    def test_create
      num_blogs = Blog.count

      post :create, params: { blog: { title: 'new title' } }

      assert_response :redirect
      assert_redirected_to action: :index

      assert_equal num_blogs + 1, Blog.count
    end

    def test_edit
      get :edit, params: { id: blogs(:first).id }

      assert_response :success
    end

    def test_update
      post :update, params: { id: blogs(:first).id, blog: { title: 'new title' } }
      assert_response :redirect
      assert_redirected_to action: :show, id: blogs(:first).id
    end

    def test_destroy
      assert_not_nil blogs(:first)

      post :destroy, params: { id: blogs(:first).id }
      assert_response :redirect
      assert_redirected_to action: :index

      assert_raise(ActiveRecord::RecordNotFound) do
        Blog.find(blogs(:first).id)
      end
    end
  end
end
