require 'redcloth'

module ApplicationHelper
  include Localization

  def r(textile)
    RedCloth.new(textile).to_html
  end
  
end
