class Image < ActiveRecord::Base
  belongs_to :blog_entry
  
  def picture=(picture_field)
	if picture_field.length != 0
	  self.picture_content_type = picture_field.content_type.chomp
      self.picture_data = picture_field.read
	end
  end
  
end
