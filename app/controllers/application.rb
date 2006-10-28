require 'user_system'
require 'localization'
require 'redcloth'

class ApplicationController < ActionController::Base
  include Localization
  include UserSystem
  helper :user
  model :user
  layout 'mwrt002'
  before_filter :login_required, :except => [:index, :show, :thumbnail]
  before_filter :get_blogs
  
  private
  def get_blogs
    @blogs = Blog.find_all
  end
  
end