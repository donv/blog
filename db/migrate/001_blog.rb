class Blog < ActiveRecord::Migration
  def self.up
    create_table 'blogs' do |table|
      table.column :datetime, :datetime, :null => false
      table.column :title, :string, :limit => 64, :null => false
      table.column :text, :text, :null => false
    end
  end

  def self.down
    drop_table :blogs
  end
end
