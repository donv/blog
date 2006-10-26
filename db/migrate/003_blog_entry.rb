class BlogEntry < ActiveRecord::Migration
  def self.up
    rename_table :blogs, :blog_entries
    create_table 'blogs' do |table|
      table.column :title, :string, :limit => 64, :null => false
    end
    execute "INSERT INTO blogs (id,title) VALUES (1,'OOPSLA 2006')"
    add_column :blog_entries, :blog_id, :integer, :null => false, :default => 1
    rename_column :images, :blog_id, :blog_entry_id
  end

  def self.down
    remove_column :blog_entries, :blog_id
    drop_table :blogs
    rename_table :blog_entries, :blogs
  end
end
