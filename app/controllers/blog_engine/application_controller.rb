# frozen_string_literal: true

module BlogEngine
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    include AuthenticatedSystem
    # include UserSystem

    layout 'mwrt002'
    before_action :login_required, except: %i[index show thumbnail] # rubocop: disable Rails/LexicallyScopedActionFilter
    before_action :load_blogs

    private

    def load_blogs
      @blogs = Blog.all
    end
  end
end
