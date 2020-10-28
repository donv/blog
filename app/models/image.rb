# frozen_string_literal: true

class Image < ApplicationRecord
  self.table_name = :images

  belongs_to :blog_entry

  validates :blog_entry_id, presence: true
  validates :blog_entry, presence: { if: :blog_entry_id }

  def picture=(picture_field)
    return if picture_field.empty?

    self.picture_content_type = picture_field.content_type.chomp
    self.picture_data = picture_field.read
  end
end
