class RemoveLogin < ActiveRecord::Migration
  def self.up
    remove_column :users, :login
  end

  def self.down
    add_column :users, :login, :string, :limit => 80, :null => false
  end
end
