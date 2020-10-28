# frozen_string_literal: true

class Blog < ApplicationRecord
  self.table_name = :blogs

  has_many :blog_entries, dependent: :restrict_with_error

  validates :title, presence: true
end
