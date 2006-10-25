class Images < ActiveRecord::Migration
  def self.up
    create_table :images do |table|
      table.column :blog_id, :integer, :null => false
      table.column "picture_data", :binary, :limit => 10000000
      table.column "picture_content_type", :string, :limit => 100
    end
  end

  def self.down
    drop_table :images
  end
end
