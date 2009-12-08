class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer   :post_id
      t.integer   :seqno, :null => false, :default => 0
      t.string    :title
      t.integer   :commenter_id, :null => false, :default => 0
      t.text      :body
      t.integer   :in_reply_to_seqno, :null => false, :default => 0
      t.integer   :agreed, :null => false, :default => 0
      t.integer   :disagreed, :null => false, :default => 0
      t.integer   :shared, :null => false, :default => 0
      t.timestamps
    end

    add_index :comments, [:post_id, :seqno]
  end

  def self.down
    drop_table :comments
  end
end
