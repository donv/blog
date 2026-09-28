# frozen_string_literal: true

require 'test_helper'

module BlogEngine
  class BlogsControllerTest < ActionDispatch::IntegrationTest
    setup do
      login
    end

    def test_index
      get blog_engine.blogs_path
      assert_response :success
    end

    def test_show
      get blog_engine.blog_path(blogs(:first))
      assert_response :success
    end

    def test_show_lists_all_blogs_in_the_sidebar
      get blog_engine.blog_path(blogs(:first))
      assert_select 'title', "#{I18n.t(:blog)} - #{blogs(:first).title}"
      assert_select 'a[href=?]', blog_engine.blog_path(blogs(:another)), text: blogs(:another).title
      assert_select 'a[href=?]', blog_engine.new_blog_path
    end

    def test_new
      get blog_engine.new_blog_path
      assert_response :success
    end

    def test_create
      assert_difference('Blog.count') do
        post blog_engine.blogs_path, params: { blog: { title: 'new title' } }
      end
      assert_redirected_to blog_engine.root_path
    end

    def test_edit
      get blog_engine.edit_blog_path(blogs(:first))
      assert_response :success
    end

    def test_update
      patch blog_engine.blog_path(blogs(:first)), params: { blog: { title: 'new title' } }
      assert_redirected_to blog_engine.blog_path(blogs(:first))
      assert_equal 'new title', blogs(:first).reload.title
    end

    def test_destroy
      # A blog with entries refuses to be destroyed, so use the empty one.
      assert_difference('Blog.count', -1) do
        delete blog_engine.blog_path(blogs(:another))
      end
      assert_redirected_to blog_engine.root_path
    end

    def test_destroy_refuses_blog_with_entries
      assert_no_difference('Blog.count') do
        delete blog_engine.blog_path(blogs(:first))
      end
    end
  end
end
