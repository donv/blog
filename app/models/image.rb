class Image < ActiveRecord::Base
  belongs_to :blog_entry

  validates_presence_of :blog_entry_id
  validates_presence_of :blog_entry, if: :blog_entry_id

  def picture=(picture_field)
	if picture_field.length != 0
	  self.picture_content_type = picture_field.content_type.chomp
      self.picture_data = picture_field.read
	end
  end
  
end
