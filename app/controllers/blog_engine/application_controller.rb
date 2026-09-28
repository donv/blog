# frozen_string_literal: true

module BlogEngine
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include AuthenticatedSystem

    before_action :login_required
    before_action :populate_layout

    private

    # The host application renders the engine inside its own layout, which shows @application_title
    # as the page heading and @sidebars in the right column.
    def populate_layout
      @application_title = t(:blog)
      @blogs = Blog.all
      @sidebars = [{ title: t(:blogs), content: view_context.render(partial: 'blog_engine/shared/blogs_sidebar') }]
    end
  end
end
