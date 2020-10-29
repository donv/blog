# frozen_string_literal: true

module BlogEngine
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
