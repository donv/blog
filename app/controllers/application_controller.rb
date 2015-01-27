class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UserSystem
  helper :user

  layout 'mwrt002'
  before_action :login_required, except: [:index, :show, :thumbnail]
  before_action :get_blogs

  private

  def get_blogs
    @blogs = Blog.all
  end

end
