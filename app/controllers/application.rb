require 'localization'

class ApplicationController < ActionController::Base
  include Localization
  layout 'mwrt002'
  before_filter :get_blogs
  
  private
  def get_blogs
    @blogs = Blog.find_all
  end
  
end