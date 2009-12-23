class AddDraftStatusAndPublishedAtToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :draft, :boolean, :null => false, :default => true
    add_column :posts, :published_at, :datetime
    add_index :posts, [:draft, :published_at, :id]
    add_index :posts, [:published_at, :id]
  end

  def self.down
    remove_column :posts, :draft
    remove_column :posts, :published_at
  end
end
