class AddLocalDateToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :local_date, :string
    add_index :posts, [:title_hash, :local_date]
  end

  def self.down
    remove_column :posts, :local_date
  end
end
