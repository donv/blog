require 'redcloth'

module ApplicationHelper
  def r(textile)
    RedCloth.new(textile).to_html
  end

end
