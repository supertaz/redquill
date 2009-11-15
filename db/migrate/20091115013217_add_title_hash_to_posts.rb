class AddTitleHashToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :title_hash, :string, :null => false, :default => ''
  end

  def self.down
    remove_column :posts, :title_hash
  end
end
