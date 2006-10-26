class BlogEntry < ActiveRecord::Base
  belongs_to :blog
  has_many :images
end
