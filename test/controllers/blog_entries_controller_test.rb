# frozen_string_literal: true

require 'test_helper'

module BlogEngine
  class BlogEntriesControllerTest < ActionController::TestCase
    # def setup
    #   login
    # end

    def test_index
      get :index
      assert_response :success
    end

    def test_show
      get :show, params: { id: blog_entries(:first).id }

      assert_response :success
    end

    def test_new
      get :new

      assert_response :success
    end

    def test_create
      num_blog_entries = BlogEntry.count

      post :create, params: { blog_entry: { blog_id: blogs(:first).id, datetime: DateTime.now, title: 'hello', text: 'content' } }

      assert_response :redirect

      assert_equal num_blog_entries + 1, BlogEntry.count
    end

    def test_edit
      get :edit, params: { id: blog_entries(:first).id }

      assert_response :success
    end

    def test_update
      post :update, params: { id: blog_entries(:first).id, blog_entry: { title: 'new title' } }
      assert_response :redirect
      assert_redirected_to action: :show, id: blog_entries(:first).id
    end

    def test_destroy
      assert_not_nil blog_entries(:first)

      post :destroy, params: { id: blog_entries(:first).id }
      assert_response :redirect
      assert_redirected_to action: :index

      assert_raise(ActiveRecord::RecordNotFound) do
        BlogEntry.find(1)
      end
    end
  end
end
