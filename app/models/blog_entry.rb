class BlogEntry < ActiveRecord::Base
  belongs_to :blog
  has_many :images

  validates_presence_of :blog_id, :title, :text
  validates_presence_of :blog, if: :blog_id
end
