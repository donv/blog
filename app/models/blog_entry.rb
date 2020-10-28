# frozen_string_literal: true

class BlogEntry < ApplicationRecord
  self.table_name = :blog_entries
  belongs_to :blog
  has_many :images, dependent: :restrict_with_error

  validates :blog_id, :title, :text, presence: true
  validates :blog, presence: { if: :blog_id }
end
