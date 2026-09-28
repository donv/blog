# frozen_string_literal: true

require 'test_helper'

module BlogEngine
  class BlogEntriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      login
    end

    def test_index
      get blog_engine.blog_entries_path
      assert_response :success
    end

    def test_show
      get blog_engine.blog_entry_path(blog_entries(:first))
      assert_response :success
    end

    def test_show_links_thumbnails_to_the_full_size_images
      get blog_engine.blog_entry_path(blog_entries(:first))
      assert_response :success
      blog_entries(:first).images.each do |image|
        assert_select "a[href='#{blog_engine.image_path(image)}'] img[src='#{blog_engine.thumbnail_image_path(image)}']"
      end
    end

    def test_new
      get blog_engine.new_blog_entry_path
      assert_response :success
    end

    def test_create
      assert_difference('BlogEntry.count') do
        post blog_engine.blog_entries_path,
             params: { blog_entry: { blog_id: blogs(:first).id, datetime: Time.zone.now, title: 'hello', text: 'content' } }
      end
      assert_redirected_to blog_engine.blog_entry_path(BlogEntry.last)
    end

    def test_edit
      get blog_engine.edit_blog_entry_path(blog_entries(:first))
      assert_response :success
    end

    def test_update
      patch blog_engine.blog_entry_path(blog_entries(:first)), params: { blog_entry: { title: 'new title' } }
      assert_redirected_to blog_engine.blog_entry_path(blog_entries(:first))
      assert_equal 'new title', blog_entries(:first).reload.title
    end

    def test_destroy
      # An entry with images refuses to be destroyed, so use the one without.
      assert_difference('BlogEntry.count', -1) do
        delete blog_engine.blog_entry_path(blog_entries(:another))
      end
      assert_redirected_to blog_engine.blog_entries_path
    end
  end
end
