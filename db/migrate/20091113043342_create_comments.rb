class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer   :post_id
      t.integer   :seqno
      t.string    :title
      t.integer   :commenter_id
      t.text      :body
      t.integer   :in_reply_to_seqno
      t.integer   :agreed
      t.integer   :disagreed
      t.integer   :shared
      t.timestamps
    end

    add_index :comments, [:post_id, :seqno]
  end

  def self.down
    drop_table :comments
  end
end
