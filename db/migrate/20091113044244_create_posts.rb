class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer   :poster_id
      t.string    :title
      t.text      :body
      t.integer   :comments_count, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
