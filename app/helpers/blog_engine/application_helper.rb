# frozen_string_literal: true

require 'redcloth'

module BlogEngine
  module ApplicationHelper
    def r(textile)
      RedCloth.new(textile).to_html.html_safe # rubocop: disable Rails/OutputSafety
    end
  end
end
