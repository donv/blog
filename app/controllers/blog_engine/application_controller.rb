# frozen_string_literal: true

module BlogEngine
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include AuthenticatedSystem

    # include UserSystem

    layout 'mwrt002'
    before_action :login_required
    before_action :load_blogs

    private

    def load_blogs
      @blogs = Blog.all
    end
  end
end
