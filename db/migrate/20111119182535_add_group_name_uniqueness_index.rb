class AddGroupNameUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :groups, :name, :unique => true
  end

  def self.down
    remove_index :groups, :name
  end
end
