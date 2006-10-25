# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 2) do

  create_table "blogs", :force => true do |t|
    t.column "datetime", :datetime, :null => false
    t.column "title", :string, :limit => 64, :default => "", :null => false
    t.column "text", :text, :default => "", :null => false
  end

  create_table "images", :force => true do |t|
    t.column "blog_id", :integer, :default => 0, :null => false
    t.column "picture_data", :binary
    t.column "picture_content_type", :string, :limit => 100
  end

end
